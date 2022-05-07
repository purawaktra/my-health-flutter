import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Info Pengembang"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "MyHealth App \nHealth Record Management\n",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18)),
                              TextSpan(
                                  text:
                                      "\nMuhammad Akbar Maulana\nDepartemen Teknik Biomedik \nInstitut Teknologi Sepuluh Nopember"),
                              TextSpan(text: "\nv0.2.6 Alpha\n ")
                            ]),
                      ),
                      Text("Many thanks to",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "Sam Fatur, Yulyy, Kobas, sama Dekk aslahah, yang ngasih kritik dan saran membangunnya :D.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("Changelog",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.6 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin lupa password dihalaman ubah password, siapa tahu kalau ada yang lupa passwordnya.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Mbenerin delete accound sama delete data, sekarang sudah bisa delete langsung di appnya, sekaligus hapus entry rekam medis sama entry partner.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.5 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Sekarang bisa nambahin custom kolom ya gaiss, baik dari entry rekam medis baru, atau rekam medis existing.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin biar custom kolomnya bisa nambah dan hapus, sama sekalian ngeditnya dalam satu screen, ini asli pusing banget.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Semoga aja ga ada bug dari custom colomnya, case penggunaannya, contohnya kalau mau nambahin info2 penting yang bersifat key pair, kaya berat badan, tinggi badan gitu2 .",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.4 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework baru di User Interface, lebih minimalis dan fokus ke core feature yang ada",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambah pilihan di entry rekam medis, kalau mau ngapa ngapain lebih baik buka entrynya.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.3 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin tanggal di list rekam medis, biar sat set kalau mencari",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Rework untuk fetching data dari server",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Sekarang di profile, kalau milih jenis kelamin sudah bisa pakai dropdown ya gais, dulu ribet harus validasi input dulu.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.2 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Cuman fixing bug kalau login dan validasi snapshot pake google credential",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin button untuk ganti password, cocok buat kamu yang suka ganti ganti hehe, harusnya mau nambahkan lupa password, tp dihalaman depan sudah ada.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Email dan google link, kalau habis login pakai google, biar bisa login pakai password, skarang sudah bisa ya ges",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework di akun screen, ganti display name sama photo profile tidak perlu keluar halaman yaa",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.1 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Fixing error credential kalau mau ganti password, hapus data sama akun.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework menu, sekarang tampilan jadi screenless gitu, keren ga si, ga kaya tampilan kemarin. Kalau liat aplikasi kekinian sekarang sudah pakai bottom tab semua, masa aku ngga hehe",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nghapus navigasi bar, kayanya ga penting penting banget, berkaca ke aplikasi2 unicorn lainnya heehe.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Halaman tampilan lama masih bisa diakses kok, tp cuman pajangan aja, nanti bakal diganti dengan live feed infografis.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.0 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Fixing stream data untuk info profile yang buggy, apalagi kalau ditambah sama fitur edit.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Ngeubah icon yang ada ditampilan awal, biar keren hehe, sekalian bikin isi dashboard screen lebih kaya.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Ngeubah fungsi navigator bar menjadi helper bar, jadi kalau ada kesulitan tinggal swipe aja untuk cari panduan lengkap.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Fixing photo profile yang error kalau habis update, kalau setelah change photo profile, cache yang sudah terdownload tidak mau fetch data terbaru.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.1.3 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Menambahkan fitur stream untuk hasil entry akses rekam medis",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Menambahkan welcome screen diawal aplikasi terbuka, untuk infografis dan petunjuk penggunaan aplikasi.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Menambahkan fungsi lupa password dan validasi email saat registrasi.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.1.2 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Membangun fitur login dengan google untuk memudahkan.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Membangun halaman awal pada tampilan rekam medis",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Menyusun key yang digunakan untuk rekam medis.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Menyusun key yang digunakan untuk informasi pribadi.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.1.1 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Tampilan awal untuk login screen.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Menyusun server untuk digunakan pada aplikasi.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ]))));
  }
}
