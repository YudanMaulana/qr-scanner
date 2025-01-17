import 'package:flutter/material.dart';

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
    _filteredData = widget.data; // Set data awal
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      _filteredData = widget.data
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()))
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Data'),
      ),
      body: Column(
        children: [
          // Form pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterData,
              decoration: const InputDecoration(
                labelText: 'Cari Data',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Daftar data dengan ikon hapus
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return ListTile(
                  title: Text(item['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
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
