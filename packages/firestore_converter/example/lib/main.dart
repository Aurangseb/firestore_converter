// this example requires the firestore emulator to be up and running!
// run with:
// firebase emulators:start --project demo-example

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:firestore_converter_annotation/firestore_converter_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main.firestore_converter.dart';

part 'main.freezed.dart';

part 'main.g.dart';

var faker = Faker();

@FirestoreConverter(defaultPath: 'users')
@freezed
class User with _$User {
  factory User({
    required String name,
    required String email,
    required int salary,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // this example requires the firestore emulator to be up and running!
  // run with:
  // firebase emulators:start --project demo-example

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'not-required-for-emulator',
      appId: 'not-required-for-emulator',
      messagingSenderId: 'not-required-for-emulator',
      projectId: 'demo-example',
    ),
  );

  try {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  } catch (e) {
    print(e);
    rethrow;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              key: const Key('addButton'),
              onPressed: () async {
                var newUser = User(
                  email: faker.internet.email(),
                  name: faker.person.name(),
                  salary: faker.randomGenerator.integer(100000),
                );
                try {
                  await userCollection().add(newUser);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('New user added'),
                    key: Key('snackbar'),
                  ));
                } catch (e) {
                  debugPrint(e.toString());
                  rethrow;
                }
              },
              child: const Icon(Icons.add),
            );
          }
        ),
        body: FirestoreListView<User>(
          query: userCollection().orderBy('name'),
          itemBuilder: (context, snapshot) => Card(
            child: ListTile(
              key: (Key(snapshot.data().name)),
              title: Text(snapshot.data().name),
              subtitle: Row(
                children: [
                  Text(snapshot.data().email),
                  const Expanded(child: Center()),
                  Text(snapshot.data().salary.toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
