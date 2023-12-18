export 'package:meta/meta.dart';

/// {@template firestore_converter_annotation.firestore_converter}
/// Flags a class as needing to be processed by FirestoreConverter and allows passing options.
/// {@endtemplate}
class FirestoreConverter {
  /// {@macro firestore_converter_annotation.firestore_converter}
  const FirestoreConverter({
    this.defaultPath,
  });

  /// Enable generation of Firebase Helper Functions ${firestore_converterClassName}Collection and ${firestore_converterClassName}Doc
  /// with converter.
  ///
  /// Serves as shortcut to provide you with withConverter implementations for docs and collections
  ///
  /// https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/DocumentReference/withConverter.html
  ///
  /// https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html
  ///
  ///
  /// Uses the given path as default argument for collection and doc.
  ///
  /// JSON conversion with fromJson and toJson must be enabled.
  ///
  /// Does not support default settings from build.yaml since path settings are individual per object.
  ///
  /// ```dart
  /// @FirestoreConverter(firebasePath: 'examples')
  /// class Example<T> with _$Example<T> {
  ///   factory Example(int a) = _Example;
  ///
  ///   factory Example.fromJson(Map<String, Object?> json) => _$ExampleFromJson(json);
  ///
  /// }
  ///
  /// // Use to easily dump or retrieve fully typed objects from Firebase
  ///
  /// CollectionReference<Example> col1 = exampleCollection().orderBy('date', descending: true); // defaults to annotated path 'examples'
  /// CollectionReference<Example> col2 = exampleCollection('some_other_path').orderBy('a', descending: true);
  /// DocumentReference<Example> doc = exampleDoc(docId: 'exampleId'); // defaults to annotated path 'examples'
  /// DocumentReference<Example> doc = exampleDoc(path: 'some_other_path', docId: 'exampleId');
  /// ```
  ///
  ///
  // @JsonKey(defaultValue: false)
  final String? defaultPath;
}

/// Enables generation of Firestore withConverter implementations
///
/// This will consider all properties of the object as immutable.
const firestore_converter = FirestoreConverter();
