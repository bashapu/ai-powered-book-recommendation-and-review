import 'package:flutter/material.dart';
import '../services/user_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<String> _genres = [
    'Fiction', 'Non-fiction', 'Mystery', 'Sci-fi', 'Romance', 'Fantasy', 'Biography'
  ];
  final Set<String> _selectedGenres = {};

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  void _loadGenres() async {
    final user = await UserService().getUser();
    setState(() {
      _selectedGenres.addAll(user?.preferredGenres ?? []);
    });
  }

  void _savePreferences() async {
    await UserService().updateGenres(_selectedGenres.toList());
    Navigator.pop(context);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Preferences')),
      body: ListView(
        children: _genres.map((genre) {
          final selected = _selectedGenres.contains(genre);
          return CheckboxListTile(
            title: Text(genre),
            value: selected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedGenres.add(genre);
                } else {
                  _selectedGenres.remove(genre);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePreferences,
        child: const Icon(Icons.save),
      ),
    );
  }
}
