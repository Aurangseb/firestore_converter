[English](https://github.com/Aurangseb/firestore_converterWithFbConverter/blob/master/packages/firestore_converter/README.md) 

![Build](https://github.com/Aurangseb/firestore_converterWithFbConverter/workflows/Build/badge.svg)
[![pub package](https://img.shields.io/pub/v/firestore_converter.svg)](https://pub.dartlang.org/packages/firestore_converter)

This packages provides you with a new annotation `@FirestoreConverter(defaultPath: 'someDataPath')` to easily generate Firestore [with_converter] implementations 
in order to reduce boilerplate code for data models.

It is best used in conjunction with other annotations like [freezed] or [json_serializable], 
but it is not a requirement.

# Installation

To use [firebase_converter], you will need your typical [build_runner]/code-generator setup.\
First, install [build_runner] and [firebase_converter] by adding them to your `pubspec.yaml` file:

```console
flutter pub add firebase_converter_annotation
flutter pub add dev:build_runner
flutter pub add dev:firebase_converter
```

Since [firebase_converter] relies on `instance.toJson` to be present in the annotated model class, 
you should probably also add either [freezed], [json_serializable] or some other annotation that will
provide you with a convenient implementation of `toJson`. 

# Usage

Annotate a data class with `@FirestoreConverter(defaultPath: 'someDataPathInFirestore')` to generate two 
helper functions:

* `${modelClassName}Collection` 
* `${modelClassName}Doc` 

Please note that this will be functions, not members since there is currently no way to add 
static functions via code generation to the model class. The initial letter of the model 
name will be converted to lowercase, to conform with the dart function naming conventions. 

# Things to note

* JSON conversion with fromJson and toJson must be enabled / implemented.

* Uses the given path as default argument for collection and doc.

* Does not support default settings from build.yaml since path settings are individual per model class.

# Example using [firebase_converter] with [freezed]

Define your model class, e.g. example.dart:

```dart
part 'example.firebase_converter.dart';
part 'example.freezed.dart';
part 'example.g.dart';

@freezed
@FirestoreConverter(defaultPath: 'examples')
class Example<T> with _$Example<T> {
  factory Example(int a) = _Example;
  factory Example.fromJson(Map<String, Object?> json) => _$ExampleFromJson(json);
}
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
print(myDoc.data().a);
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
[firestore_converter_annotation]: https://pub.dev/packages/firestore_converter_annotation
