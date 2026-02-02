import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioUtil {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioPlayer _justAudioPlayer = AudioPlayer();
  static bool _initialized = false;

  static Future<void> _initializeAudio() async {
    if (!_initialized) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      _initialized = true;
    }
  }

  static Future<void> playHackedSound() async {
    await _initializeAudio();
    
    try {
      // Coba audioplayers dulu
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('hacked.mp3'));
    } catch (e) {
      print('AudioPlayers error: $e, trying JustAudio...');
      // Fallback ke JustAudio
      try {
        await _justAudioPlayer.setLoopMode(LoopMode.all);
        await _justAudioPlayer.setVolume(1.0);
        await _justAudioPlayer.setAsset('assets/hacked.mp3');
        await _justAudioPlayer.play();
      } catch (e2) {
        print('JustAudio also failed: $e2');
      }
    }
  }

  static Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      await _justAudioPlayer.stop();
    } catch (e) {
      print('Stop audio error: $e');
    }
  }

  static Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _justAudioPlayer.dispose();
  }
}
