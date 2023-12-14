import 'dart:async';

import 'package:firestore_converter/builder.dart';
import 'package:firestore_converter_annotation/firestore_converter_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  final reader =
      await initializeLibraryReaderForDirectory('test', 'source_gen_src.dart');

  initializeBuildLogTracking();

  testAnnotatedElements<FirestoreConverter>(
    reader,
    FirestoreConverterGenerator(),
  );
}
