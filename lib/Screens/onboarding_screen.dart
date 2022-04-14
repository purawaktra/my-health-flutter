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
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(
              height: 64,
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
              ),
            )
          ],
        ),
      );

  Widget build(BuildContext context) {
    return MaterialApp(
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
                    urlImage: "assets/images/dev_logo.png",
                    title: 'myHealth',
                    subtitle:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et ullamcorper tellus, id volutpat quam. Donec non nisl dapibus, consectetur arcu a, tempus mauris. Nam a mollis ex. Cras ultricies leo a odio maximus condimentum. Proin eget euismod mi, vitae luctus justo. Pellentesque ultricies sagittis volutpat."),
                buildPage(
                    color: Colors.white,
                    urlImage: "assets/images/dev_logo.png",
                    title: 'Manage',
                    subtitle:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et ullamcorper tellus, id volutpat quam. Donec non nisl dapibus, consectetur arcu a, tempus mauris. Nam a mollis ex. Cras ultricies leo a odio maximus condimentum. Proin eget euismod mi, vitae luctus justo. Pellentesque ultricies sagittis volutpat."),
                buildPage(
                    color: Colors.white,
                    urlImage: "assets/images/dev_logo.png",
                    title: 'Sharing',
                    subtitle:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et ullamcorper tellus, id volutpat quam. Donec non nisl dapibus, consectetur arcu a, tempus mauris. Nam a mollis ex. Cras ultricies leo a odio maximus condimentum. Proin eget euismod mi, vitae luctus justo. Pellentesque ultricies sagittis volutpat."),
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
