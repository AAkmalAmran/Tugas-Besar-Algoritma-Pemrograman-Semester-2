# Kelas: SI-47-08
# Kelompok: 33
# Anggota Kelompok:
# 1. Ahmad Akmal Amran (102022300010)
# 2. Firdaus Al hamid (102022300403)
# 3. Josua Immanuel Natanael Pasaribu (102022300271)
# 4. Tb. Alta Ulil Abshor (102022300301)

import mysql.connector
import streamlit as st
import matplotlib.pyplot as plt
from datetime import datetime
import time


# START: Fungsi untuk menghubungkan ke database "restaurant_copy"
def initialize_0833():
    connection_0833 = mysql.connector.connect(
        host="localhost", user="root", password="", database="restaurant_copy"
    )
    return connection_0833


# END: Fungsi untuk menghubungkan ke database "restaurant_copy"


# START: Fungsi Read
# Fungsi Searching 1
def get_karyawan_0833(nama_0833=None):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    query_0833 = "SELECT * FROM karyawan"
    if nama_0833:
        query_0833 += f" WHERE Nama_Karyawan LIKE '{nama_0833}%'"
        cursor_0833.execute(query_0833)
    else:
        cursor_0833.execute(query_0833)
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_riwayatPesanan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """
        SELECT rp.ID_Riwayat, rp.ID_Pesanan, pes.ID_Pelanggan, pel.Nama_Pelanggan, pes.ID_Meja, pes.Makan_ditempat, pes.Waktu_Pemesanan
        FROM riwayat_pesanan rp
        JOIN pesanan pes ON rp.ID_Pesanan = pes.ID_Pesanan
        JOIN pelanggan pel ON pes.ID_Pelanggan = pel.ID_Pelanggan;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_riwayatReservasi_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """
        SELECT rr.ID_Riwayat, rs.ID_Reservasi, rs.ID_Pelanggan, pel.Nama_Pelanggan, rs.Tanggal_Reservasi, rs.Waktu_Reservasi, mj.No_Meja, mj.Kapasitas
        FROM riwayat_reservasi rr
        JOIN reservasi rs ON rr.ID_Reservasi = rs.ID_Reservasi
        JOIN meja mj ON rs.ID_Meja = mj.ID_Meja
        JOIN pelanggan pel ON rs.ID_Pelanggan = pel.ID_Pelanggan;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_detailPesanan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """
        SELECT pes.ID_Pesanan, mn.Nama_Menu, jml.Jumlah
        FROM pesanan pes
        JOIN jumlah_menu_pesanan jml ON pes.ID_Pesanan = jml.ID_Pesanan
        JOIN menu mn ON jml.ID_Menu = mn.ID_Menu
        LEFT JOIN riwayat_pesanan rp on pes.ID_Pesanan = rp.ID_Pesanan
        WHERE rp.ID_Pesanan IS NULL;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_reservasi_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """
        SELECT rs.ID_Reservasi, rs.ID_Pelanggan, pel.Nama_Pelanggan, rs.Tanggal_Reservasi, rs.Waktu_Reservasi, rs.ID_Meja, mj.No_Meja, mj.Kapasitas FROM reservasi rs JOIN meja mj ON rs.ID_Meja = mj.ID_Meja JOIN pelanggan pel ON rs.ID_Pelanggan = pel.ID_Pelanggan LEFT JOIN riwayat_reservasi rr on rs.ID_Reservasi = rr.ID_Riwayat WHERE rr.ID_Riwayat IS NULL;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_pembayaran_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """SELECT pem.ID_Pembayaran, pem.ID_Pesanan, pel.ID_Pelanggan, pel.Nama_Pelanggan, pem.Metode_Pembayaran, pem.Waktu_Pembayaran, pem.Total_Harga
                FROM pembayaran pem
                JOIN pesanan pes ON pem.ID_Pesanan = pes.ID_Pesanan
                JOIN pelanggan pel ON pes.ID_Pelanggan = pel.ID_Pelanggan;"""
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_shift_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute("SELECT * FROM shift")
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


