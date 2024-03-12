import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        dialogBackgroundColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const MyDictionaryPage(),
    );
  }
}

class MyDictionaryPage extends StatefulWidget {
  const MyDictionaryPage({Key? key}) : super(key: key);

  @override
  _MyDictionaryPageState createState() => _MyDictionaryPageState();
}

class _MyDictionaryPageState extends State<MyDictionaryPage> {
  TextEditingController wordController = TextEditingController();
  String definition = "";
  String example = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: wordController,
                    decoration: InputDecoration(
                      labelText: 'Enter a word',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onSearchPressed,
                    child: Column(
                      children: [
                        const Text("Search"),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Set the color directly
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Meaning:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            Text(
                              definition.isNotEmpty ? definition : '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Example:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            Text(
                              example != null && example.isNotEmpty ? example : 'No Example Available',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSearchPressed() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      message: const Text("Dictionary"),
      title: const Text("Searching..."),
    );
    progressDialog.show();

    String word = wordController.text;
    var url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      definition = parsedJson[0]['meanings'][0]['definitions'][0]['definition'].toString();
      example = parsedJson[0]['meanings'][0]['definitions'][0]['example']?.toString() ?? '';
      setState(() {});
      log(definition);

      Fluttertoast.showToast(
        msg: "Found!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      definition = "No Available Data";
      example = "No Available Data";
      setState(() {});

      Fluttertoast.showToast(
        msg: "Not Found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    progressDialog.dismiss();
  }
}
