import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart'; // Import file QRScannerScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner By Yudan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_scanResult != null) // Tampilkan hasil scan jika ada
              Text(
                'Hasil Scan: $_scanResult',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Belum ada hasil scan.',
                style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigasi ke QRScannerScreen dan tunggu hasil scan
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRScannerScreen()),
                );
                if (result != null && result is String) {
                  setState(() {
                    _scanResult = result; // Perbarui hasil scan
                  });
                }
              },
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
