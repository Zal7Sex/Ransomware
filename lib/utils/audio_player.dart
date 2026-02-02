import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

class AudioUtil {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioPlayer _justAudioPlayer = AudioPlayer();
  static bool _useJustAudio = false;

  static Future<void> playHackedSound() async {
    try {
      if (!_useJustAudio) {
        // Try audioplayers first
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource('hacked.mp3'));
      } else {
        // Fallback to just_audio
        await _justAudioPlayer.setLoopMode(LoopMode.all);
        await _justAudioPlayer.setVolume(1.0);
        await _justAudioPlayer.setAsset('assets/hacked.mp3');
        await _justAudioPlayer.play();
      }
    } catch (e) {
      print('Audio error: $e, switching to fallback');
      _useJustAudio = true;
      await _playFallbackAudio();
    }
  }

  static Future<void> _playFallbackAudio() async {
    try {
      await _justAudioPlayer.setLoopMode(LoopMode.all);
      await _justAudioPlayer.setAsset('assets/hacked.mp3');
      await _justAudioPlayer.play();
    } catch (e) {
      print('Fallback audio failed: $e');
    }
  }

  static Future<void> stopAudio() async {
    await _audioPlayer.stop();
    await _justAudioPlayer.stop();
  }

  static Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    await _justAudioPlayer.pause();
  }

  static Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _justAudioPlayer.dispose();
  }
}
