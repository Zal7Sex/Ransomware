import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playHackedSound() async {
    try {
      await _player.setVolume(1.0);
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('hacked.mp3'));
    } catch (e) {
      print('Audio error: $e');
      // Fallback to backup method
      await _playFallbackAudio();
    }
  }
  
  static Future<void> _playFallbackAudio() async {
    try {
      // Alternative audio method
      await _player.stop();
      await _player.play(AssetSource('hacked.mp3'));
    } catch (e) {
      print('Fallback audio also failed: $e');
    }
  }
  
  static Future<void> stopAudio() async {
    await _player.stop();
  }
  
  static Future<void> pauseAudio() async {
    await _player.pause();
  }
}
