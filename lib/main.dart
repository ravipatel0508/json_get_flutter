import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  final List data = await getJsonData();
  runApp(MyApp(data));
}

class MyApp extends StatefulWidget {
  final List data;
  MyApp(this.data);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Get',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Assessment Task'),
        ),
        body: FutureBuilder(
          future: getJsonData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.data[index]['state']),
                    subtitle: Text('Confirmed cases: '+widget.data[index]['confirmed']),
                  );
                },
              );
            } else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Future getJsonData() async {
  final String url = "https://api.covid19india.org/data.json";
  final response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

  return jsonDecode(response.body)['statewise'];
}
