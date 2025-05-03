import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/google_books_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'book_details_screen.dart';
import 'my_library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _recommendations = [];
  List<Map<String, dynamic>> _trending = [];
  UserModel? _profile;

  @override
  void initState() {
    super.initState();
    _loadUserAndBooks();
  }

  Future<void> _loadUserAndBooks() async {
    final userModel = await UserService().getUser();
    setState(() => _profile = userModel);

    final recBooks = await GoogleBooksService.searchBooks(
      (userModel?.preferredGenres.isNotEmpty == true)
          ? userModel!.preferredGenres.first
          : 'fiction',
    );

    final trendingBooks = await GoogleBooksService.searchBooks('bestsellers');

    setState(() {
      _recommendations = recBooks;
      _trending = trendingBooks;
    });
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book['thumbnail'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(book['thumbnail'], height: 150, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8),
            Text(
              book['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              book['authors'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookSection(String title, List<Map<String, dynamic>> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, i) => _buildBookCard(books[i]),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final welcome = _profile != null ? 'Welcome, ${_profile!.name.split(' ').first}!!!' : 'Welcome Back!!!';

    return Scaffold(
      appBar: AppBar(
        title: Text(welcome),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyLibraryScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserAndBooks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookSection('Recommended for You', _recommendations),
              _buildBookSection('Trending Books', _trending),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}