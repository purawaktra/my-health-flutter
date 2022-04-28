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
  String displayTextUserNIK = "Belum diatur";
  String displayTextUserFullname = "Belum diatur";
  String displayTextUserBirthPlace = "Belum diatur";
  String displayTextUserBirthDate = "Belum diatur";
  String displayTextUserGender = "Belum diatur";
  String displayTextUserAddress = "Belum diatur";
  String displayTextUserCity = "Belum diatur";
  String displayTextUserZipcode = "Belum diatur";
  String displayTextUserPhoneNumber = "Belum diatur";
  String displayTextUserJob = "Belum diatur";

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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController fullnameController =
        new TextEditingController(text: displayTextUserFullname);
    final fullnameField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController birthPlaceController =
        new TextEditingController(text: displayTextUserBirthPlace);
    final birthPlaceField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController dateController = new TextEditingController(
        text:
            displayTextUserBirthDate); //"${selectedDate.toLocal()}".split(' ')[0]
    final dateField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController genderController =
        new TextEditingController(text: displayTextUserGender);
    final genderField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController addressController =
        new TextEditingController(text: displayTextUserAddress);
    final addressField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController cityAddressController =
        new TextEditingController(text: displayTextUserCity);
    final cityAddressField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController zipCodeController =
        new TextEditingController(text: displayTextUserZipcode);
    final zipCodeField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController mobilePhoneController =
        new TextEditingController(text: displayTextUserPhoneNumber);
    final mobilePhoneField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController jobStatusController =
        new TextEditingController(text: displayTextUserJob);
    final jobStatusField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController userIDController =
        new TextEditingController(text: user.uid);
    final userIDField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController displayNameController =
        new TextEditingController(text: user.displayName!);
    final displayNameField = TextFormField(
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    return Background(
      title: "Informasi Pribadi",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.displayName!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      user.uid,
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      },
                      child: Text(
                        "Ubah Data Pribadi dan Akun",
                        style: TextStyle(color: kWhite),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kLightBlue1)),
                    )
                  ],
                ),
              ),
              Divider(
                color: kDarkBlue,
              ),
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
