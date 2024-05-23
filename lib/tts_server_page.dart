import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSServerPage extends StatefulWidget {
  const TTSServerPage({super.key});

  @override
  State<TTSServerPage> createState() => _TTSTestPageState();
}

class _TTSTestPageState extends State<TTSServerPage> {
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController voiceInputController = TextEditingController();
  String voiceText = '';
  void speak({required String name}) async {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:5000',
    ));
    final response = await dio.get('/api/v1/tts', queryParameters: {
      'name': name,
    });

    if (response.statusCode != 200) {
      await flutterTts.speak(name);
      return;
    }

    final voiceBinary = response.data['data']['voice'];
    setState(() {
      voiceText = response.data['data']['text'];
    });
    final voiceUrl = 'data:audio/wav;base64,$voiceBinary';

    final player = AudioPlayer();
    await player.play(UrlSource(voiceUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주접 TTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: '이름을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: voiceInputController,
                ),
                const SizedBox(height: 16),
                Text(voiceText),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => speak(name: voiceInputController.text),
                  child: const Text('주접떨기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
