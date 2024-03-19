import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  static const String _apikey = String.fromEnvironment('GEMINI_API_KEY');
  final FocusNode _focusNode = FocusNode();

  late final GenerativeModel _model;
  late final ChatSession _session;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(apiKey: _apikey, model: "gemini-pro");
    _session = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Gemini'),
        backgroundColor: Colors.cyanAccent[700],
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: Container(
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(20.10),
                  child: ListView.builder(
                    itemBuilder: (BuildContext c, int i) {
                      final content = _session.history.toList()[i];
                      final text = content.parts.whereType<TextPart>().map((t) => t.text).join();

                      return Row(mainAxisAlignment: i % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
                        Container(
                            decoration: BoxDecoration(
                              color: i % 2 == 0 ? Colors.grey[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: MarkdownBody(
                              data: text,
                            ))
                      ]);
                    },
                    itemCount: _session.history.length,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: _focusNode,
              onSubmitted: (msg) => sendMessage(msg),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your prompt here',
              ),
            ),
          )
        ],
      )),
    ));
  }

  void sendMessage(String msg) async {
    final prompt = Content.text(msg);
    await _session.sendMessage(prompt);
    setState(() {});
    _focusNode.requestFocus();
  }
}
