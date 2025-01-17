import 'package:flutter/material.dart';
import 'package:y_Scanner/screens/qr_scanner_screen.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, String>> initialData;
  SearchPage({this.initialData = const []});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Map<String, String>> _data;
  @override
  void initState() {
    super.initState();
    _data = List.from(widget.initialData);
  }

  void _addScannedData(String scannedValue) {
    setState(() {
      _data.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'value': scannedValue,
      });
    });
  }

  void _editItem(int index) {
    final selectedItem = _data[index];
    final valueController = TextEditingController(text: selectedItem['value']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: TextField(
            controller: valueController,
            decoration: const InputDecoration(labelText: 'Value'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _data[index]['value'] = valueController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        backgroundColor: const Color.fromARGB(255, 39, 38, 43),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final scannedValue = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScannerScreen()),
          );
          if (scannedValue != null) {
            _addScannedData(scannedValue);
          }
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          print('Rendering item ${index + 1} of ${_data.length}'); // Debug log
          return ListTile(
            title: Text(
              _data[index]['value'] ?? '',
              style: TextStyle(color: Colors.black),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editItem(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
