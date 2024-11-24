-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2024 at 10:02 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant_copy`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `detailReservasiPelanggan` (IN `nama_pelanggan` VARCHAR(255))   BEGIN 
	SELECT Reservasi.Id_reservasi, Reservasi.tanggal_reservasi, Reservasi.waktu_reservasi, Meja.No_meja, Meja.Kapasitas, Pelanggan.nama_pelanggan, Pelanggan.nomor_telepon, (SELECT Karyawan.nama_karyawan FROM Karyawan WHERE Karyawan.Id_karyawan = Pelanggan.id_karyawan) AS nama_karyawan FROM Reservasi JOIN Meja ON Reservasi.Id_meja = Meja.Id_meja JOIN Pelanggan ON Reservasi.Id_pelanggan = Pelanggan.Id_pelanggan WHERE Pelanggan.nama_pelanggan = nama_pelanggan ORDER BY Reservasi.tanggal_reservasi, Reservasi.waktu_reservasi; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputKaryawan` (IN `nama` VARCHAR(255), `posisi` TEXT)   BEGIN 
	INSERT INTO karyawan(Nama_Karyawan, Posisi) VALUES(nama, posisi); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputMeja` (IN `nomor` INT, `kapasitas` INT)   BEGIN 
	INSERT INTO meja(No_Meja, Kapasitas) VALUES(nomor, kapasitas); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputMenu` (IN `nama` VARCHAR(255), `harga` INT)   BEGIN 
	INSERT INTO menu(Nama_Menu, Harga) VALUES(nama, harga); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputMenuPesanan` (IN `idPesanan` INT, `idMenu` INT, `jumlah` INT)   BEGIN 
	INSERT INTO jumlah_menu_pesanan(ID_Pesanan, ID_Menu, Jumlah) VALUES(idPesanan, idMenu, jumlah); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputPelanggan` (`nama` VARCHAR(255), `nomor_telepon` VARCHAR(20), `id_karyawan` INT)   BEGIN 
	INSERT INTO pelanggan(Nama_Pelanggan, Nomor_Telepon, ID_Karyawan) VALUES(nama, nomor_telepon, id_karyawan); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputPembayaran` (IN `metodePembayaran` VARCHAR(255), `idPesanan` INT)   BEGIN
	SET @total_harga = 0;
	CALL totalHarga(idPesanan, @total_harga);
    INSERT INTO pembayaran(Total_Harga , Metode_Pembayaran, ID_pesanan) 
    VALUES(@total_harga, metodePembayaran, idPesanan);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InputPesanan` (IN `idPelanggan` INT, `idMeja` INT, `makanDitempat` BOOLEAN)   BEGIN 
	INSERT INTO pesanan(ID_Pelanggan , ID_Meja, Makan_ditempat) 
	VALUES(idPelanggan, idMeja, makanDitempat); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InputReservasi` (IN `idPelanggan` INT, `waktuReservasi` DATETIME, `idMeja` INT)   BEGIN 
	INSERT INTO reservasi(ID_Pelanggan, Waktu_Reservasi, ID_Meja) VALUES(idPelanggan, waktuReservasi, idMeja); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InputShift` (`hari` VARCHAR(255), `jamMulai` TIME, `jamSelesai` TIME)   BEGIN 
	INSERT INTO shift(Hari, Jam_Mulai, Jam_Selesai) 
	VALUES(hari, jamMulai, JamSelesai); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inputShiftKaryawan` (IN `idKaryawan` INT, `idShift` INT)   BEGIN 
	INSERT INTO karyawan_menjalani_shift(ID_Karyawan, ID_Shift) VALUES(idKaryawan, idShift); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mencariMenuDipesanByIDPelanggan` (IN `customer_id` INT)   BEGIN 
	SELECT menu.Nama_Menu, menu.harga, jumlah_menu_pesanan.Jumlah FROM Pesanan p INNER JOIN jumlah_menu_pesanan ON p.ID_Pesanan = jumlah_menu_pesanan.ID_Pesanan INNER JOIN menu ON jumlah_menu_pesanan.ID_Menu = menu.ID_Menu WHERE p.ID_Pelanggan = customer_id; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MencariMenuDipesanByIDPesanan` (IN `id_pesanan` INT)   BEGIN 
    SELECT menu.Nama_Menu, menu.harga, jumlah_menu_pesanan.Jumlah 
    FROM Pesanan p 
    INNER JOIN jumlah_menu_pesanan ON p.ID_Pesanan = jumlah_menu_pesanan.ID_Pesanan 
    INNER JOIN menu ON jumlah_menu_pesanan.ID_Menu = menu.ID_Menu 
    WHERE p.ID_Pesanan = id_pesanan; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mencariPesananByNamaPelanggan` (IN `nama` VARCHAR(255))   BEGIN
	SELECT ID_Pesanan FROM pesanan WHERE ID_Pelanggan = (SELECT ID_Pelanggan FROM pelanggan WHERE Nama_Pelanggan = nama);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `menuPesananYangBelumSelesai` ()   BEGIN
	SELECT jmp.ID_Pesanan, m.Nama_Menu, jmp.Jumlah
    FROM jumlah_menu_pesanan jmp
    INNER JOIN menu m ON jmp.ID_Menu = m.ID_Menu
    LEFT JOIN riwayat_pesanan rp on jmp.ID_Pesanan = rp.ID_Pesanan
    WHERE rp.ID_Pesanan IS NULL ORDER BY jmp.ID_Pesanan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PesananYangBelumSelesai` ()   BEGIN
	SELECT pes.ID_Pesanan, pes.ID_Pelanggan, pes.ID_Meja, pes.Makan_ditempat, pes.Waktu_Pemesanan
    FROM pesanan pes
    LEFT JOIN riwayat_pesanan rp on pes.ID_Pesanan = rp.ID_Pesanan
    WHERE rp.ID_Pesanan IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservasiYangBelumSelesai` ()   BEGIN
	SELECT r.ID_Reservasi, r.ID_Pelanggan, r.ID_Meja, r.Waktu_Reservasi, r.Tanggal_Reservasi
    FROM reservasi r
    LEFT JOIN riwayat_reservasi rr on r.ID_Reservasi = rr.ID_Riwayat
    WHERE rr.ID_Riwayat IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShiftKaryawanByHari` (IN `hari` VARCHAR(255))   BEGIN
	SELECT k.Nama_Karyawan, s.Hari, s.Jam_Mulai, s.Jam_Selesai
    FROM karyawan k
    JOIN karyawan_menjalani_shift kms ON k.ID_Karyawan = kms.ID_Karyawan
    JOIN shift s ON kms.ID_Shift = s.ID_Shift
    WHERE s.Hari = hari;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `totalHarga` (IN `id_pesanan` INT, OUT `total_harga` DECIMAL(10,2))   BEGIN
    SELECT SUM(m.harga * jmp.jumlah) 
    INTO total_harga
    FROM jumlah_menu_pesanan jmp
    INNER JOIN menu m ON jmp.id_menu = m.id_menu
    WHERE jmp.id_pesanan = id_pesanan;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jumlah_menu_pesanan`
