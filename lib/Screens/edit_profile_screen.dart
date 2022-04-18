import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/components/background.dart';
import '../constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
    // TODO: implement initState
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    // ignore: cancel_subscriptions
    userNIKStream =
        database.child('nik').child(user.uid).onValue.listen((event) {
      if (event.snapshot.exists) {
        final Object? userData = event.snapshot.value;
        setState(() {
          displayTextUserNIK = userData.toString();
        });
      }
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
    uploadFile(XFile? file) async {
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file was selected'),
          ),
        );

        return null;
      }
      UploadTask uploadTask;
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('photo-profile')
          .child('/' + user.uid + '.jpg');

      try {
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } catch (e) {
        print(e);
        try {
          uploadTask = ref.putFile(File(file.path), metadata);
        } catch (e) {
          print(e);
        }
      }
      final link = await ref.getDownloadURL();
      return link;
    }

    final TextEditingController nikController =
        new TextEditingController(text: displayTextUserNIK);
    final nikField = TextFormField(
      autofocus: false,
      controller: nikController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan NIK Anda");
        }
        if (!RegExp(r"^(\d{16})$").hasMatch(value)) {
          return ("Mohon Masukkan NIK yang Sesuai");
        }

        return null;
      },
      onSaved: (value) {
        nikController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: fullnameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Nama Lengkap Anda");
        }

        return null;
      },
      onSaved: (value) {
        fullnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: birthPlaceController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Tempat Lahir Anda");
        }

        return null;
      },
      onSaved: (value) {
        birthPlaceController.text = value!;
      },
      textInputAction: TextInputAction.next,
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

    DateTime selectedDate = DateTime.now();
    final TextEditingController dateController = new TextEditingController(
        text:
            displayTextUserBirthDate); //"${selectedDate.toLocal()}".split(' ')[0]
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
      autofocus: false,
      controller: dateController,
      showCursor: true,
      readOnly: true,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Tanggal Lahir Anda");
        }

        return null;
      },
      onTap: () => _selectDate(context),
      onSaved: (value) {
        dateController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: genderController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Jenis Kelamin Anda");
        }

        if (!RegExp("^(\bLaki Laki\b)|(\bPerempuan\b)").hasMatch(value)) {
          return ("Mohon Masukkan Gender: Laki Laki atau Perempuan");
        }

        return null;
      },
      onSaved: (value) {
        genderController.text = value!;
      },
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
      autofocus: false,
      controller: addressController,
      keyboardType: TextInputType.streetAddress,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Alamat Anda");
        }

        return null;
      },
      onSaved: (value) {
        addressController.text = value!;
      },
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
      autofocus: false,
      controller: cityAddressController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Kota Alamat Anda");
        }

        return null;
      },
      onSaved: (value) {
        cityAddressController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: zipCodeController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Kode Pos Anda");
        }

        return null;
      },
      onSaved: (value) {
        zipCodeController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: mobilePhoneController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan No HP Anda");
        }

        return null;
      },
      onSaved: (value) {
        mobilePhoneController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      autofocus: false,
      controller: jobStatusController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Pekerjaan Anda");
        }

        return null;
      },
      onSaved: (value) {
        jobStatusController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
        hintText: "ID Pengguna - Tetap",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "ID Pengguna - Tetap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController displayNameController =
        new TextEditingController(text: user.displayName!);
    final displayNameField = TextFormField(
      autofocus: false,
      controller: displayNameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Username Anda");
        }

        return null;
      },
      onSaved: (value) {
        displayNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_outlined,
          color: kBlack,
        ),
        hintText: "Email Terverifikasi - Tetap",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Email Terverifikasi - Tetap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    return Background(
      title: "Edit Data Pribadi",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Data Pribadi",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Sentuh untuk mengubah data pribadi. Gunakan kode negara Indonesia (62) untuk mengisi kolom Nomer HP",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  height: 8,
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
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await database.update({
                        "nik/" + user.uid: nikController.text,
                        "fullname/" + user.uid: fullnameController.text,
                        "birthplace/" + user.uid: birthPlaceController.text,
                        "birthdate/" + user.uid: dateController.text,
                        "gender/" + user.uid: genderController.text,
                        "address/" + user.uid: addressController.text,
                        "city/" + user.uid: cityAddressController.text,
                        "zipcode/" + user.uid: zipCodeController.text,
                        "phonenumber/" + user.uid: mobilePhoneController.text,
                        "job/" + user.uid: jobStatusController.text
                      });

                      final snackBar = SnackBar(
                        content: const Text("Update data pribadi berhasil.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      print(e);
                      final snackBar = SnackBar(
                        content: const Text(
                            "Update data pribadi gagal, silahkan muat ulang aplikasi.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    "Update Data Pribadi",
                    style: TextStyle(color: kWhite),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kLightBlue1)),
                ),
                Divider(color: kDarkBlue),
                Text(
                  "Data Akun",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Sentuh untuk mengubah data akun. Hanya nama pengguna yang dapat diganti. Penggantian data akun akan memakan waktu untuk dimuat. Format Photo Profil dalam bentuk file jpg.",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final XFile? file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        String? photoURL = await uploadFile(file);
                        await user.updatePhotoURL(photoURL);

                        final snackBar = SnackBar(
                          content: const Text("Sedang memuat...",
                              style: TextStyle(color: Colors.black)),
                          backgroundColor: kYellow,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        "Ganti Photo Profil",
                        style: TextStyle(color: kWhite),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kLightBlue1)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                userIDField,
                displayNameField,
                emailField,
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await user.updateDisplayName(displayNameController.text);
                      final snackBar = SnackBar(
                        content: const Text("Update akun berhasil.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      print(e);
                      final snackBar = SnackBar(
                        content: const Text(
                            "Update data akun gagal, silahkan muat ulang aplikasi.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    "Update Akun",
                    style: TextStyle(color: kWhite),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kLightBlue1)),
                ),
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
