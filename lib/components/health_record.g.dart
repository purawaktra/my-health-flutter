// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessEntry _$AccessEntryFromJson(Map<String, dynamic> json) => AccessEntry(
      json['entryID'] as String,
      entryType: json['entryType'] as String,
      enabled: json['enabled'] as bool,
      uid: json['uid'] as String,
      hash: json['hash'] as String,
      date: json['date'] as String,
      notes: json['notes'] as String? ?? "",
    );

Map<String, dynamic> _$AccessEntryToJson(AccessEntry instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'entryID': instance.entryID,
      'entryType': instance.entryType,
      'uid': instance.uid,
      'enabled': instance.enabled,
      'hash': instance.hash,
      'date': instance.date,
    };

AccessEntryBlockChain _$AccessEntryBlockChainFromJson(
        Map<String, dynamic> json) =>
    AccessEntryBlockChain(
      json['uid'] as String,
    )..data = (json['data'] as List<dynamic>)
        .map((e) => AccessEntry.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$AccessEntryBlockChainToJson(
        AccessEntryBlockChain instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

HealthRecordEntry _$HealthRecordEntryFromJson(Map<String, dynamic> json) =>
    HealthRecordEntry(
      json['healthRecordID'] as String,
    )
      ..creationDate = json['creationDate'] as String
      ..description = json['description'] as String
      ..location = json['location'] as String
      ..name = json['name'] as String
      ..tag = json['tag'] as String
      ..metaData = Map<String, String>.from(json['metaData'] as Map);

Map<String, dynamic> _$HealthRecordEntryToJson(HealthRecordEntry instance) =>
    <String, dynamic>{
      'healthRecordID': instance.healthRecordID,
      'creationDate': instance.creationDate,
      'description': instance.description,
      'location': instance.location,
      'name': instance.name,
      'tag': instance.tag,
      'metaData': instance.metaData,
    };
