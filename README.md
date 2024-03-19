# Flutter 설치

- [Flutter 설치](https://flutter.dev/docs/get-started/install)

## Google Gemini API Key 발급

1. [Google Gemini API](https://aistudio.google.com/app/apikey)에 접속하여 API Key를 발급받습니다.

## 프로젝트 생성

- flutter 프로젝트 생성

```bash
flutter create gemini_chat
```

### Google Gemini AI 패키지 추가

flutter 명령을 통해 google_generative_ai 패키지 추가

```bash
cd gemini_chat
flutter pub add google_generative_ai
```

### main.dart 수정

- YOUR API KEY 부분을 발급받은 API Key로 변경합니다.
- lib/main.dart

```dart
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
```

### 실행방법

```bash
flutter run
```

## 개선

### API key를 외부에서 주입하기

- lib/main.dart

```dart
static const String _apikey = String.fromEnvironment('API_KEY');
```

### Gemini Model -> ChatSession 변경

- ChatSession을 멤버변수로 추가
- lib/main.dart

```dart
class _ChatAppState extends State<ChatApp> {
  late final ChatSession _session;
  ...

  @override
  void initState() {
    super.initState();
    ...
    _session = _model.startChat();
  }
  ...
}

```

### ChatSession을 사용하여 대화하기

- sendMessage 함수를 수정하여 ChatSession을 사용하도록 변경
- lib/main.dart

```dart
   void sendMessage(String msg) async {
    _response += "User:\t" + msg + "\n";

    final prompt = Content.text(msg);
    final response = await _session.sendMessage(prompt);
    setState(() {
      _response += "Gemini:\t" + response.text! + "\n";
    });
  }
```

## 꾸미기

- Markdown을 사용하여 대화 내용을 꾸밈

### markdown 설치

- flutter_markdown 패키지 추가

```bash
flutter pub add flutter_markdown
```


