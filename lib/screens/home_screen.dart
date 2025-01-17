import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'qr_scanner_screen.dart';
import 'search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    print('Data Tersimpan: $savedData');
    if (savedData != null) {
      setState(() {
        _apiData = jsonDecode(savedData);
      });
    }
  }

  void _checkScanResult(String result) {
    print('Hasil Scan: $result');
    final isRegistered = _apiData.any((item) {
      print('Item API: $item');
      return item.entries.any((entry) => entry.value.toString() == result);
    });
    setState(() {
      _status = isRegistered ? 'Terdaftar' : 'Tidak Terdaftar';
      _scanResult = result;
    });
  }

  Future<void> _openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka tautan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka tautan!')),
      );
    }
  }

  bool _isLink(String text) {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9.-]+)(:[0-9]+)?(\/[^\s]*)?$',
    );
    return urlRegex.hasMatch(text);
  }

  Future<void> _addToSearchPageWithId(String scannedUID) async {
    final mesinController = TextEditingController();
    final currentDate = DateTime.now();
    final formattedDate =
        '${currentDate.year}-${currentDate.month}-${currentDate.day}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tambahkan Data',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 39, 38, 43),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mesinController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nomor Mesin',
                  border: const OutlineInputBorder(),
                  floatingLabelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 88, 88, 88)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: false,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'UID (Hasil Scan)',
                  hintText: scannedUID,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(),
                  floatingLabelStyle: const TextStyle(color: Colors.white),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 88, 88, 88)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: false,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tanggal Perbaikan',
                  hintText: formattedDate,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(),
                  floatingLabelStyle: const TextStyle(color: Colors.white),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 88, 88, 88)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                final nomorMesin = mesinController.text.trim();
                if (nomorMesin.isNotEmpty) {
                  setState(() {
                    _apiData.insert(0, {
                      'nomorMesin': nomorMesin,
                      'UID': scannedUID,
                      'tanggal': formattedDate,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil ditambahkan!')),
                  );
                }
                Navigator.pop(context);
              },
              child:
                  const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 39, 38, 43),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 39, 38, 43),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 50, 50, 60),
              ),
              child: Text(
                'Pengaturan',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('Versi Aplikasi',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      backgroundColor: Color.fromARGB(255, 50, 50, 60),
                      title: Text('Versi Aplikasi',
                          style: TextStyle(color: Colors.white)),
                      content: Text(
                        'Versi saat ini: 1.0.0',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Menjaga tombol di bawah
        children: [
          // Bagian atas konten
          const SizedBox(height: 10),
          Center(
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
                          color: _status == 'Terdaftar'
                              ? Colors.lightGreen
                              : Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (_scanResult.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            if (_isLink(_scanResult)) {
                              _openLink(_scanResult);
                            }
                          },
                          child: Text(
                            _scanResult,
                            style: TextStyle(
                              fontSize: 17,
                              color: _isLink(_scanResult)
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (_status == 'Tidak Terdaftar')
                        GestureDetector(
                          onTap: () {
                            _addToSearchPageWithId(
                                _scanResult); // Pastikan _scanResult diisi sebelumnya
                          },
                          child: const Text(
                            'Tambahkan?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  const Text(
                    'Belum ada hasil scan.',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
              ],
            ),
          ),
          // Tombol di bagian bawah
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 38, 43),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 39, 38, 43),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Dapatkan Data'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 39, 38, 43),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
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
          ),
        ],
      ),
    );
  }
}
