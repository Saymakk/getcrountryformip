import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ip_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  dynamic country_ip;
  dynamic ip;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(ip.toString())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
          final ipv4json = await Ipify.ipv64(format: Format.JSON);
          print(jsonDecode(ipv4json)['ip']);
          setState(() {
            country_ip = jsonDecode(ipv4json)['ip'];
          });
          get_ip(country_ip);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> get_ip(dynamic country_ip) async {
    final response =
        await http.get(Uri.parse('http://ip-api.com/json/$country_ip'));

    print(response.body);
    if (response.statusCode == 200) {
      ip = GetIpCountry.fromJson(json.decode(response.body));
      print(ip.country);
      return ip;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
