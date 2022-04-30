import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/edit_profile_screen.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription userNIKStream;
  late StreamSubscription userFullnameStream;
  late StreamSubscription userBirthPlaceStream;
  late StreamSubscription userBirthDateStream;
  late StreamSubscription userGenderStream;
  late StreamSubscription userAddressStream;
  late StreamSubscription userCityStream;
  late StreamSubscription userZipcodeStream;
  late StreamSubscription userPhoneNumberStream;
  late StreamSubscription userJobStream;
  String displayTextUserNIK = "Memuat...";
  String displayTextUserFullname = "Memuat...";
  String displayTextUserBirthPlace = "Memuat...";
  String displayTextUserBirthDate = "Memuat...";
  String displayTextUserGender = "Memuat...";
  String displayTextUserAddress = "Memuat...";
  String displayTextUserCity = "Memuat...";
  String displayTextUserZipcode = "Memuat...";
  String displayTextUserPhoneNumber = "Memuat...";
  String displayTextUserJob = "Memuat...";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    // ignore: cancel_subscriptions

    userNIKStream =
        database.child('nik').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserNIK = userData.toString();
      });
    });

    userFullnameStream =
        database.child('fullname').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserFullname = userData.toString();
      });
    });

    userBirthPlaceStream =
        database.child('birthplace').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserBirthPlace = userData.toString();
      });
    });

    userBirthDateStream =
        database.child('birthdate').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserBirthDate = userData.toString();
      });
    });

    userGenderStream =
        database.child('gender').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserGender = userData.toString();
      });
    });

    userAddressStream =
        database.child('address').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserAddress = userData.toString();
      });
    });

    userCityStream =
        database.child('city').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserCity = userData.toString();
      });
    });

    userZipcodeStream =
        database.child('zipcode').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserZipcode = userData.toString();
      });
    });

    userPhoneNumberStream =
        database.child('phonenumber').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserPhoneNumber = userData.toString();
      });
    });

    userJobStream =
        database.child('job').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserJob = userData.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nikController =
        new TextEditingController(text: displayTextUserNIK);
    final nikField = TextFormField(
      enabled: (displayTextUserNIK == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: nikController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.credit_card,
          color: kBlack,
        ),
        hintText: "NIK",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "NIK",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController fullnameController =
        new TextEditingController(text: displayTextUserFullname);
    final fullnameField = TextFormField(
      enabled: (displayTextUserFullname == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: fullnameController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_outline,
          color: kBlack,
        ),
        hintText: "Nama Lengkap",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Nama Lengkap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController birthPlaceController =
        new TextEditingController(text: displayTextUserBirthPlace);
    final birthPlaceField = TextFormField(
      enabled: (displayTextUserBirthPlace == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: birthPlaceController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: kBlack,
        ),
        hintText: "Tempat Lahir",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tempat Lahir",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController dateController = new TextEditingController(
        text:
            displayTextUserBirthDate); //"${selectedDate.toLocal()}".split(' ')[0]
    final dateField = TextFormField(
      enabled: (displayTextUserBirthDate == "") ? false : true,
      autofocus: false,
      controller: dateController,
      showCursor: true,
      readOnly: true,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.date_range_outlined,
          color: kBlack,
        ),
        hintText: "Tanggal Lahir",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tanggal Lahir",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController genderController =
        new TextEditingController(text: displayTextUserGender);
    final genderField = TextFormField(
      enabled: (displayTextUserGender == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: genderController,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.people_alt_outlined,
          color: kBlack,
        ),
        hintText: "Jenis Kelamin",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Jenis Kelamin",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController addressController =
        new TextEditingController(text: displayTextUserAddress);
    final addressField = TextFormField(
      enabled: (displayTextUserAddress == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: addressController,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.home_work_outlined,
          color: kBlack,
        ),
        hintText: "Alamat",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Alamat",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController cityAddressController =
        new TextEditingController(text: displayTextUserCity);
    final cityAddressField = TextFormField(
      enabled: (displayTextUserCity == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: cityAddressController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_city_outlined,
          color: kBlack,
        ),
        hintText: "Kota Alamat",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Kota Alamat",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController zipCodeController =
        new TextEditingController(text: displayTextUserZipcode);
    final zipCodeField = TextFormField(
      enabled: (displayTextUserZipcode == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: zipCodeController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.code_off,
          color: kBlack,
        ),
        hintText: "Kode Pos",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Kode Pos",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController mobilePhoneController =
        new TextEditingController(text: displayTextUserPhoneNumber);
    final mobilePhoneField = TextFormField(
      enabled: (displayTextUserPhoneNumber == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: mobilePhoneController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.phone_android,
          color: kBlack,
        ),
        hintText: "No HP",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "No HP",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController jobStatusController =
        new TextEditingController(text: displayTextUserJob);
    final jobStatusField = TextFormField(
      enabled: (displayTextUserJob == "") ? false : true,
      autofocus: false,
      readOnly: true,
      controller: jobStatusController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.work_outline,
          color: kBlack,
        ),
        hintText: "Pekerjaan",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Pekerjaan",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController userIDController =
        new TextEditingController(text: user.uid);
    final userIDField = TextFormField(
      enabled: true,
      autofocus: false,
      controller: userIDController,
      readOnly: true,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.people_outline_outlined,
          color: kBlack,
        ),
        hintText: "ID Pengguna",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "ID Pengguna",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController displayNameController =
        new TextEditingController(text: user.displayName!);
    final displayNameField = TextFormField(
      enabled: true,
      autofocus: false,
      readOnly: true,
      controller: displayNameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.people_alt_outlined,
          color: kBlack,
        ),
        hintText: "Nama Pengguna",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Nama Pengguna",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController emailController =
        new TextEditingController(text: user.email);
    final emailField = TextFormField(
      autofocus: false,
      readOnly: true,
      controller: emailController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_outlined,
          color: kBlack,
        ),
        hintText: "Email Terverifikasi",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Email Terverifikasi",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    return Background(
      title: "Akun",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              nikField,
              fullnameField,
              birthPlaceField,
              dateField,
              genderField,
              addressField,
              cityAddressField,
              zipCodeField,
              mobilePhoneField,
              jobStatusField,
              Divider(
                color: kDarkBlue,
              ),
              userIDField,
              displayNameField,
              emailField,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    userNIKStream.cancel();
    userFullnameStream.cancel();
    userBirthPlaceStream.cancel();
    userBirthDateStream.cancel();
    userGenderStream.cancel();
    userAddressStream.cancel();
    userCityStream.cancel();
    userZipcodeStream.cancel();
    userPhoneNumberStream.cancel();
    userJobStream.cancel();
    super.deactivate();
  }
}
