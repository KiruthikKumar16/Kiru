import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class FollowersListScreen extends StatelessWidget {
  const FollowersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connections', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [Tab(text: 'Followers (142)'), Tab(text: 'Following (89)')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: const [
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop')),
                  title: Text('Marcus Chen', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('@marcus_chen'),
                ),
              ],
            ),
            const Center(child: Text('Following list...')),
          ],
        ),
      ),
    );
  }
}
