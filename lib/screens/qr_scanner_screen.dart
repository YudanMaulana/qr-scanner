import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller =
      MobileScannerController(facing: CameraFacing.back);
  String? errorMessage;
  bool showScanButton = false; // Variabel untuk kontrol visibilitas tombol

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture barcodeCapture) {
              final barcode = barcodeCapture.barcodes.isNotEmpty
                  ? barcodeCapture.barcodes.first
                  : null;
              if (barcode?.rawValue != null) {
                _showResultDialog(
                    barcode!.rawValue!); // Menampilkan dialog hasil scan
              } else {
                setState(() {
                  errorMessage = 'QR Code tidak valid.';
                  showScanButton = true; // Menampilkan tombol "scan lagi"
                });
              }
            },
            fit: BoxFit.contain,
          ),
          if (errorMessage != null)
            Center(
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          // Tombol untuk scan lagi hanya tampil saat QR Code tidak terdeteksi
          if (showScanButton)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showScanButton =
                        false; // Menyembunyikan tombol setelah ditekan
                    errorMessage = null; // Reset error message
                  });
                },
                child: const Text('Scan Lagi'),
              ),
            ),
        ],
      ),
    );
  }

  // Menampilkan dialog dengan hasil scan dan tombol untuk scan lagi
  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil Scan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code Terdeteksi: $result',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Menutup dialog setelah tombol ditekan
                  setState(() {
                    showScanButton = false; // Reset tombol untuk scan lagi
                  });
                },
                child: const Text('Scan Lagi'),
              ),
            ],
          ),
        );
      },
    );
  }
}
