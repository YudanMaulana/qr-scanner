import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('savedData');
    if (savedData != null) {
      setState(() {
        _apiData = jsonDecode(savedData);
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedData', jsonEncode(_apiData));
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchData();
      setState(() {
        _apiData = data;
      });
      await _saveData();
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

  Future<void> _openLink(String url) async {
    // Cek apakah URL dapat dibuka
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka tautan!')),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hasil scan disalin ke clipboard!')),
    );
  }

  void _addToSearchPage() async {
    setState(() {
      _apiData.insert(0, {'name': _scanResult});
    });
    await _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil ditambahkan ke daftar!')),
    );
  }

  bool _isLink(String text) {
    // Pola regex sederhana untuk mendeteksi URL ny
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9.-]+)(:[0-9]+)?(\/[^\s]*)?$',
    );
    return urlRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  const SizedBox(height: 20),
                  if (_scanResult.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        if (_isLink(_scanResult)) {
                          _openLink(_scanResult);
                        } else {
                          _copyToClipboard(_scanResult);
                        }
                      },
                      child: Text(
                        _scanResult,
                        style: TextStyle(
                          fontSize: 17,
                          color:
                              _isLink(_scanResult) ? Colors.blue : Colors.black,
                          decoration: _isLink(_scanResult)
                              ? TextDecoration.underline
                              : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (_status == 'Tidak Terdaftar')
                    GestureDetector(
                      onTap: _addToSearchPage,
                      child: const Text(
                        'Tambahkan?',
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
            Column(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
