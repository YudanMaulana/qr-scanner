import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<dynamic> data;

  const SearchPage({super.key, required this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ignore: unused_field
  String _searchQuery = '';
  List<dynamic> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Data Tamu Undangan'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterData,
              decoration: const InputDecoration(
                labelText: 'Cari',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredData.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return ListTile(
                        title: Text(item['id']),
                        subtitle: Text(item['name']),
                      );
                    },
                  )
                : const Center(
                    child: Text('Data tidak ditemukan'),
                  ),
          ),
        ],
      ),
    );
  }
}
