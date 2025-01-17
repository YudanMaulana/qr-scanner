import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk Clipboard
import 'qr_scanner_screen.dart';
import 'search_page.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _apiData = [];
  String _status = '';
  String _scanResult = '';

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchData();
      setState(() {
        _apiData = data;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $error')),
      );
    }
  }

  void _checkScanResult(String result) {
    final isRegistered = _apiData.any((item) => item['name'] == result);
    setState(() {
      _status = isRegistered ? 'Terdaftar' : 'Tidak Terdaftar';
      _scanResult = result;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Salin teks ke clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hasil scan disalin ke clipboard!')),
    );
  }

  void _addToSearchPage() {
    setState(() {
      _apiData.insert(0, {'name': _scanResult}); // Tambahkan ke awal
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil ditambahkan ke daftar!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hasil Scan
            if (_status.isNotEmpty)
              Column(
                children: [
                  Text(
                    _status,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: _status == 'Terdaftar' ? Colors.blue : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70),
                  if (_scanResult.isNotEmpty)
                    GestureDetector(
                      onTap: () => _copyToClipboard(_scanResult),
                      child: Text(
                        '$_scanResult',
                        style: const TextStyle(
                            fontSize: 17,
                            color:
                                Color.fromARGB(255, 88, 88, 88) // Garis bawah
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Label "+"
                  GestureDetector(
                    onTap: _addToSearchPage,
                    child: const Text(
                      'tambahkan ?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Belum ada hasil scan.',
                style: TextStyle(fontSize: 20, color: Colors.deepPurple),
              ),
            const SizedBox(height: 70),

            // Dua tombol di bawah (berjajar ke samping)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRScannerScreen()),
                    );
                    if (result != null && result is String) {
                      _checkScanResult(result);
                    }
                  },
                  child: const Text('Scan QR Code'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Dapatkan Data'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(data: _apiData),
                            ),
                          );
                        },
                        child: const Text('Cari Data Manual'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
