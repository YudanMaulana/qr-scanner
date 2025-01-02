import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final List<dynamic> data;

  const SearchPage({super.key, required this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> _filteredData = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('savedData');
    debugPrint('Loaded data: $savedData'); // Debug log buat memastikan ke save
    setState(() {
      if (savedData != null) {
        widget.data.clear();
        widget.data.addAll(jsonDecode(savedData));
        _filteredData = widget.data;
      } else {
        _filteredData = widget.data;
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedString = jsonEncode(widget.data);
    await prefs.setString('savedData', savedString);
    debugPrint('Saved data: $savedString');
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      _filteredData = widget.data
          .where(
              (item) => item['id'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      widget.data.removeAt(index);
      _filteredData = widget.data
          .where((item) =>
              item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
    _saveData(); // Simpan perubahan setelah penghapusan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus!')),
    );
  }

  void _resetData() async {
    setState(() {
      widget.data.clear();
      _filteredData.clear();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedData'); // buat Hapus data dari SharedPreferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua data berhasil dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 38, 43),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Cari Data',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetData,
            tooltip: 'Reset Data',
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Form pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterData,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Cari Data',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                floatingLabelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 88, 88, 88)),
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: const Color.fromARGB(255, 39, 38, 43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['id']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
