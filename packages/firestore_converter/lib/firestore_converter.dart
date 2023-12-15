import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firestore_converter_annotation/firestore_converter_annotation.dart';
import 'package:source_gen/source_gen.dart';

Builder firestoreConverterGeneratorFactory(BuilderOptions options) =>
    PartBuilder([FirestoreConverterGenerator()], '.firestore_converter.dart');

class FirestoreConverterGenerator extends GeneratorForAnnotation<FirestoreConverter> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '@FirestoreConverter should only be applied on classes. Failing element: ${element.name}',
          element: element);
    }

    var path = annotation.read('defaultPath').stringValue;

    return '''
      ${_firebaseCollectionReference(dataPath: path, className: element.name)}
      ${_firebaseDocumentReference(dataPath: path, className: element.name)}
    ''';
  }

  String _firebaseCollectionReference({required String dataPath, required String className}) {
    return '''
      CollectionReference<$className> ${className[0].toLowerCase() + className.substring(1)}Collection([String path = '$dataPath']) {
        return FirebaseFirestore.instance.collection(path).withConverter<$className>(
            fromFirestore: (snapshot, _) => _\$${className}FromJson(snapshot.data()!),
            toFirestore: (instance, _) => instance.toJson());
      }
    ''';
  }

  String _firebaseDocumentReference({required String dataPath, required String className}) {
    return '''
      DocumentReference<$className> ${className[0].toLowerCase() + className.substring(1)}Doc({String path = '$dataPath', required String docId}) {
        return FirebaseFirestore.instance.doc('\$path/\$docId').withConverter<$className>(
            fromFirestore: (snapshot, _) => _\$${className}FromJson(snapshot.data()!),
            toFirestore: (instance, _) => instance.toJson());
      }
    ''';
  }
}
