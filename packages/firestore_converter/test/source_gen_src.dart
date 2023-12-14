// ignore_for_file: avoid_unused_constructor_parameters, unused_element
import 'package:firestore_converter_annotation/firestore_converter_annotation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('@FirestoreConverter should only be applied on classes. Failing element: foo')
@FirestoreConverter(defaultPath: 'test')
Object? foo;

@ShouldGenerate(
  r'''
CollectionReference<Foo> fooCollection([String path = 'foo-path']) {
  return FirebaseFirestore.instance.collection(path).withConverter<Foo>(
      fromFirestore: (snapshot, _) => _$FooFromJson(snapshot.data()!),
      toFirestore: (instance, _) => instance.toJson());
}

DocumentReference<Foo> fooDoc(
    {String path = 'foo-path', required String docId}) {
  return FirebaseFirestore.instance.doc('$path/$docId').withConverter<Foo>(
      fromFirestore: (snapshot, _) => _$FooFromJson(snapshot.data()!),
      toFirestore: (instance, _) => instance.toJson());
}
''')
@FirestoreConverter(defaultPath: 'foo-path')
class Foo {
  String a;
  Foo({required this.a});
  factory Foo.fromJson(Map<String, dynamic> json) => Foo(a: json['a'].toString());
}

