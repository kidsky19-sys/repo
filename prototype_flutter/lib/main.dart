import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindTalk Prototype',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool autoSend = false;

  String modifyText(String src) {
    if (src.trim().isEmpty) return '';
    var out = src.replaceAllMapped(RegExp(r"바보|멍청이|꺼져|닥쳐"), (m) => '***');
    if (!out.endsWith('요') && !out.endsWith('습니다')) {
      out = out + ' 부탁드립니다.';
    }
    return out;
  }

  Map<String, dynamic> analyze(String text) {
    var anger = RegExp(r"!|화|분노|꺼져|닥쳐").hasMatch(text) ? '높음' : '낮음';
    var intent = '요청';
    if (text.contains('미안')) intent = '사과';
    if (text.contains('어떻게') || text.contains('확인')) intent = '확인';
    return {
      'current': anger == '높음' ? '분노' : '서운함',
      'strength': anger,
      'intent': intent,
    };
  }

  void onPolish() {
    final src = _controller.text;
    final mod = modifyText(src);
    final analysis = analyze(src);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(original: src, modified: mod, analysis: analysis),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('상대에게 보낼 말을 적어주세요.'), Text('거친 표현도 부드럽게 바꿔드립니다.', style: TextStyle(fontSize:12))],
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '여기에 메시지를 입력하세요',
                ),
              ),
            ),
            SizedBox(height:12),
            ElevatedButton(onPressed: onPolish, child: Text('문장 다듬기')),
            SwitchListTile(
              value: autoSend,
              onChanged: (v) => setState(() => autoSend = v),
              title: Text('자동 전송 사용'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String original;
  final String modified;
  final Map<String, dynamic> analysis;
  ResultScreen({required this.original, required this.modified, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('수정된 문장')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(modified, style: TextStyle(fontSize:18)),
              ),
            ),
            SizedBox(height:8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('현재 감정: ${analysis['current']}'),
                      Text('강도: ${analysis['strength']}'),
                      Text('대화 의도: ${analysis['intent']}'),
                    ]),
                    Wrap(spacing:6, children: [
                      Chip(label: Text('분노')),
                      Chip(label: Text('서운함')),
                      Chip(label: Text('답답함')),
                    ])
                  ],
                ),
              ),
            ),
            SizedBox(height:8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('비난 표현을 줄이고 요청형 문장으로 바꿨습니다.'),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmScreen(finalText: modified)));
                }, child: Text('이대로 보내기'))),
                SizedBox(width:8),
                Expanded(child: OutlinedButton(onPressed: (){ Navigator.pop(context); }, child: Text('다시 수정하기'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmScreen extends StatefulWidget {
  final String finalText;
  ConfirmScreen({required this.finalText});
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController _toController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('보내기 전 확인')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _toController, decoration: InputDecoration(labelText: '받는 사람 이름')),
            SizedBox(height:12),
            Card(child: Padding(padding: const EdgeInsets.all(12.0), child: Text(widget.finalText))),
            Spacer(),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('전송됨 — (시제품)')));
              }, child: Text('이대로 보내기'))),
              SizedBox(width:8),
              Expanded(child: OutlinedButton(onPressed: (){ Navigator.pop(context); }, child: Text('수정 돌아가기'))),
            ])
          ],
        ),
      ),
    );
  }
}
