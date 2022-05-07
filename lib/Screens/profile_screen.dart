import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';

enum WhyFarther { helpdesk, reload }

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
  String dropdownValue = 'Laki Laki';
  late WhyFarther _selection;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _activateListener();
  }

  void _activateListener() {
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

  bool editProfile = true;
  bool enabledForm = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nikController =
        new TextEditingController(text: displayTextUserNIK);
    final nikField = TextFormField(
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
    DateTime selectedDate = DateTime.now();
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900, 1),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
      }
      dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }

    final dateField = TextFormField(
      enabled: enabledForm,
      autofocus: false,
      controller: dateController,
      showCursor: true,
      readOnly: editProfile,
      style: TextStyle(color: kBlack),
      onTap: () => _selectDate(context),
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
    final genderField2 = DropdownButtonFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.people_alt_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Jenis Kelamin",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      autofocus: false,
      value: dropdownValue,
      style: const TextStyle(color: Colors.black),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          displayTextUserGender = newValue;
        });
      },
      items: <String>['Laki Laki', 'Perempuan']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final TextEditingController addressController =
        new TextEditingController(text: displayTextUserAddress);
    final addressField = TextFormField(
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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
      enabled: enabledForm,
      autofocus: false,
      readOnly: editProfile,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Informasi Pribadi"),
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              setState(() {
                _selection = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.reload,
                child: Text('Muat Ulang - BLOM'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.helpdesk,
                child: Text('Bantuan - BLOM'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              userIDField,
              displayNameField,
              emailField,
              Divider(
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      'Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kLightBlue1,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          editProfile = !editProfile;
                          enabledForm = !enabledForm;
                        });
                        if (enabledForm) {
                          final snackBar = SnackBar(
                            content: const Text("Edit akun.",
                                style: TextStyle(color: Colors.black)),
                            backgroundColor: kYellow,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          try {
                            await database.update({
                              "nik/" + user.uid: nikController.text,
                              "fullname/" + user.uid: fullnameController.text,
                              "birthplace/" + user.uid:
                                  birthPlaceController.text,
                              "birthdate/" + user.uid: dateController.text,
                              "gender/" + user.uid: displayTextUserGender,
                              "address/" + user.uid: addressController.text,
                              "city/" + user.uid: cityAddressController.text,
                              "zipcode/" + user.uid: zipCodeController.text,
                              "phonenumber/" + user.uid:
                                  mobilePhoneController.text,
                              "job/" + user.uid: jobStatusController.text
                            });

                            final snackBar = SnackBar(
                              content: const Text("Tersimpan.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            print(e);
                            final snackBar = SnackBar(
                              content: const Text(
                                  "Update gagal, cek koneksi internet.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Text(
                        enabledForm ? 'Simpan' : 'Edit',
                        style: TextStyle(color: kWhite),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kLightBlue1),
                          visualDensity: VisualDensity.compact),
                    )
                  ],
                ),
              ),
              nikField,
              fullnameField,
              birthPlaceField,
              dateField,
              editProfile ? genderField : genderField2,
              addressField,
              cityAddressField,
              zipCodeField,
              mobilePhoneField,
              jobStatusField,
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
