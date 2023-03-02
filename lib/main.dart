import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ip_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    decodeIP();
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  dynamic country_ip;
  dynamic ip;
  String country = '';
  String user_data = 'Here will be user data';
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work with Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(country != 'United States' || country != 'India' ? 'Show WEBVIEW' : 'Show app'),
            Text(
              country_ip == null ? 'Awaiting IP' : country_ip.toString(),
            ),
            Text(
              ip != null ? country : 'Awaiting country',
            ),
            // TextButton(
            //   onPressed: () async {
            //     try {
            //       final credential = await FirebaseAuth.instance
            //           .createUserWithEmailAndPassword(
            //         email: 'email@email.com',
            //         password: 'password',
            //       );
            //       print('user created');
            //       print(credential.user!.uid);
            //     } on FirebaseAuthException catch (e) {
            //       if (e.code == 'weak-password') {
            //         print('The password provided is too weak.');
            //       } else if (e.code == 'email-already-in-use') {
            //         print('The account already exists for that email.');
            //       }
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            //   child: Text('Add user'),
            // ),
//             TextButton(
//               onPressed: () async {
// // Create a new user with a first and last name
//                 final user = <String, dynamic>{
//                   "first": "Ada",
//                   "last": "Lovelace",
//                   "born": 1815
//                 };
//
//                 db.collection("users").add(user).then((DocumentReference doc) =>
//                     print('DocumentSnapshot added with ID: ${doc.id}'));
//               },
//               child: Text('Add data'),
//             ),
//             TextButton(
//               onPressed: () async {
//
//               },
//               child: Text('Read data'),
//             ),
            Text(user_data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> decodeIP() async {
    final ipv4json = await Ipify.ipv64(format: Format.JSON);
    setState(() {
      country_ip = jsonDecode(ipv4json)['ip'];
    });
    print(country_ip);
    await get_ip(country_ip);
    return country_ip;
  }

  Future<void> get_ip(dynamic country_ip) async {
    final response =
        await http.get(Uri.parse('http://ip-api.com/json/$country_ip'));

    print(response.body);
    if (response.statusCode == 200) {
      ip = GetIpCountry.fromJson(json.decode(response.body));
      print(ip.country);
      setState(() {
        country = ip.country;
      });
      return ip;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> getUserData() async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        setState(() {
          user_data =
              '${doc.data()['first']} ${doc.data()['last']} was born at ${doc.data()['born']}';
        });
      }
    });
  }
}
