import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _scanResult;

  void _startQRScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _scanResult = result;
      });
    } else {
      setState(() {
        _scanResult = 'Scan gagal atau tidak valid.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_scanResult != null)
              Text(
                'Hasil Scan: $_scanResult',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Belum ada hasil scan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startQRScanner,
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
