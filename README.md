![Build](https://github.com/Aurangseb/firestore_converter/workflows/Build/badge.svg)
[![pub package](https://img.shields.io/pub/v/firestore_converter.svg)](https://pub.dartlang.org/packages/firestore_converter)

This packages provides you with a new annotation `@FirestoreConverter(defaultPath: 'someDataPath')` to easily generate Firestore [with_converter] implementations
in order to reduce boilerplate code for data models.

It is best used in conjunction with other annotations like [freezed] or [json_serializable],
but it is not a requirement.

# Reduce boilerplate code

Before:

```dart
part 'example.freezed.dart';
part 'example.g.dart';

@freezed
class Example<T> with _$Example<T> {
  factory Example(int a) = _Example;
  factory Example.fromJson(Map<String, Object?> json) => _$ExampleFromJson(json);
}

CollectionReference<Example> exampleCollection(
    [String path = 'examples']) {
  return FirebaseFirestore.instance
      .collection(path)
      .withConverter<Example>(
      fromFirestore: (snapshot, _) =>
          Example.fromJson(snapshot.data()!),
      toFirestore: (instance, _) => instance.toJson());
}

DocumentReference<Example> exampleDoc(
    {String path = 'examples', required String docId}) {
  return FirebaseFirestore.instance
      .doc('$path/$docId')
      .withConverter<Example>(
      fromFirestore: (snapshot, _) =>
          Example.fromJson(snapshot.data()!),
      toFirestore: (instance, _) => instance.toJson());
}
```

After:
```dart
part 'example.firestore_converter.dart';
part 'example.freezed.dart';
part 'example.g.dart';

@freezed
@FirestoreConverter(defaultPath: 'examples')
class Example<T> with _$Example<T> {
  factory Example(int a) = _Example;
  factory Example.fromJson(Map<String, Object?> json) => _$ExampleFromJson(json);
}
```

# Installation

You will need to install [build_runner] in order to run the code generation. Install
[firestore_converter_generator] as dev dependency. The package [firestore_converter] 
needs to be added as regular dependency for enabling the annotation:

```console
flutter pub add dev:build_runner
flutter pub add dev:firestore_converter_generator
flutter pub add firestore_converter
```

# Migration for versions before 1.0.8

If you have been using a version of [firestore_converter] before 1.0.8, 
please follow the following steps:  

Due to some refactoring of the early version, the package [firestore_converter_annotation]
became obsolete, and the annotation is now in [firestore_converter].  

```console
flutter pub remove firestore_converter_annotation
flutter pub remove firestore_converter
flutter pub add dev:build_runner
flutter pub add dev:firestore_converter_generator
flutter pub add firestore_converter
```

In your source code, replace 

`import 'package:firestore_converter_annotation/firestore_converter_annotation.dart;'`

with 

`import 'package:firestore_converter/firestore_converter.dart';`

# Usage

Annotate a data class with `@FirestoreConverter(defaultPath: 'someDataPathInFirestore')` to generate two
helper functions:

* `${modelClassName}Collection`
* `${modelClassName}Doc`

Please note that this will be functions, not members since there is currently no way to add
static functions via code generation to the model class. The initial letter of the model
name will be converted to lowercase, to conform with the dart function naming conventions.

# Implement fromJson and toJson

Since [firestore_converter] relies on `fromJson` and `toJson` to be present in the annotated model class,
you should probably also add either [freezed], [json_serializable] or some other annotation that will
provide you with a convenient implementation of those two functions.

You can also implement them manually, although that would probably defeat the reason of using code
generation in the first place.

# Things to note

* JSON conversion with fromJson and toJson must be enabled / implemented.

* Uses the given path as default argument for collection and doc.

* Does not support default settings from build.yaml since path settings are individual per model class.

# Example using [firestore_converter] with [freezed]

Define your model class, e.g. example.dart:

```dart
part 'example.firestore_converter.dart';
part 'example.freezed.dart';
part 'example.g.dart';

@freezed
@FirestoreConverter(defaultPath: 'examples')
class Example<T> with _$Example<T> {
  factory Example(int a) = _Example;
  factory Example.fromJson(Map<String, Object?> json) => _$ExampleFromJson(json);
}
```

Run the code generation to generate `example.firestore_converter.dart`:
```console
flutter pub run build_runner build --delete-conflicting-outputs 
```


Start using it:
```dart

// Now you can easily create fully typed CollectionReferences,  DocumentReferences,
// or SnapShot objects from Firebase:
CollectionReference<Example> col1 = exampleCollection().orderBy('date', descending: true); // defaults to annotated path 'examples'
CollectionReference<Example> col2 = exampleCollection('some_other_path').orderBy('a', descending: true);
DocumentReference<Example> doc = exampleDoc(docId: 'exampleId'); // defaults to annotated path 'examples'
DocumentReference<Example> doc = exampleDoc(path: 'some_other_path', docId: 'exampleId');

// retrieve some document data
var myDoc = exampleDoc(path: 'some_other_path', docId: 'exampleId').get();
// Access typed members directly from the snapshot
debugPrint(myDoc.data().a);
```

# References

Read the Firebase documentation about withConverter here:

https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/DocumentReference/withConverter.html

https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html


[freezed]: https://pub.dev/packages/freezed
[json_serializable]: https://pub.dev/packages/json_serializable
[with_converter]: https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html
[build_runner]: https://pub.dev/packages/build_runner
[firestore_converter]: https://pub.dev/packages/firestore_converter
[firestore_converter_generator]: https://pub.dev/packages/firestore_converter_generator
[firestore_converter_annotation]: https://pub.dev/packages/firestore_converter_annotation
