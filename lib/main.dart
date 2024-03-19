import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  State createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  static const String _apikey = 'YOUR API KEY';
  late final GenerativeModel _model;
  String _response = '';

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(apiKey: _apikey, model: "gemini-pro");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
          child: Column(
        children: [
          Expanded(child: Text(_response)),
          TextField(
            onSubmitted: (msg) => sendMessage(msg),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your prompt here',
            ),
          )
        ],
      )),
    ));
  }

  void sendMessage(String msg) async {
    final prompt = [Content.text(msg)];
    final response = await _model.generateContent(prompt);
    setState(() {
      _response = response.text!;
    });
  }
}
