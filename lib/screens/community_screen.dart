import 'package:flutter/material.dart';
import '../services/community_service.dart';
import '../models/discussion_model.dart';
import 'thread_view_screen.dart';
import 'create_thread_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Boards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateThreadScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DiscussionThread>>(
        stream: CommunityService().getThreads(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final threads = snapshot.data!;
          return ListView.builder(
            itemCount: threads.length,
            itemBuilder: (_, i) {
              final thread = threads[i];
              return ListTile(
                title: Text(thread.title),
                subtitle: Text('By ${thread.createdBy} • ${thread.genre}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ThreadViewScreen(thread: thread)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
