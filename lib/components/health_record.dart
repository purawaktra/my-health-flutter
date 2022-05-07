import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_record.g.dart';

@JsonSerializable()
class AccessEntry {
  String notes;
  String entryID;
  String entryType;
  String uid;
  bool enabled;
  String hash;
  String date;

  AccessEntry(this.entryID,
      {required this.entryType,
      required this.enabled,
      required this.uid,
      required this.hash,
      required this.date,
      this.notes = ""});

  factory AccessEntry.fromJson(Map<String, dynamic> json) =>
      _$AccessEntryFromJson(json);
  Map<String, dynamic> toJson() => _$AccessEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccessEntryBlockChain {
  String uid;
  List<AccessEntry> data = [];
  AccessEntryBlockChain(this.uid) {
    this.data.add(AccessEntry(
          "genesis",
          entryType: "genesis",
          enabled: true,
          uid: "genesis",
          notes: "genesis",
          date: "${DateTime.now().toLocal()}".split(' ')[0],
          hash: sha256.convert(utf8.encode(this.uid)).toString(),
        ));
  }

  factory AccessEntryBlockChain.fromJson(Map<String, dynamic> json) =>
      _$AccessEntryBlockChainFromJson(json);

  Map<String, dynamic> toJson() => _$AccessEntryBlockChainToJson(this);
}

@JsonSerializable()
class HealthRecordEntry {
  late String healthRecordID;
  late String creationDate;
  late String description;
  late String location;
  late String name;
  late String tag;

  Map<String, String> metaData = Map<String, String>();

  HealthRecordEntry(this.healthRecordID);

  addKeyValuePair(key, value) {
    metaData[key] = value;
  }

  factory HealthRecordEntry.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordEntryFromJson(json);

  Map<String, dynamic> toJson() => _$HealthRecordEntryToJson(this);
}
