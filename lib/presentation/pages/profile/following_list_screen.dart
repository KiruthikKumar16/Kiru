import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class FollowingListScreen extends StatelessWidget {
  const FollowingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Following', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-${1500000000000 + index * 1000}?w=200&auto=format&fit=crop',
                ),
              ),
              title: Text('User ${index + 1}'),
              subtitle: Text('@user${index + 1}'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Following'),
              ),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
