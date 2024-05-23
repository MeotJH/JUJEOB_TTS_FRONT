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
  void speak({required String voice}) async {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:5000',
    ));
    final response = await dio.get('/api/v1/tts', queryParameters: {
      'voice': voice,
    });

    if (response.statusCode != 200) {
      await flutterTts.speak(voice);
      return;
    }

    final voiceBinary = response.data['data']['voice'];
    final voiceUrl = 'data:audio/wav;base64,$voiceBinary';

    final player = AudioPlayer();
    await player.play(UrlSource(voiceUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centered Card Example'),
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
                    labelText: 'Enter Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: voiceInputController,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => speak(voice: voiceInputController.text),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
