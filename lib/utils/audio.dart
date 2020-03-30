import 'package:audioplayers/audio_cache.dart';

class Audio {
  static void success() {
    AudioCache player = AudioCache();
    player.play('success.mp3');
  }

  static void fail() {
    AudioCache player = AudioCache();
    player.play('fail.mp3');
  }
}
