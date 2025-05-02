import 'package:flutter/material.dart';
import '../services/community_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateThreadScreen extends StatefulWidget {
  const CreateThreadScreen({super.key});

  @override
  State<CreateThreadScreen> createState() => _CreateThreadScreenState();
}

class _CreateThreadScreenState extends State<CreateThreadScreen> {
  final _titleController = TextEditingController();
  String _genre = 'General';
  final List<String> genres = ['General', 'Fiction', 'Sci-fi', 'Mystery'];

  void _createThread() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Anonymous';

    await CommunityService().createThread(title, _genre, email);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a Discussion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Thread Title')),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _genre,
              onChanged: (value) => setState(() => _genre = value!),
              items: genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _createThread, child: const Text('Create Thread')),
          ],
        ),
      ),
    );
  }
}
