// ignore_for_file: avoid_unused_constructor_parameters, unused_element
import 'package:firestore_converter_annotation/firestore_converter_annotation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
    '@FirestoreConverter should only be applied on classes. Failing element: throwExceptionOnNonClass')
@FirestoreConverter(defaultPath: 'test')
Object? throwExceptionOnNonClass;

@ShouldGenerate(r'''
CollectionReference<CodeGeneration> codeGenerationCollection(
    [String path = 'foo-path']) {
  return FirebaseFirestore.instance
      .collection(path)
      .withConverter<CodeGeneration>(
          fromFirestore: (snapshot, _) =>
              _$CodeGenerationFromJson(snapshot.data()!),
          toFirestore: (instance, _) => instance.toJson());
}

DocumentReference<CodeGeneration> codeGenerationDoc(
    {String path = 'foo-path', required String docId}) {
  return FirebaseFirestore.instance
      .doc('$path/$docId')
      .withConverter<CodeGeneration>(
          fromFirestore: (snapshot, _) =>
              _$CodeGenerationFromJson(snapshot.data()!),
          toFirestore: (instance, _) => instance.toJson());
}
''')
@FirestoreConverter(defaultPath: 'foo-path')
class CodeGeneration {
  String a;
  CodeGeneration({required this.a});
  factory CodeGeneration.fromJson(Map<String, dynamic> json) =>
      CodeGeneration(a: json['a'].toString());
}
