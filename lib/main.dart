import 'dart:convert';

import 'package:carrier_info/carrier_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/web_view.dart';
import 'package:untitled1/web_view_pro.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
    getLinksData();
    // TODO: implement initState
    super.initState();
  }

  dynamic country_ip;
  dynamic ip;
  String country = '';
  String user_data = 'Here will be user data';
  String links_data = '';
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
            Text(country != 'United States' || country != 'India'
                ? 'Show WEBVIEW'
                : 'Show app'),
            Text(
              country_ip == null ? 'Awaiting IP' : country_ip.toString(),
            ),
            Text(
              ip != null ? country : 'Awaiting country',
            ),
            Text(user_data),
          ],
        ),
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
      if (ip.country != 'United States' && ip.country != 'India' && links_data != '') {
        Get.offAll(() => WebViewPro(), arguments: links_data);
      }
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
  Future<void> getLinksData() async {
    await db.collection("links").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        setState(() {
          links_data =
          '${doc.data()['link']}';
        });
        print(links_data);
      }
    });
  }
}