--

CREATE TABLE `jumlah_menu_pesanan` (
  `ID_Pesanan` int(11) NOT NULL,
  `ID_Menu` int(11) NOT NULL,
  `Jumlah` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jumlah_menu_pesanan`
--

INSERT INTO `jumlah_menu_pesanan` (`ID_Pesanan`, `ID_Menu`, `Jumlah`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 10, 2),
(2, 1, 1),
(2, 3, 1),
(2, 7, 2),
(3, 1, 1),
(3, 2, 2),
(3, 4, 1),
(4, 3, 2),
(4, 5, 1),
(5, 2, 1),
(5, 4, 2),
(6, 1, 1),
(6, 5, 3),
(7, 3, 1),
(7, 2, 1),
(8, 1, 2),
(8, 4, 1),
(9, 5, 1),
(9, 3, 2),
(10, 1, 5),
(10, 2, 2),
(11, 4, 1),
(11, 5, 2),
(12, 1, 1),
(12, 3, 3),
(13, 2, 2),
(13, 4, 1),
(14, 1, 2),
(14, 5, 1),
(15, 3, 1),
(15, 2, 2),
(16, 1, 3),
(1, 1, 3),
(1, 2, 2),
(1, 3, 1),
(2, 4, 4),
(2, 5, 3),
(2, 6, 2),
(3, 7, 1),
(3, 8, 5),
(3, 9, 2),
(4, 10, 3),
(4, 1, 4),
(4, 2, 2),
(5, 3, 1),
(5, 4, 2),
(5, 5, 3),
(6, 6, 1),
(6, 7, 4),
(6, 8, 2),
(7, 9, 3),
(7, 10, 2),
(7, 1, 5),
(8, 2, 1),
(8, 3, 4),
(8, 4, 2),
(9, 5, 3),
(9, 6, 1),
(9, 7, 4),
(10, 8, 2),
(10, 9, 3),
(10, 10, 1),
(11, 1, 4),
(11, 2, 2),
(11, 3, 1),
(12, 4, 5),
(12, 5, 3),
(12, 6, 2),
(13, 7, 1),
(13, 8, 4),
(13, 9, 2),
(14, 10, 3),
(14, 1, 2),
(14, 2, 5),
(15, 3, 1),
(15, 4, 4),
(15, 5, 2),
(16, 6, 3),
(16, 7, 1),
(16, 8, 4),
(11, 2, 1),
(21, 1, 4),
(22, 3, 1),
(23, 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `ID_Karyawan` int(11) NOT NULL,
  `Nama_Karyawan` varchar(255) NOT NULL,
  `Posisi` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`ID_Karyawan`, `Nama_Karyawan`, `Posisi`) VALUES
(1, 'Narnia', 'Pramusaji'),
(2, 'Dora', 'Pramusaji'),
(3, 'Fauiz', 'Pramusaji'),
(4, 'Jihyo', 'Pramusaji'),
(5, 'Sasuke', 'Pramusaji'),
(6, 'Dennis', 'Pramusaji'),
(7, 'Johnny', 'Kasir'),
(8, 'Anto', 'Kasir'),
(9, 'Tanya', 'Kasir'),
(10, 'Kurniawan', 'Kasir'),
(11, 'Santika', 'Kasir'),
(12, 'Ariana', 'Kasir'),
(13, 'Junaedi', 'Koki'),
(14, 'Adi', 'Koki'),
(15, 'Fani', 'Koki'),
(16, 'Bobby', 'Koki'),
(17, 'Renatta', 'Koki'),
(18, 'Reynold', 'Koki'),
(19, 'Ehsan', 'Koki'),
(20, 'Gordon Ramsay', 'koki'),
(21, 'Mr.Crab', 'Manager'),
(22, 'TestKaryawan', 'Tester');

-- --------------------------------------------------------

--
-- Table structure for table `karyawan_menjalani_shift`
--

CREATE TABLE `karyawan_menjalani_shift` (
  `ID_Karyawan` int(11) NOT NULL,
  `ID_Shift` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan_menjalani_shift`
--

INSERT INTO `karyawan_menjalani_shift` (`ID_Karyawan`, `ID_Shift`) VALUES
(1, 1),
(2, 1),
(3, 1),
(7, 1),
(8, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(21, 1),
(4, 2),
(5, 2),
(6, 2),
(9, 2),
(10, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(1, 3),
(2, 3),
(3, 3),
(7, 3),
(8, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 3),
(21, 3),
(4, 4),
(5, 4),
(6, 4),
(9, 4),
(10, 4),
(17, 4),
(18, 4),
(19, 4),
(20, 4),
(21, 4),
(1, 5),
(2, 5),
(3, 5),
(7, 5),
(8, 5),
(13, 5),
(14, 5),
(15, 5),
(16, 5),
(21, 5),
(4, 6),
(5, 6),
(6, 6),
(9, 6),
(10, 6),
(17, 6),
(18, 6),
(19, 6),
(20, 6),
(21, 6),
(1, 7),
(2, 7),
(3, 7),
(7, 7),
(8, 7),
(13, 7),
(14, 7),
(15, 7),
(16, 7),
(21, 7),
(4, 8),
(5, 8),
(6, 8),
(9, 8),
(10, 8),
(17, 8),
(18, 8),
(19, 8),
(20, 8),
(21, 8),
(1, 9),
(2, 9),
(3, 9),
(7, 9),
(8, 9),
(13, 9),
(14, 9),
(15, 9),
(16, 9),
(21, 9),
(4, 10),
(5, 10),
(6, 10),
(9, 10),
(10, 10),
(17, 10),
(18, 10),
(19, 10),
(20, 10),
(21, 10),
(1, 11),
(2, 11),
(3, 11),
(7, 11),
(8, 11),
(13, 11),
(14, 11),
(15, 11),
(16, 11),
(21, 11),
(4, 12),
(5, 12),
(6, 12),
(9, 12),
(10, 12),
(17, 12),
(18, 12),
(19, 12),
(20, 12),
(21, 12),
(1, 13),
(2, 13),
(3, 13),
(7, 13),
(8, 13),
(13, 13),
(14, 13),
(15, 13),
(16, 13),
(21, 13);

-- --------------------------------------------------------

--
-- Table structure for table `meja`
--

CREATE TABLE `meja` (
  `ID_Meja` int(11) NOT NULL,
  `No_Meja` int(11) NOT NULL,
  `Kapasitas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meja`
--

INSERT INTO `meja` (`ID_Meja`, `No_Meja`, `Kapasitas`) VALUES
(1, 1, 2),
(2, 2, 2),
(3, 3, 2),
(4, 4, 2),
(5, 5, 4),
(6, 6, 4),
(7, 7, 4),
(8, 8, 4),
(9, 9, 6),
(10, 10, 6),
(11, 11, 6),
(12, 12, 6),
(13, 13, 8),
(14, 14, 8),
(15, 15, 10),
(16, 16, 10),
(17, 1010, 100);

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `ID_Menu` int(11) NOT NULL,
  `Nama_Menu` varchar(255) NOT NULL,
  `harga` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`ID_Menu`, `Nama_Menu`, `harga`) VALUES
(1, 'Rendang Unta', 40000.00),
(2, 'Nasi Basmati', 25000.00),
(3, 'Nasi Kebuli', 50000.00),
(4, 'Nasi Kuning Komplit', 25000.00),
(5, 'Kebab Unta', 100000.00),
(6, 'Shawarma Domba', 75000.00),
(7, 'Teh Rempah', 20000.00),
(8, 'Kopi Luwak', 20000.00),
(9, 'Jallab', 18000.00),
(10, 'Teh Susu', 18000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `ID_Pelanggan` int(11) NOT NULL,
  `Nama_Pelanggan` varchar(255) NOT NULL,
  `Nomor_Telepon` varchar(20) DEFAULT NULL,
  `ID_Karyawan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`ID_Pelanggan`, `Nama_Pelanggan`, `Nomor_Telepon`, `ID_Karyawan`) VALUES
(1, 'Selena Lipa', '1234567890', 1),
(2, 'Taylor Swift', '1234567891', 1),
(3, 'Elon Musk', '1234567892', 2),
(4, 'Chris Evan', '1234567893', 2),
(5, 'Dakota John', '1234567894', 8),
(6, 'Timothy Donald', '1234567895', 7),
(7, 'Mika Tunis', '1234567896', 3),
(8, 'John Trump', '1234567897', 4),
(9, 'Vivtoria', '1234567898', 4),
(10, 'Muhajirin Anshor', '1234567899', 10),
(11, 'Farahmeytha', '12322517896', 3),
(12, 'Donald Ronald', '12341237897', 3),
(13, 'Anissa Alimatus', '1123167898', 3),
(14, 'Jonny Tutik', '1434327899', 5),
(15, 'Abdul', '123444930191', 9),
(16, 'Test1', '12345', 7),
(17, 'Test2', '12345', 7),
(18, 'Test1', '1451515', 1),
(19, 'Testaga', '102022300301', 1),
(20, 'Test1', '145151', 1),
(21, 'alta', '1', 1),
(22, 'alta', '12', 1),
(23, 'alta', '123', 1),
(24, 'ALta1', '15415', 7),
(25, 'TestAkhir', '1234', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `ID_Pembayaran` int(11) NOT NULL,
  `Waktu_Pembayaran` datetime NOT NULL DEFAULT current_timestamp(),
  `Total_Harga` decimal(11,2) NOT NULL,
  `Metode_Pembayaran` varchar(255) NOT NULL,
  `ID_Pesanan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`ID_Pembayaran`, `Waktu_Pembayaran`, `Total_Harga`, `Metode_Pembayaran`, `ID_Pesanan`) VALUES
(1, '2024-05-17 10:00:00', 101000.00, 'Cash', 1),
(2, '2024-05-17 10:00:00', 130000.00, 'Credit Card', 2),
(3, '2024-05-17 13:00:00', 115000.00, 'Debit Card', 3),
(4, '2024-05-21 11:45:00', 200000.00, 'Cash', 4),
(5, '2024-05-21 12:51:00', 75000.00, 'Credit Card', 5),
(6, '2024-05-21 14:31:00', 340000.00, 'Debit Card', 6),
(7, '2024-05-30 17:01:00', 75000.00, 'Cash', 7),
(8, '2024-05-30 15:30:00', 105000.00, 'Credit Card', 8),
(9, '2024-06-01 18:05:00', 305000.00, 'Debit Card', 9),
(10, '2024-06-01 19:59:00', 400000.00, 'Cash', 10);

--
-- Triggers `pembayaran`
--
DELIMITER $$
CREATE TRIGGER `setelah_pembayaran` AFTER INSERT ON `pembayaran` FOR EACH ROW BEGIN 
	INSERT INTO riwayat_pesanan (Id_riwayat, Id_pesanan) 
    VALUES (NULL, NEW.Id_pesanan); 
    IF EXISTS ( SELECT 1 FROM reservasi WHERE Id_pelanggan = (SELECT Id_pelanggan FROM pesanan WHERE Id_pesanan = NEW.Id_pesanan) ) THEN INSERT INTO riwayat_reservasi (Id_riwayat, Id_reservasi) SELECT NULL, Id_reservasi FROM reservasi WHERE Id_pelanggan = (SELECT Id_pelanggan FROM pesanan WHERE Id_pesanan = NEW.Id_pesanan) LIMIT 1; 
    END IF; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `ID_Pesanan` int(11) NOT NULL,
  `Waktu_Pemesanan` datetime NOT NULL DEFAULT current_timestamp(),
  `ID_Pelanggan` int(11) NOT NULL,
  `ID_Meja` int(11) DEFAULT NULL,
  `Makan_ditempat` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`ID_Pesanan`, `Waktu_Pemesanan`, `ID_Pelanggan`, `ID_Meja`, `Makan_ditempat`) VALUES
(1, '2024-05-17 08:00:00', 13, 1, 1),
(2, '2024-05-17 09:00:00', 6, 2, 1),
(3, '2024-05-17 10:00:00', 4, NULL, 0),
(4, '2024-05-21 11:00:00', 2, 4, 1),
(5, '2024-05-21 12:00:00', 5, NULL, 0),
(6, '2024-05-21 13:00:00', 6, 6, 1),
(7, '2024-05-30 14:00:00', 1, NULL, 0),
(8, '2024-05-30 15:00:00', 8, 8, 1),
(9, '2024-06-01 16:00:00', 2, NULL, 0),
(10, '2024-06-01 17:00:00', 1, 10, 1),
(11, '2024-06-01 18:00:00', 11, NULL, 0),
(12, '2024-06-01 19:00:00', 6, 12, 1),
(13, '2024-06-01 20:00:00', 13, NULL, 0),
(14, '2024-06-01 21:00:00', 8, 14, 1),
(15, '2024-06-02 08:00:00', 1, 15, 1),
(16, '2024-06-02 09:00:00', 2, NULL, 0),
(21, '2024-06-06 16:06:55', 16, 1, 1),
(22, '2024-06-09 21:43:36', 24, 1, 1),
(23, '2024-06-10 14:54:06', 25, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `reservasi`
--

CREATE TABLE `reservasi` (
  `ID_Reservasi` int(11) NOT NULL,
  `ID_Pelanggan` int(11) NOT NULL,
  `Tanggal_Reservasi` date NOT NULL DEFAULT curdate(),
  `Waktu_Reservasi` datetime NOT NULL,
  `ID_Meja` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservasi`
--

INSERT INTO `reservasi` (`ID_Reservasi`, `ID_Pelanggan`, `Tanggal_Reservasi`, `Waktu_Reservasi`, `ID_Meja`) VALUES
(1, 1, '2024-06-01', '2024-06-03 08:00:00', 3),
(2, 4, '2024-06-01', '2024-06-03 09:00:00', 2),
(3, 3, '2024-06-01', '2024-06-04 10:00:00', 3),
(4, 4, '2024-06-01', '2024-06-05 11:00:00', 8),
(5, 5, '2024-06-01', '2024-06-07 12:00:00', 5),
(6, 9, '2024-06-01', '2024-06-03 13:00:00', 6),
(7, 1, '2024-06-01', '2024-06-04 14:00:00', 3),
(8, 8, '2024-06-01', '2024-06-04 15:00:00', 8),
(9, 9, '2024-06-01', '2024-06-03 16:00:00', 10),
(10, 10, '2024-06-01', '2024-06-05 17:00:00', 10),
(11, 9, '2024-06-01', '2024-06-13 18:00:00', 11),
(12, 8, '2024-06-01', '2024-06-30 19:00:00', 2),
(13, 13, '2024-06-01', '2024-06-04 20:00:00', 13),
(14, 14, '2024-06-01', '2024-06-16 21:00:00', 9),
(15, 1, '2024-06-02', '2024-06-13 08:00:00', 3),
(16, 2, '2024-06-02', '2024-06-24 09:00:00', 16),
(17, 7, '2024-06-02', '2024-06-15 19:00:00', 5),
(18, 2, '2024-06-05', '2024-06-08 03:30:00', 6),
(19, 1, '2024-06-09', '2024-06-09 19:40:00', 1),
(20, 1, '2024-06-09', '2024-06-09 21:43:00', 1),
(21, 25, '2024-06-10', '2024-06-12 06:00:00', 1);

--
-- Triggers `reservasi`
--
DELIMITER $$
CREATE TRIGGER `cek_reservasi_unik` BEFORE INSERT ON `reservasi` FOR EACH ROW BEGIN
    DECLARE count_reservasi INT;
    SELECT COUNT(*) INTO count_reservasi
    FROM reservasi
    WHERE ID_Meja = NEW.ID_Meja
    AND Waktu_Reservasi = NEW.Waktu_Reservasi;
    IF count_reservasi > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservasi untuk pelanggan pada tanggal ini sudah ada.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_pesanan`
--

CREATE TABLE `riwayat_pesanan` (
  `ID_Riwayat` int(11) NOT NULL,
  `ID_Pesanan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `riwayat_pesanan`
--

INSERT INTO `riwayat_pesanan` (`ID_Riwayat`, `ID_Pesanan`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_reservasi`
--

CREATE TABLE `riwayat_reservasi` (
  `ID_Riwayat` int(11) NOT NULL,
  `ID_Reservasi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `riwayat_reservasi`
--

INSERT INTO `riwayat_reservasi` (`ID_Riwayat`, `ID_Reservasi`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `shift`
--

CREATE TABLE `shift` (
  `ID_Shift` int(11) NOT NULL,
  `Hari` varchar(255) NOT NULL,
  `Jam_Mulai` varchar(255) NOT NULL,
  `Jam_Selesai` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shift`
--

INSERT INTO `shift` (`ID_Shift`, `Hari`, `Jam_Mulai`, `Jam_Selesai`) VALUES
(1, 'Senin', '08:00:00', '16:00:00'),
(2, 'Senin', '16:00:00', '22:00:00'),
(3, 'Selasa', '08:00:00', '16:00:00'),
(4, 'Selasa', '16:00:00', '22:00:00'),
(5, 'Rabu', '08:00:00', '16:00:00'),
(6, 'Rabu', '16:00:00', '22:00:00'),
(7, 'Kamis', '08:00:00', '16:00:00'),
(8, 'Kamis', '16:00:00', '22:00:00'),
(9, 'Jumat', '08:00:00', '16:00:00'),
(10, 'Jumat', '16:00:00', '22:00:00'),
(11, 'Sabtu', '09:00:00', '17:00:00'),
(12, 'Sabtu', '16:00:00', '22:00:00'),
(13, 'Minggu', '09:00:00', '17:00:00'),
(14, 'Minggu', '16:00:00', '22:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jumlah_menu_pesanan`
--
ALTER TABLE `jumlah_menu_pesanan`
  ADD KEY `fk_pesanan_jumlahmenupesanan` (`ID_Pesanan`),
  ADD KEY `fk_menu_jumlahmenupesanan` (`ID_Menu`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`ID_Karyawan`);

--
-- Indexes for table `karyawan_menjalani_shift`
--
ALTER TABLE `karyawan_menjalani_shift`
  ADD KEY `fk_karyawan_karyawanmenjalanishift` (`ID_Karyawan`),
  ADD KEY `fk_shift_fk_karyawan_karyawanmenjalanishift` (`ID_Shift`);

--
-- Indexes for table `meja`
--
ALTER TABLE `meja`
  ADD PRIMARY KEY (`ID_Meja`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`ID_Menu`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`ID_Pelanggan`),
  ADD KEY `fk_karyawan_pelanggan` (`ID_Karyawan`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`ID_Pembayaran`),
  ADD KEY `fk_pesanan_pembayaran` (`ID_Pesanan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`ID_Pesanan`),
  ADD KEY `fk_pelanggan_pesanan` (`ID_Pelanggan`),
  ADD KEY `fk_meja_pesanan` (`ID_Meja`);

--
-- Indexes for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`ID_Reservasi`),
  ADD KEY `fk_pelanggan_reservasi` (`ID_Pelanggan`),
  ADD KEY `fk_meja_reservasi` (`ID_Meja`);

--
-- Indexes for table `riwayat_pesanan`
--
ALTER TABLE `riwayat_pesanan`
  ADD PRIMARY KEY (`ID_Riwayat`),
  ADD KEY `fk_pesanan_riwayatPesanan` (`ID_Pesanan`);

--
-- Indexes for table `riwayat_reservasi`
--
ALTER TABLE `riwayat_reservasi`
  ADD PRIMARY KEY (`ID_Riwayat`),
  ADD KEY `fk_reservasi_riwayatReservasi` (`ID_Reservasi`);

--
-- Indexes for table `shift`
--
ALTER TABLE `shift`
  ADD PRIMARY KEY (`ID_Shift`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `ID_Karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `meja`
--
ALTER TABLE `meja`
  MODIFY `ID_Meja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `ID_Menu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `ID_Pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `ID_Pembayaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `ID_Pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `reservasi`
--
ALTER TABLE `reservasi`
  MODIFY `ID_Reservasi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `riwayat_pesanan`
--
ALTER TABLE `riwayat_pesanan`
  MODIFY `ID_Riwayat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `riwayat_reservasi`
--
ALTER TABLE `riwayat_reservasi`
  MODIFY `ID_Riwayat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `shift`
--
ALTER TABLE `shift`
  MODIFY `ID_Shift` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jumlah_menu_pesanan`
--
ALTER TABLE `jumlah_menu_pesanan`
  ADD CONSTRAINT `fk_menu_jumlahmenupesanan` FOREIGN KEY (`ID_Menu`) REFERENCES `menu` (`ID_Menu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_jumlahmenupesanan` FOREIGN KEY (`ID_Pesanan`) REFERENCES `pesanan` (`ID_Pesanan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `karyawan_menjalani_shift`
--
ALTER TABLE `karyawan_menjalani_shift`
  ADD CONSTRAINT `fk_karyawan_karyawanmenjalanishift` FOREIGN KEY (`ID_Karyawan`) REFERENCES `karyawan` (`ID_Karyawan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_shift_fk_karyawan_karyawanmenjalanishift` FOREIGN KEY (`ID_Shift`) REFERENCES `shift` (`ID_Shift`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD CONSTRAINT `fk_karyawan_pelanggan` FOREIGN KEY (`ID_Karyawan`) REFERENCES `karyawan` (`ID_Karyawan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `fk_pesanan_pembayaran` FOREIGN KEY (`ID_Pesanan`) REFERENCES `pesanan` (`ID_Pesanan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_meja_pesanan` FOREIGN KEY (`ID_Meja`) REFERENCES `meja` (`ID_Meja`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pelanggan_pesanan` FOREIGN KEY (`ID_Pelanggan`) REFERENCES `pelanggan` (`ID_Pelanggan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `fk_meja_reservasi` FOREIGN KEY (`ID_Meja`) REFERENCES `meja` (`ID_Meja`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pelanggan_reservasi` FOREIGN KEY (`ID_Pelanggan`) REFERENCES `pelanggan` (`ID_Pelanggan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `riwayat_pesanan`
--
ALTER TABLE `riwayat_pesanan`
  ADD CONSTRAINT `fk_pesanan_riwayatPesanan` FOREIGN KEY (`ID_Pesanan`) REFERENCES `pesanan` (`ID_Pesanan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `riwayat_reservasi`
--
ALTER TABLE `riwayat_reservasi`
  ADD CONSTRAINT `fk_reservasi_riwayatReservasi` FOREIGN KEY (`ID_Reservasi`) REFERENCES `reservasi` (`ID_Reservasi`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