# Proses Filtering 1
def get_shiftKaryawan_0833(hari_0833=None):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    query_0833 = """SELECT k.Nama_Karyawan, s.Hari, s.Jam_Mulai, s.Jam_Selesai
        FROM karyawan k
        JOIN karyawan_menjalani_shift kms ON k.ID_Karyawan = kms.ID_Karyawan
        JOIN shift s ON kms.ID_Shift = s.ID_Shift"""
    if hari_0833:
        query_0833 += " WHERE s.Hari = %s"
        cursor_0833.execute(query_0833, (hari_0833,))
    else:
        cursor_0833.execute(query_0833)
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_menu_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute("SELECT * FROM menu")
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_meja_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute("SELECT * FROM meja")
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_pelanggan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """SELECT pel.ID_Pelanggan, pel.Nama_Pelanggan, pel.Nomor_Telepon, kar.Nama_Karyawan
        FROM pelanggan pel
        INNER JOIN karyawan kar ON pel.ID_Karyawan = kar.ID_Karyawan;"""
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


def get_pesanan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor(dictionary=True)
    cursor_0833.execute(
        """
        SELECT pes.ID_Pesanan, pes.ID_Pelanggan, pel.Nama_Pelanggan, pes.ID_Meja, pes.Makan_ditempat, pes.Waktu_Pemesanan FROM pesanan pes
        JOIN pelanggan pel ON pes.ID_Pelanggan = pel.ID_Pelanggan
        LEFT JOIN riwayat_pesanan rp on pes.ID_Pesanan = rp.ID_Pesanan
        WHERE rp.ID_Pesanan IS NULL;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    return table_0833


# END: Fungsi Read


# START: Fungsi Insert Data
def add_pelanggan_0833(Nama_Pelanggan_0833, Nomor_Telepon_0833, ID_Karyawan_0833):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        "INSERT INTO pelanggan(Nama_Pelanggan, Nomor_Telepon, ID_Karyawan) VALUES (%s, %s, %s)",
        (Nama_Pelanggan_0833, Nomor_Telepon_0833, ID_Karyawan_0833),
    )
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


def add_pesanan_0833(
    Waktu_Pemesanan_0833, ID_Pelanggan_0833, ID_Meja_0833, Makan_ditempat_0833
):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        "INSERT INTO Pesanan (Waktu_Pemesanan, ID_Pelanggan, ID_Meja, Makan_ditempat) VALUES (%s, %s, %s, %s)",
        (Waktu_Pemesanan_0833, ID_Pelanggan_0833, ID_Meja_0833, Makan_ditempat_0833),
    )
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


# Fungsi Update
def add_jumlah_menu_pesanan_0833(ID_Pesanan_0833, menu_0833, jumlah_0833):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        f"SELECT EXISTS(SELECT 1 FROM jumlah_menu_pesanan WHERE ID_Pesanan = {ID_Pesanan_0833} AND ID_Menu = {menu_0833});"
    )
    cek_0833 = cursor_0833.fetchone()
    if cek_0833[0] == 1:
        cursor_0833.execute(
            f"UPDATE jumlah_menu_pesanan SET Jumlah = Jumlah + {jumlah_0833} WHERE ID_Pesanan = {ID_Pesanan_0833} AND ID_Menu = {menu_0833};"
        )
    else:
        cursor_0833.execute(
            "INSERT INTO jumlah_menu_pesanan (ID_Pesanan, ID_Menu, Jumlah) VALUES (%s, %s, %s)",
            (ID_Pesanan_0833, menu_0833, jumlah_0833),
        )
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


def add_reservasi_0833(ID_Pelanggan_0833, Waktu_Reservasi_0833, ID_Meja_0833):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        "INSERT INTO reservasi(ID_Pelanggan, Waktu_Reservasi, ID_Meja) VALUES (%s, %s, %s)",
        (ID_Pelanggan_0833, Waktu_Reservasi_0833, ID_Meja_0833),
    )
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


def add_menu_0833(Nama_Menu_0833, harga_0833):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        "INSERT INTO menu(Nama_Menu, harga) VALUES (%s, %s)",
        (Nama_Menu_0833, harga_0833),
    )
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


# END: Fungsi Insert Data


# START: Delete
def delete_menu_0833(ID_Menu_0833):
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute("DELETE FROM menu WHERE ID_Menu = %s", (ID_Menu_0833,))
    connection_0833.commit()
    cursor_0833.close()
    connection_0833.close()


# END: Delete


# START: Visualisasi Data
def graphPosisiKaryawan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        "SELECT Posisi, COUNT(Posisi) AS jumlah FROM karyawan GROUP BY Posisi;"
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    posisi_0833 = [baris[0] for baris in table_0833]
    jumlah_0833 = [baris[1] for baris in table_0833]
    plt.figure(figsize=(11, 6))
    plt.bar(posisi_0833, jumlah_0833, color="skyblue")
    plt.xlabel("Posisi")
    plt.ylabel("Jumlah")
    plt.title("Jumlah Setiap Posisi di Restaurant")
    plt.tight_layout()
    st.pyplot(plt)


def graphMenuPesanan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        """
        SELECT m.Nama_Menu, SUM(jml.Jumlah) AS total
        FROM jumlah_menu_pesanan jml
        JOIN menu m ON jml.ID_Menu = m.ID_Menu
        GROUP BY m.Nama_Menu;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    menu_0833 = [baris[0] for baris in table_0833]
    jumlah_0833 = [baris[1] for baris in table_0833]
    plt.figure(figsize=(11, 6))
    plt.bar(menu_0833, jumlah_0833, color="skyblue")
    plt.xlabel("Nama Menu")
    plt.ylabel("Jumlah")
    plt.title("Bar Chart Menu Pesanan")
    plt.tight_layout()
    plt.xticks(rotation=45, ha="right")
    st.pyplot(plt)


def graphKapasitasMejaYangTerpakaiByPesanan_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        """
        SELECT mj.Kapasitas, COUNT(p.ID_Meja) AS total
        FROM meja mj
        JOIN pesanan p ON mj.ID_Meja = p.ID_Meja
        GROUP BY mj.Kapasitas;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    meja_0833 = [baris[0] for baris in table_0833]
    jumlah_0833 = [baris[1] for baris in table_0833]
    plt.figure(figsize=(6, 3))
    plt.bar(meja_0833, jumlah_0833, color="skyblue")
    plt.xlabel("ID Meja")
    plt.ylabel("Jumlah")
    plt.title("Bar Chart Kapasitas Meja Terpakai (Non-Reservasi)")
    plt.tight_layout()
    plt.xticks(rotation=45, ha="right")
    st.pyplot(plt)


def graphKapasitasMejaYangTerpakaiByReservasi_0833():
    connection_0833 = initialize_0833()
    cursor_0833 = connection_0833.cursor()
    cursor_0833.execute(
        """
        SELECT mj.Kapasitas, COUNT(r.ID_Meja) AS total
        FROM meja mj
        JOIN reservasi r ON mj.ID_Meja = r.ID_Meja
        GROUP BY mj.Kapasitas;
        """
    )
    table_0833 = cursor_0833.fetchall()
    cursor_0833.close()
    connection_0833.close()
    meja_0833 = [baris[0] for baris in table_0833]
    jumlah_0833 = [baris[1] for baris in table_0833]
    plt.figure(figsize=(6, 3))
    plt.bar(meja_0833, jumlah_0833, color="skyblue")
    plt.xlabel("ID Meja")
    plt.ylabel("Jumlah")
    plt.title("Bar Chart Kapasitas Meja Terpakai")
    plt.tight_layout()
    plt.xticks(rotation=45, ha="right")
    st.pyplot(plt)


# END: Visualisasi Data


# START: Fungsi Streamlit/Utama
# START: Fungsi User Kasir
def inputpelanggan_0833():
    with st.container():
        karyawan_0833 = get_karyawan_0833()
        st.header("Tambah Pelanggan")
        nama_0833 = st.text_input("Nama Pelanggan")
        nomor_telepon_0833 = st.text_input("Nomor Telepon")

        karyawan_options_0833 = {
            karyawan["ID_Karyawan"]: karyawan["Nama_Karyawan"]
            for karyawan in karyawan_0833
        }
        selected_karyawan_id_0833 = st.selectbox(
            "Select Karyawan",
            list(karyawan_options_0833.keys()),
            format_func=lambda x: karyawan_options_0833[x],
        )

        if st.button("Add Pelanggan"):
            if nama_0833 and nomor_telepon_0833 and selected_karyawan_id_0833:
                add_pelanggan_0833(
                    nama_0833, nomor_telepon_0833, selected_karyawan_id_0833
                )
                st.success(f'Pelanggan "{nama_0833}" berhasil ditambahkan!')
                time.sleep(2)
                st.rerun()
            else:
                st.error("Mohon isi semua data yang diperlukan.")


def inputpesanan_0833():
    with st.container():
        meja_0833 = get_meja_0833()
        pelanggan_0833 = get_pelanggan_0833()
        menu_0833 = get_menu_0833()
        pesanan_0833 = get_pesanan_0833()
        st.header("Pesanan")
        Waktu_Pemesanan_0833 = datetime.now()

        pelanggan_options_0833 = {
            pelanggan["ID_Pelanggan"]: pelanggan["Nama_Pelanggan"]
            for pelanggan in pelanggan_0833
        }
        selected_pelanggan_id_0833 = st.selectbox(
            "Select pelanggan",
            list(pelanggan_options_0833.keys()),
            format_func=lambda x: pelanggan_options_0833[x],
        )

        Makan_ditempat_0833 = st.checkbox("Makan ditempat", value=True)

        if Makan_ditempat_0833:
            meja_options_0833 = {
                meja["ID_Meja"]: meja["Kapasitas"] for meja in meja_0833
            }
            selected_meja_id_0833 = st.selectbox(
                "Pilih Kapasitas Meja",
                list(meja_options_0833.keys()),
                format_func=lambda x: meja_options_0833[x],
            )

        if st.button("Add Pesanan"):
            if (
                Waktu_Pemesanan_0833
                and selected_pelanggan_id_0833
                and (
                    not Makan_ditempat_0833
                    or (Makan_ditempat_0833 and selected_meja_id_0833)
                )
                and pesanan_0833
            ):
                add_pesanan_0833(
                    Waktu_Pemesanan_0833,
                    selected_pelanggan_id_0833,
                    selected_meja_id_0833 if Makan_ditempat_0833 else None,
                    Makan_ditempat_0833,
                )
                st.success("Pesanan berhasil ditambahkan!")
                time.sleep(2)
                st.rerun()
            else:
                st.error("Mohon isi semua data yang diperlukan.")

        opsiPesanan_0833 = {pesanan["ID_Pesanan"] for pesanan in pesanan_0833}
        pesananTerpilih_0833 = st.selectbox("ID Pesanan", list(opsiPesanan_0833))

        menu_id_0833 = st.number_input("Masukan ID Menu", step=1)
        kuantitas_0833 = st.number_input("Masukan kuantitas menu", min_value=1, step=1)

        if st.button("Kirim Pesanan"):
            if menu_id_0833 in list(menu["ID_Menu"] for menu in menu_0833):
                add_jumlah_menu_pesanan_0833(
                    pesananTerpilih_0833, menu_id_0833, kuantitas_0833
                )
                st.success("Pesanan sudah terkirim")
                time.sleep(2)
                st.rerun()
            else:
                st.warning(
                    f"Menu dengan ID {menu_id_0833} tidak ditemukan, tolong masukan ID yang sesuai."
                )


def inputreservasi_0833():
    with st.container():
        pelanggan_0833 = get_pelanggan_0833()
        meja_0833 = get_meja_0833()
        st.header("Reservasi")

        pelanggan_options_0833 = {
            pelanggan["ID_Pelanggan"]: pelanggan["Nama_Pelanggan"]
            for pelanggan in pelanggan_0833
        }
        selected_pelanggan_id_reservasi_0833 = st.selectbox(
            "Select pelanggan",
            list(pelanggan_options_0833.keys()),
            format_func=lambda x: pelanggan_options_0833[x],
            key="select_pelanggan_reservasi_0833",
        )

        input_tanggal_0833 = st.date_input(
            "Tanggal", key="input_tanggal_reservasi_0833"
        )
        input_waktu_0833 = st.time_input("Waktu", key="input_waktu_reservasi_0833")
        Waktu_Reservasi_0833 = datetime.combine(input_tanggal_0833, input_waktu_0833)

        meja_options_0833 = {meja["ID_Meja"]: meja["Kapasitas"] for meja in meja_0833}
        selected_meja_id_reservasi_0833 = st.selectbox(
            "Pilih Kapasitas Meja",
            list(meja_options_0833.keys()),
            format_func=lambda x: meja_options_0833[x],
            key="select_meja_reservasi_0833",
        )

        if st.button("Add reservasi"):
            if (
                selected_pelanggan_id_reservasi_0833
                and Waktu_Reservasi_0833
                and selected_meja_id_reservasi_0833
            ):
                add_reservasi_0833(
                    selected_pelanggan_id_reservasi_0833,
                    Waktu_Reservasi_0833,
                    selected_meja_id_reservasi_0833,
                )
                st.success(
                    f'Reservasi pelanggan "{pelanggan_options_0833[selected_pelanggan_id_reservasi_0833]}" added successfully!'
                )
                time.sleep(2)
                st.rerun()
            else:
                st.error("Mohon isi semua data yang diperlukan.")


# START: Fungsi User Chef
def hapus_menu_0833():
    with st.container():
        menu_0833 = get_menu_0833()
        st.header("Hapus Menu")

        menu_options_0833 = {menu["ID_Menu"]: menu["Nama_Menu"] for menu in menu_0833}
        selected_menu_id_0833 = st.selectbox(
            "Select Menu",
            list(menu_options_0833.keys()),
            format_func=lambda x: menu_options_0833[x],
        )

        if st.button("Delete Menu"):
            if selected_menu_id_0833:
                delete_menu_0833(selected_menu_id_0833)
                st.success(f"Menu {selected_menu_id_0833} telah dihapus")
                time.sleep(2)
                st.rerun()
            else:
                st.error("Mohon isi semua data yang diperlukan.")


def tambah_menu_0833():
    with st.container():
        st.header("Tambah Menu")
        nama_menu_0833 = st.text_input("Nama Menu")
        harga_0833 = st.text_input("Harga")

        if st.button("Tambah Menu"):
            if nama_menu_0833 and harga_0833:
                add_menu_0833(nama_menu_0833, harga_0833)
                st.success(f"Menu {nama_menu_0833} telah ditambahkan")
                time.sleep(2)
                st.rerun()
            else:
                st.error("Mohon isi semua data yang diperlukan.")


# END: Fungsi User Chef


def manager_0833():
    st.title("Panel Manager")
    pilihan_0833 = st.selectbox("Menu", ["Data Table", "Data Visualisasi"])
    match pilihan_0833:
        case "Data Table":
            with st.container():
                st.header("Data Karyawan")
                nama_0833 = st.text_input("Masukan nama karyawan yang ingin dicari")
                st.dataframe(get_karyawan_0833(nama_0833=nama_0833), width=1000)
            with st.container():
                st.header("Data Shift")
                st.dataframe(get_shift_0833(), width=1000)
            with st.container():
                st.header("Data Shift Karyawan")
                hari_options_0833 = [
                    "Senin",
                    "Selasa",
                    "Rabu",
                    "Kamis",
                    "Jumat",
                    "Sabtu",
                    "Minggu",
                ]
                selected_hari_0833 = st.selectbox(
                    "Filter Berdasarkan Hari", ["Semua"] + hari_options_0833
                )
                st.dataframe(
                    get_shiftKaryawan_0833(
                        hari_0833=(
                            selected_hari_0833
                            if selected_hari_0833 != "Semua"
                            else None
                        )
                    ),
                    width=1000,
                )
            with st.container():
                st.header("Data Meja")
                st.dataframe(get_meja_0833(), width=1000)
            with st.container():
                st.header("Data Menu")
                st.dataframe(get_menu_0833(), width=1000)
            with st.container():
                st.header("Data Pelanggan")
                st.dataframe(get_pelanggan_0833(), width=1000)
            with st.container():
                st.header("Data Pembayaran")
                st.dataframe(get_pembayaran_0833(), width=1000)
            with st.container():
                st.header("Data Reservasi")
                st.dataframe(get_reservasi_0833(), width=1000)
                st.header("Data Riwayat Reservasi")
                st.dataframe(get_riwayatReservasi_0833(), width=1000)
            with st.container():
                st.header("Data Pesanan")
                st.dataframe(get_pesanan_0833(), width=1000)
                st.header("Data Detail Pesanan")
                st.dataframe(get_detailPesanan_0833(), width=1000)
                st.header("Data Riwayat Pesanan")
                st.dataframe(get_riwayatPesanan_0833(), width=1000)
        case "Data Visualisasi":
            with st.container():
                st.header("Graph Posisi Karyawan")
                graphPosisiKaryawan_0833()
                st.header("Graph Pesanan Menu")
                graphMenuPesanan_0833()
                st.header("Graph Meja Yang Terpakai")
                graphKapasitasMejaYangTerpakaiByReservasi_0833()
                st.header("Graph Meja Yang Terpakai (Non-Reservasi)")
                graphKapasitasMejaYangTerpakaiByPesanan_0833()


def kasir_0833():
    st.title("Panel Kasir")
    pilihanPanel_0833 = st.selectbox("Menu", ["Pelanggan", "Reservasi", "Pesanan"])
    match pilihanPanel_0833:
        case "Pelanggan":
            with st.container():
                st.header("Data Pelanggan")
                st.dataframe(get_pelanggan_0833(), width=1000)
                inputpelanggan_0833()
        case "Reservasi":
            with st.container():
                st.header("Data Reservasi")
                st.dataframe(get_reservasi_0833(), width=1000)
                inputreservasi_0833()
        case "Pesanan":
            with st.container():
                st.header("Data Pesanan")
                st.dataframe(get_pesanan_0833(), width=1000)
                st.header("Data Detail Pesanan")
                st.dataframe(get_detailPesanan_0833(), width=1000)
                st.header("Data Menu")
                st.dataframe(get_menu_0833(), width=1000)
                inputpesanan_0833()


def chef_0833():
    st.title("Panel Chef")
    pilihanPanel_0833 = st.selectbox("Menu", ["Pesanan", "Menu"])
    match pilihanPanel_0833:
        case "Pesanan":
            with st.container():
                st.header("Data Pesanan")
                st.dataframe(get_pesanan_0833(), width=1000)
                st.header("Data Detail Pesanan")
                st.dataframe(get_detailPesanan_0833(), width=1000)
        case "Menu":
            with st.container():
                st.header("Daftar Menu")
                st.dataframe(get_menu_0833(), width=1000)
                tambah_menu_0833()
                hapus_menu_0833()


def main_0833():
    st.sidebar.title("Panel Admin Restaurant")
    pilihanPanel_0833 = st.sidebar.selectbox("User", ["Manager", "Kasir", "Chef"])
    match pilihanPanel_0833:
        case "Manager":
            manager_0833()
        case "Kasir":
            kasir_0833()
        case "Chef":
            chef_0833()
    st.sidebar.image(
        "LOGO.jpeg",
        caption="Nelayan Restoran Bandung",
        use_column_width=True,
    )


if __name__ == "__main__":
    main_0833()
