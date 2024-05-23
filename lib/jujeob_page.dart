import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class JujeobPage extends StatefulWidget {
  const JujeobPage({super.key});

  @override
  State<JujeobPage> createState() => _JujeobPAgeState();
}

class _JujeobPAgeState extends State<JujeobPage> {
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController voiceInputController = TextEditingController();
  String name = '';
  String voiceText = '';
  void speak({required String name}) async {
    final dio = Dio(BaseOptions(
      baseUrl:
          'https://oc2hyphde0.execute-api.ap-northeast-2.amazonaws.com/dev',
    ));
    final response = await dio.get('/api/v1/tts', queryParameters: {
      'name': name,
    });

    if (response.statusCode != 200) {
      await flutterTts.speak(name);
      return;
    }
    setState(() {
      voiceText = response.data['data']['text'];
    });
    await flutterTts.speak(voiceText);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final arguments = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        name = arguments['name'];
      });
    });
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
        child: Container(
          width: double.infinity,
          height: 400,
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    voiceText,
                  ),
                  const SizedBox(height: 70),
                  SizedBox(
                    width: double.infinity, // Increase the width
                    height: 100, // Increase the height
                    child: ElevatedButton(
                      onPressed: () => speak(name: name),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Increase the border radius
                        ),
                      ),
                      child: const Text('주접듣기'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
