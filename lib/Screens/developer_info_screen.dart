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
                              TextSpan(text: "\nv0.4.0 Alpha\n ")
                            ]),
                      ),
                      // Text("Many thanks to",
                      //     style:
                      //         TextStyle(color: Colors.black54, fontSize: 16)),
                      // Text(
                      //     "- Allah, Alhamdulillah, segala rahmat dan karunia-Nya, syukurku kepada-Nya tak bisa dan tak akan pernah bisa dijelaskan oleh kata kata.",
                      //     style:
                      //         TextStyle(color: Colors.black54, fontSize: 16)),
                      // Text(
                      //     "- Dr. Achmad Arifin, S.T., M. Eng. selaku dosen pembimbing, yang senantiasa membimbing, mengarahkan, dan memotivasi selama pengerjaan aplikasi ini.",
                      //     style:
                      //         TextStyle(color: Colors.black54, fontSize: 16)),
                      // Text(
                      //     "- Prof. Dr. Ir. Mohammad NUH, DEA. selaku dosen pembimbing, memberikan motivasi yang sangat besar berkat pengalaman dan pengetahuan beliau untuk dapat menyelesaikan aplikasi ini.",
                      //     style:
                      //         TextStyle(color: Colors.black54, fontSize: 16)),
                      // Text(
                      //     "- Sam Fatur, Yulyy, Kobas, Aslahah, teman temanku, kuisioner, dan pengguna yang ngasih kritik dan saran membangunnya, tanpa kalian aku ga akan ada improvement di user experience aplikasi ini :D.",
                      //     style:
                      //         TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "Special thanks to freepik.com that provide the design apps for User Interface. You are the legends!",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nChangelog",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.4.0 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("- Rework UI nya, biar cantikkk.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.5 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework all the validation form, dari form login, registrasi, lupa password, berkas baru rekam medis, partner baru, informasi pribadi, ganti nama tampilan, semuanyaa.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Working untuk perubahan metode partner, sekarang file partner akan di create ketika pendaftaran akun. Akun akun lama mungkin harus direcreate untuk bisa pakai aplikasinya",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Automasi pada halaman depan, sekarang udah bisa gerak gerak sendiri dengan timer yang diset di interval lima detik.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.4 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahkan fitur search pada halaman rekam medis, sekarang kamu ngga kesulitan lagi cari rekam medismu, pilihannya sih bisa pakai kata kunci atau berdasarkan tanggal.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework attachment, sama custom column buat adding berkas rekam medis baru, ada bug baru kalau modify rekam medisnya, kolomnya bisa ke submit dua kali.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin validasi pada form berkas baru rekam medis, rework error code nya biar pakai snackbar instead pakai textform error.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.3 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Benerin qr scanner yang glitch kalau lagi diadepin ke barcode, sekarang kalau sudah dapat info barcode langsung pause stream dari kamera.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.2 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Working dihalaman partner, tujuannya kalau mau lihat informasi pribadi, rekam medis dan riwayat izin dari partner.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin fungsi hapus di halaman partner, untuk nambahin entry buat remove partner dari list request blockchain yak.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework dihalaman awal ya ges, biar keliatan lebih attraktif hehe.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.1 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin button menuju ke qr scanner, dihalaman tambah partner, kalau nambah lewat qr code otomatis masuk ke dalam list request dan list permit yaa.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nama partner sudah bisa muncul dihalaman utama, instead dari user id nya. Kalau user id mu masuk ke dalam list permit dari partner blockchain, maka kamu bisa liat rekam medis punya merekaa.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.3.0 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Halaman partner sekarang udah bisa diakses yaak, setelah nambahin halaman buat nambahin partner, sekarang partner yang termasuk dalam list request rekam medis dapat dilihat dihalaman utama partnerrr!! yeay",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- List akses partner sepenuhnya pakai sistem blockchain ya gais, setiap membuka halaman partner, nanti akan terinisialisasi struktur blockchain baru, kalau misalnya diserver deteksi kalau belum ada strukturnya yang terkait dengan akun.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.11 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- QR code scannerr yeeeey, sekarang nambahin partner(OTW) ga perlu ribet ribet masukin entry secara manual ya ges yak, tinggal scan aja sudah sukses, change log ini cuma buat qr code ya, Im glad qr scannernya bisa jalan wkw.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.10 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Mengubah dikit qr code generator, pinginnya sih ditengah biar ada logo aplikasi, tp kayanya masih ga bisa deh huehue.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Ngehapus dashboard screen, yang sebelumnya banyak ikon ikon itu, kayanya model dashboard kya gitu udah ga match ya wkww.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Oh ya sama benerin refresh behaviornya, bisa nih sekarang refresh halaman health record sama halaman partner(OTW) tinggal di swipe down aja.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.9 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Mengubah tampilan dikit dihalaman tambah health record (bentuk buttonnya sama biar kalau button agar ga keklik berkali kali saat proses upload berlangsung ya).",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Sekarang kalau tambah health record sudah bisa lebih dari satu lampiran ya ges yak, pastikan aja kalau lampirannya tidak berat atau gede ukurannya, biar ga lelet pas upload hehe.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin qr code generator, rencananya biar bisa scan qr code kalau mau nambahin jadi partner begitu.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.8 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Rework fetching data lampiran, pingin lampirannya ngga terbatas cuma satu buat satu health record entry ya ges.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Sekarang menambah health record baru ga harus pilih jenis lampiran dulu, sekarang sudah dijadikan satu di satu halaman penuh, nanti kalau mau nambahin jenis lampiran tinggal lewat popup box.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text("\nv0.2.7 Alpha",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Mengubah dikit di kustom kolom, sedikit bug ketika hapus dan tambah.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Nambahin fitur buka dan share di lampiran filenya, jadi sekarang bisa buka halaman health record dan buka lampiran masing masing yaa.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                      Text(
                          "- Tampilan dihalaman depan health record sekarang diubah dikit, sudah dimasukkan ke dalam entry screen, nambahin juga option menu.",
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
