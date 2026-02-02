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
  int _currentStep = 0;
  bool _isProcessing = false;
  
  final List<Map<String, dynamic>> _permissions = [
    {
      'name': 'System Alert Window',
      'permission': Permission.systemAlertWindow,
      'description': 'Display over other apps',
    },
    {
      'name': 'Schedule Exact Alarm',
      'permission': Permission.scheduleExactAlarm,
      'description': 'Run background tasks',
    },
    {
      'name': 'Notification',
      'permission': Permission.notification,
      'description': 'Show notifications',
    },
  ];

  Future<void> _grantPermission() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    if (_currentStep < _permissions.length) {
      final permission = _permissions[_currentStep]['permission'] as Permission;
      
      // Request permission
      final status = await permission.request();
      
      if (status.isGranted || status.isLimited) {
        setState(() => _currentStep++);
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Auto proceed if granted
        if (_currentStep < _permissions.length) {
          _grantPermission();
        }
      } else {
        // Kalau ditolak, buka settings
        await openAppSettings();
      }
    } else {
      // All permissions granted - activate lock
      await _activateLock();
    }
    
    setState(() => _isProcessing = false);
  }

  Future<void> _activateLock() async {
    DeviceLocker.lockDevice();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LockScreen()),
    );
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
                'For security enhancement, please grant the following permissions:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              
              // Permission Steps
              ..._permissions.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> perm = entry.value;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: idx < _currentStep
                        ? const Color(0xFF3B82F6).withOpacity(0.3)
                        : idx == _currentStep
                            ? const Color(0xFF3B82F6).withOpacity(0.2)
                            : const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: idx < _currentStep
                          ? Colors.green
                          : idx == _currentStep
                              ? Colors.blueAccent
                              : Colors.blueGrey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: idx < _currentStep
                            ? Colors.green
                            : idx == _currentStep
                                ? Colors.blueAccent
                                : Colors.blueGrey,
                        child: Icon(
                          idx < _currentStep
                              ? Icons.check
                              : idx == _currentStep
                                  ? Icons.pending
                                  : Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              perm['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'ShareTechMono',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              perm['description'],
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 40),
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
                      : Text(
                          _currentStep < _permissions.length
                              ? 'GRANT PERMISSION'
                              : 'ACTIVATE LOCK SYSTEM',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ShareTechMono',
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
