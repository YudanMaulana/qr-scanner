import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  bool _isDetecting = false;

  late AnimationController _animationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _lineAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 39, 38, 43),
        title: const Text(
          'Silahkan Scan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 24, 23, 28),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture barcodeCapture) {
              if (!_isDetecting) {
                _isDetecting = true;
                final barcode = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes.first
                    : null;
                if (barcode?.rawValue != null) {
                  Navigator.pop(context, barcode!.rawValue);
                } else {
                  _showErrorDialog('QR Code tidak valid.');
                }
              }
            },
            fit: BoxFit.cover,
          ),
          // Animasi garis scan
          AnimatedBuilder(
            animation: _lineAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height *
                    0.9 *
                    _lineAnimation.value,
                left: 20,
                right: 20,
                child: Container(
                  height: 3,
                  color: Colors.redAccent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kesalahan'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
