import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/audio_player.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _showError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playHackedAudio();
    // Enable full immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _playHackedAudio() async {
    if (!_isPlaying) {
      _isPlaying = true;
      await AudioUtil.playHackedSound();
    }
  }

  void _checkPin() {
    if (_pinController.text == '969') {
      AudioUtil.stopAudio();
      SystemNavigator.pop(); // Exit app
    } else {
      setState(() => _showError = true);
      _pinController.clear();
      _playHackedAudio(); // Restart audio on wrong pin
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _playHackedAudio(); // Play audio if user tries to back
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            // Play audio on any tap
            if (!_isPlaying) {
              _playHackedAudio();
            }
          },
          child: Stack(
            children: [
              // Animated Background
              AnimatedContainer(
                duration: const Duration(seconds: 5),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue[900]!,
                      Colors.black,
                    ],
                    stops: const [0.1, 1.0],
                    center: Alignment.topLeft,
                  ),
                ),
              ),
              
              // Glitch Effect Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.blueAccent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  maxWidth: 350,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lock Icon with Animation
                      const Icon(
                        Icons.lock_person,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 20),
                      
                      // Title with Glitch Effect
                      const Text(
                        '⚠ DEVICE SECURED ⚠',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ShareTechMono',
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pegasus Trasher v1.0 | Security Active',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // PIN Input with Cyber Style
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _showError ? Colors.red : Colors.blueAccent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_showError ? Colors.red : Colors.blueAccent)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
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
                          decoration: const InputDecoration(
                            hintText: '_ _ _',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey,
                              letterSpacing: 15,
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
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
                      ),
                      
                      // Error Message
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ACCESS DENIED - SYSTEM LOCKED',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 14,
                                  fontFamily: 'ShareTechMono',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 30),
                      const Text(
                        'ENTER UNLOCK PIN: 969',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      // Hidden Unlock Button
                      const SizedBox(height: 40),
                      Opacity(
                        opacity: 0.05,
                        child: MaterialButton(
                          onPressed: _checkPin,
                          color: Colors.blueAccent,
                          minWidth: double.infinity,
                          height: 50,
                          child: const Text(
                            'UNLOCK DEVICE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ShareTechMono',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Warning
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Text(
                      'SYSTEM STATUS: FULL LOCK ACTIVE',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                        fontFamily: 'ShareTechMono',
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '⚠ Do not attempt to force close or reboot device ⚠',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontFamily: 'ShareTechMono',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Network Scan Animation
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SECURE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontFamily: 'ShareTechMono',
                        ),
                      ),
                    ],
                  ),
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
    _pinController.dispose();
    super.dispose();
  }
}
