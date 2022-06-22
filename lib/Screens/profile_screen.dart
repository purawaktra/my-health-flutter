import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:string_validator/string_validator.dart';

enum WhyFarther { helpdesk, reload }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
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
        nikController.text = userData.toString();
      });
    });

    userFullnameStream =
        database.child('fullname').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        fullnameController.text = userData.toString();
      });
    });

    userBirthPlaceStream =
        database.child('birthplace').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        birthPlaceController.text = userData.toString();
      });
    });

    userBirthDateStream =
        database.child('birthdate').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        dateController.text = userData.toString();
      });
    });

    userGenderStream =
        database.child('gender').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        genderController.text = userData.toString();
      });
    });

    userAddressStream =
        database.child('address').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        addressController.text = userData.toString();
      });
    });

    userCityStream =
        database.child('city').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        cityAddressController.text = userData.toString();
      });
    });

    userZipcodeStream =
        database.child('zipcode').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        zipCodeController.text = userData.toString();
      });
    });

    userPhoneNumberStream =
        database.child('phonenumber').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        mobilePhoneController.text = userData.toString();
      });
    });

    userJobStream =
        database.child('job').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        jobStatusController.text = userData.toString();
      });
    });
  }

  bool editProfile = false;
  final TextEditingController nikController = new TextEditingController();
  final TextEditingController fullnameController = new TextEditingController();
  final TextEditingController birthPlaceController =
      new TextEditingController();
  final TextEditingController dateController =
      new TextEditingController(); //"${selectedDate.toLocal()}".split(' ')[0]
  final TextEditingController genderController = new TextEditingController();

  final TextEditingController addressController = new TextEditingController();
  final TextEditingController cityAddressController =
      new TextEditingController();
  final TextEditingController zipCodeController = new TextEditingController();
  final TextEditingController mobilePhoneController =
      new TextEditingController();
  final TextEditingController jobStatusController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nikField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: nikController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (!isNumeric(value.toString()) || value!.length != 16) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.credit_card,
            color: kBlack,
          ),
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          labelText: "NIK",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(height: 0)),
    );

    final fullnameField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: fullnameController,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_outline,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Nama Lengkap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final birthPlaceField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: birthPlaceController,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tempat Lahir",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

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
      enabled: true,
      autofocus: false,
      controller: dateController,
      readOnly: true,
      style: TextStyle(color: kBlack),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.date_range_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tanggal Lahir",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final genderField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: genderController,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.people_alt_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Jenis Kelamin",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
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
          genderController.text = newValue;
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

    final addressField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: addressController,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.home_work_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Alamat",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final cityAddressField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: cityAddressController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_city_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Kota Alamat",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final zipCodeField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: zipCodeController,
      style: TextStyle(color: kBlack),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (!isNumeric(value.toString()) || value!.length != 5) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.code_off,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Kode Pos",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final mobilePhoneField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: mobilePhoneController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (!isNumeric(value.toString()) || value!.length < 9) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.phone_android,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "No HP",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final jobStatusField = TextFormField(
      enabled: editProfile,
      autofocus: false,
      readOnly: !editProfile,
      controller: jobStatusController,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.work_outline,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Pekerjaan",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Form(
            key: _formKey,
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
                          if (!editProfile) {
                            setState(() {
                              editProfile = !editProfile;
                            });
                            final snackBar = SnackBar(
                              content: const Text("Edit akun.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                editProfile = !editProfile;
                              });
                              try {
                                await database.update({
                                  "nik/" + user.uid: nikController.text,
                                  "fullname/" + user.uid:
                                      fullnameController.text,
                                  "birthplace/" + user.uid:
                                      birthPlaceController.text,
                                  "birthdate/" + user.uid: dateController.text,
                                  "gender/" + user.uid: dropdownValue,
                                  "address/" + user.uid: addressController.text,
                                  "city/" + user.uid:
                                      cityAddressController.text,
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
                          }
                        },
                        child: Text(
                          editProfile ? 'Simpan' : 'Edit',
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
                editProfile ? genderField2 : genderField,
                addressField,
                cityAddressField,
                zipCodeField,
                mobilePhoneField,
                jobStatusField,
              ],
            ),
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
