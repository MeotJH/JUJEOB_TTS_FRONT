import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TTSTestPage extends StatefulWidget {
  const TTSTestPage({super.key});

  @override
  State<TTSTestPage> createState() => _TTSTestPageState();
}

class _TTSTestPageState extends State<TTSTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('TTS Test Page'),
            ElevatedButton(
              onPressed: () async {
                print('clicked');
                final dio = Dio(BaseOptions(
                  baseUrl: 'http://127.0.0.1:5000',
                ));
                final response = await dio.get('/api/v1/tts', queryParameters: {
                  'voice': '헤옹이 안녕하세요.',
                });
                final voiceBinary = response.data['data']['voice'];

                // Decode the base64 string received from the API
                final voiceBytes = base64Decode(voiceBinary);

                // Create a data URI from the byte array
                final voiceBase64 = base64Encode(voiceBytes);
                final voiceUrl = 'data:audio/wav;base64,$voiceBase64';

                // Play the audio
                final player = AudioPlayer();
                await player.play(UrlSource(voiceUrl));
              },
              child: const Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }
}
