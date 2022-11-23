import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'starships_record.g.dart';

abstract class StarshipsRecord
    implements Built<StarshipsRecord, StarshipsRecordBuilder> {
  static Serializer<StarshipsRecord> get serializer =>
      _$starshipsRecordSerializer;

  String? get name;

  String? get speed;

  String? get people;

  String? get description;

  String? get imagen;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(StarshipsRecordBuilder builder) => builder
    ..name = ''
    ..speed = ''
    ..people = ''
    ..description = ''
    ..imagen = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('starships');

  static Stream<StarshipsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<StarshipsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  StarshipsRecord._();
  factory StarshipsRecord([void Function(StarshipsRecordBuilder) updates]) =
      _$StarshipsRecord;

  static StarshipsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createStarshipsRecordData({
  String? name,
  String? speed,
  String? people,
  String? description,
  String? imagen,
}) {
  final firestoreData = serializers.toFirestore(
    StarshipsRecord.serializer,
    StarshipsRecord(
      (s) => s
        ..name = name
        ..speed = speed
        ..people = people
        ..description = description
        ..imagen = imagen,
    ),
  );

  return firestoreData;
}
