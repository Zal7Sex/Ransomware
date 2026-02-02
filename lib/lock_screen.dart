import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'utils/audio_player.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playHackedAudio();
  }

  void _playHackedAudio() async {
    if (!_isPlaying) {
      _isPlaying = true;
      await AudioUtil.playHackedSound(_audioPlayer);
    }
  }

  void _checkPin() {
    if (_pinController.text == '969') {
      // Close app (simulate unlock)
      SystemNavigator.pop();
    } else {
      setState(() => _showError = true);
      _pinController.clear();
      _playHackedAudio(); // Play again on wrong pin
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Animated Background
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.blue[900]!,
                    Colors.black,
                  ],
                  stops: const [0.1, 1.0],
                ),
              ),
            ),
            
            Center(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock Icon
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      'DEVICE LOCKED',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ShareTechMono',
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pegasus Trasher Security System',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // PIN Input
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      maxLength: 3,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'ShareTechMono',
                        letterSpacing: 10,
                      ),
                      decoration: InputDecoration(
                        hintText: 'PIN',
                        hintStyle: const TextStyle(color: Colors.blueGrey),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: _showError ? Colors.red : Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 3) {
                          _checkPin();
                        }
                        if (_showError) {
                          setState(() => _showError = false);
                        }
                      },
                    ),
                    
                    // Error Message
                    if (_showError)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'WRONG PIN - ACCESS DENIED',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 14,
                            fontFamily: 'ShareTechMono',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 30),
                    const Text(
                      'Enter PIN: 969 to unlock',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                      ),
                    ),
                    
                    // Emergency Unlock Button (hidden)
                    const SizedBox(height: 40),
                    Opacity(
                      opacity: 0.1,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _checkPin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'UNLOCK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ShareTechMono',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Warning Text
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Text(
                '⚠ System Security Active - Do Not Attempt To Bypass ⚠',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontFamily: 'ShareTechMono',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
