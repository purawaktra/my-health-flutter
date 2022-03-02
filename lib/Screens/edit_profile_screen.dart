import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background_raw.dart';

import '../constants.dart';

class EditProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final userID = user.uid.toString();
    final userName = database.child('username');
    final userEmail = database.child('useremail');
    final urlImage = database.child('userurlphoto');

    final TextEditingController nikController = new TextEditingController();
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
      ),
    );

    final TextEditingController firstNameController =
        new TextEditingController();
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Nama Depan Anda");
        }

        return null;
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_outline,
          color: kBlack,
        ),
        hintText: "Nama Depan",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
    );

    final TextEditingController lastNameController =
        new TextEditingController();
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Nama Belakang Anda");
        }

        return null;
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_outline,
          color: kBlack,
        ),
        hintText: "Nama Belakang",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
    );

    final TextEditingController birthPlaceController =
        new TextEditingController();
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
      ),
    );

    DateTime selectedDate = DateTime.now();
    final TextEditingController dateController = new TextEditingController(
        text: "${selectedDate.toLocal()}".split(' ')[0]);
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
      ),
    );

    final TextEditingController genderController = new TextEditingController();
    final genderField = TextFormField(
      autofocus: false,
      controller: genderController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Jenis Kelamin Anda");
        }

        if (!RegExp("^(\bLaki Laki\b)|(\bPerempuan\b)|(\bLain Lain\b)")
            .hasMatch(value)) {
          return ("Mohon Masukkan Gender: Laki Laki, Perempuan, atau Lain Lain");
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
      ),
    );

    final TextEditingController addressController = new TextEditingController();
    final addressField = TextFormField(
      autofocus: false,
      controller: birthPlaceController,
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
      ),
    );

    final TextEditingController cityAddressController =
        new TextEditingController();
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
      ),
    );

    final TextEditingController zipCodeController = new TextEditingController();
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
      ),
    );

    final TextEditingController mobilePhoneController =
        new TextEditingController();
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
      ),
    );

    final TextEditingController emailController =
        new TextEditingController(text: user.email);
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Email Anda");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Mohon Masukkan Email yang Valid");
        }

        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_outlined,
          color: kBlack,
        ),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
    );

    return BackgroundRaw(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(color: kYellow),
              nikField,
              firstNameField,
              lastNameField,
              birthPlaceField,
              dateField,
              genderField,
              addressField,
              cityAddressField,
              zipCodeField,
              mobilePhoneField,
              ElevatedButton(
                  onPressed: () {
                    userEmail.set({userID: userEmail});
                  },
                  child: Text(
                    "Update Data Profil",
                    style: TextStyle(color: kWhite),
                  )),
              Divider(color: kYellow),
              emailField,
            ],
          ),
        ),
      ),
    );
  }
}
