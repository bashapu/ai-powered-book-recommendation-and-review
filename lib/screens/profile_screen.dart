import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'preferences_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService().getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_user!.name}'),
            Text('Email: ${_user!.email}'),
            Text('Preferred Genres: ${_user!.preferredGenres.join(', ')}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()));
              },
              child: const Text('Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreferencesScreen()),
                );
                _loadUser();
              },
              child: const Text('Set Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
