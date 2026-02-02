import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
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
    _initializeLock();
  }

  void _initializeLock() async {
    // Enable immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Start audio
    await AudioUtil.playHackedSound();
    _isPlaying = true;
    
    // Vibrate on lock
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
  }

  void _checkPin() async {
    if (_pinController.text == '969') {
      // Correct PIN - unlock
      await AudioUtil.stopAudio();
      SystemNavigator.pop();
    } else {
      // Wrong PIN - effects
      setState(() => _showError = true);
      _pinController.clear();
      
      // Vibrate
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 500, 200, 500]);
      }
      
      // Restart audio
      await AudioUtil.stopAudio();
      await AudioUtil.playHackedSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Vibrate when trying to back
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 300);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Listener(
          onPointerDown: (_) {
            // Play audio on any touch
            if (!_isPlaying) {
              AudioUtil.playHackedSound();
              _isPlaying = true;
            }
          },
          child: _buildLockScreen(),
        ),
      ),
    );
  }

  Widget _buildLockScreen() {
    return Stack(
      children: [
        // Animated Blue Background
        AnimatedContainer(
          duration: const Duration(seconds: 5),
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF0A2463),
                Color(0xFF1E3A8A),
                Colors.black,
              ],
              stops: [0.1, 0.5, 1.0],
              center: Alignment.center,
              radius: 1.5,
            ),
          ),
        ),
        
        // Scan Lines Effect
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.blueAccent.withOpacity(0.03),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              maxWidth: 380,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Icon
                  const Column(
                    children: [
                      Icon(
                        Icons.security,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'PEGASUS TRASHER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ShareTechMono',
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'SECURITY LOCK ACTIVE',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Status Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'DEVICE LOCKED • SYSTEM SECURE',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'ShareTechMono',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // PIN Input Section
                  Column(
                    children: [
                      const Text(
                        'ENTER UNLOCK PIN',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontFamily: 'ShareTechMono',
                        ),
                      ),
                      const SizedBox(height: 10),
                      
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
                              color: (_showError 
                                  ? Colors.red 
                                  : Colors.blueAccent
                                ).withOpacity(0.3),
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
                            fontSize: 40,
                            color: Colors.white,
                            fontFamily: 'ShareTechMono',
                            letterSpacing: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: '• • •',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey,
                              letterSpacing: 20,
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(25),
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
                                Icons.close,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'INVALID PIN • ACCESS DENIED',
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
                        'UNLOCK PIN: 969',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Hidden Unlock Button (invisible but tappable)
                  GestureDetector(
                    onTap: _checkPin,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          ' ',
                          style: TextStyle(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  
                  // Footer Info
                  const SizedBox(height: 30),
                  const Divider(color: Colors.blueGrey, height: 1),
                  const SizedBox(height: 20),
                  const Text(
                    '⚠ SYSTEM PROTECTED BY PEGASUS TRASHER v1.0 ⚠',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 10,
                      fontFamily: 'ShareTechMono',
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'All unauthorized access attempts are logged',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Bottom System Info
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 3,
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
              const SizedBox(height: 10),
              const Text(
                '▸ SYSTEM LOCKED ▸ PRESS POWER BUTTON 3x FOR EMERGENCY',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 9,
                  fontFamily: 'ShareTechMono',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    AudioUtil.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
