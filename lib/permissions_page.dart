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

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.systemAlertWindow.status;
    if (status.isGranted) {
      // Langsung ke lock screen
      _activateLock();
    }
  }

  Future<void> _grantPermission() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    final status = await Permission.systemAlertWindow.request();
    
    if (status.isGranted || status.isLimited) {
      setState(() => _isGranted = true);
      await Future.delayed(const Duration(milliseconds: 500));
      _activateLock();
    } else {
      // Kalau ditolak, buka settings
      setState(() => _isProcessing = false);
      await openAppSettings();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: Center(
        child: Container(
          width: 400,
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
              const Icon(
                Icons.security,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'SYSTEM PERMISSION REQUIRED',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'ShareTechMono',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This app needs permission to display over other apps for security lock feature.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              
              // Permission Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isGranted
                      ? const Color(0xFF3B82F6).withOpacity(0.3)
                      : const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isGranted ? Colors.green : Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _isGranted ? Colors.green : Colors.blueAccent,
                      child: Icon(
                        _isGranted ? Icons.check : Icons.phonelink_lock,
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
                              fontFamily: 'ShareTechMono',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _isGranted 
                                ? '✓ Permission Granted'
                                : 'Required for lock screen overlay',
                            style: TextStyle(
                              color: _isGranted ? Colors.greenAccent : Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Grant Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing || _isGranted ? null : _grantPermission,
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isGranted ? Icons.check_circle : Icons.lock_open),
                            const SizedBox(width: 10),
                            Text(
                              _isGranted 
                                  ? 'ACTIVATING LOCK...'
                                  : 'GRANT PERMISSION',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ShareTechMono',
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Info text
              const Text(
                '⚠️ After granting permission, the lock screen will activate automatically',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
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
