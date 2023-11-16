import 'package:flutter/material.dart';
import 'package:muzic/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request storage permission
  var status = await OnAudioQuery().checkAndRequest();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  if (status) {
    runApp(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData().copyWith(
            useMaterial3: true,
            navigationBarTheme: const NavigationBarThemeData().copyWith(
              labelTextStyle: const MaterialStatePropertyAll(
                TextStyle(color: Colors.white),
              ),
            ),
          ),
          title: 'Music Player',
          home: const Tabs(),
        ),
      ),
    );
  }
}
