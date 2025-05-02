import 'package:flutter/material.dart';
import '../models/discussion_model.dart';
import '../services/community_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadViewScreen extends StatefulWidget {
  final DiscussionThread thread;

  const ThreadViewScreen({super.key, required this.thread});

  @override
  State<ThreadViewScreen> createState() => _ThreadViewScreenState();
}

class _ThreadViewScreenState extends State<ThreadViewScreen> {
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _submitPost() async {
    if (_controller.text.trim().isEmpty) return;
    await CommunityService().addPost(
      widget.thread.id,
      _controller.text.trim(),
      user?.email ?? 'Anonymous',
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.thread.title)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<DiscussionPost>>(
              stream: CommunityService().getPosts(widget.thread.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (_, i) {
                    final post = posts[i];
                    return ListTile(
                      title: Text(post.text),
                      subtitle: Text('${post.author} • ${post.timestamp}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Write a reply...'))),
                IconButton(icon: const Icon(Icons.send), onPressed: _submitPost),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
