import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:audio_session/audio_session.dart';

class AudioUtil {
  static final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  static final ja.AudioPlayer _justAudioPlayer = ja.AudioPlayer();
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
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ap.ReleaseMode.loop);
      await _audioPlayer.play(ap.AssetSource('hacked.mp3'));
    } catch (e) {
      print('AudioPlayers error: $e, trying JustAudio...');
      try {
        await _justAudioPlayer.setLoopMode(ja.LoopMode.all);
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
