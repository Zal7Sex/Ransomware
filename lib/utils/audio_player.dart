import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static Future<void> playHackedSound(AudioPlayer player) async {
    try {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource('hacked.mp3'));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}
