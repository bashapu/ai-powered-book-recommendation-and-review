import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/library_service.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen>
    with SingleTickerProviderStateMixin {
  final LibraryService _libraryService = LibraryService();
  late TabController _tabController;

  final List<String> _statuses = [
    'want_to_read',
    'currently_reading',
    'finished'
  ];

  @override
  void initState() {
    _tabController = TabController(length: _statuses.length, vsync: this);
    super.initState();
  }

  Widget _buildBookCard(BookModel book) {
    return ListTile(
      leading: book.thumbnail != null
          ? Image.network(book.thumbnail!, width: 50)
          : const Icon(Icons.book),
      title: Text(book.title),
      subtitle: Text(book.authors),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Want to Read'),
            Tab(text: 'Currently Reading'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statuses.map((status) {
          return StreamBuilder<List<BookModel>>(
            stream: _libraryService.getBooksByStatus(status),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final books = snapshot.data!;
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (_, i) => _buildBookCard(books[i]),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
