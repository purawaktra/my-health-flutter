import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/registration_screen.dart';
import 'package:myhealth/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreen createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              title,
              style: TextStyle(
                  color: kDarkBlue, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                subtitle,
                style: const TextStyle(
                    color: kDarkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoubleBack(
        onFirstBackPress: (context) {
          final snackBar = SnackBar(
            content: Text('Tekan kembali untuk keluar.',
                style: TextStyle(color: Colors.black)),
            backgroundColor: kYellow,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.only(bottom: 60),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: [
                buildPage(
                    color: Colors.white,
                    urlImage: "assets/images/welcome_screen_0.png",
                    title: 'Rekam Medisku',
                    subtitle:
                        "Pernahkah kamu berpikir bagaimana menyimpan hasil laboratoriummu saat medical checkup minggu lalu? Atau terpikir cara mudah untuk melihat hasil itu tanpa harus ribet?. "),
                buildPage(
                    color: Colors.white,
                    urlImage: "assets/images/welcome_screen_1.png",
                    title: 'Mengelola?',
                    subtitle:
                        "Selain mengumpulkan dan memilah rekam medismu, kamu juga harus menjaga rekam medismu dari segala resiko yang bisa terjadi loh, seperti basah, kusut, tulisan memudar, atau bahkan hilang!"),
                buildPage(
                    color: Colors.white,
                    urlImage: "assets/images/welcome_screen_2.png",
                    title: 'Berbagi',
                    subtitle:
                        "Tujuan kamu untuk mengelola adalah untuk menggambarkan riwayat kesehatan secara baik dan lengkap, baik ke kekeluarga, dokter pribadi, ataupun ke fasilitas kesehatan. Pastinya akan ribet kalau harus bawa dokumen sana sini."),
              ],
            ),
          ),
          bottomSheet: isLastPage
              ? TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      primary: Colors.white,
                      backgroundColor: kLightBlue1,
                      minimumSize: const Size.fromHeight(60)),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
                  },
                  child: const Text(
                    "Mulai!",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ))
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                  height: 60,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () => controller.jumpToPage(2),
                              child: const Text("Lewati")),
                          Center(child: Container()),
                          TextButton(
                              onPressed: () => controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut),
                              child: const Text("Selanjutnya")),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(child: Container()),
                          SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: WormEffect(
                                spacing: 16,
                                dotColor: kWhite,
                                activeDotColor: kLightBlue1),
                            onDotClicked: (index) => controller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                          ),
                          Center(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
