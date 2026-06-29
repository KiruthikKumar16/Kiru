import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class LoanedItemsScreen extends StatelessWidget {
  const LoanedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loaned Items Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [Tab(text: 'Lent to Friends'), Tab(text: 'Borrowed')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: const [
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=150&auto=format&fit=crop')),
                  title: Text('Linen Vacation Shirt', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Lent to Marcus Chen • Due back in 3 days'),
                  trailing: Text('Active Loan', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const Center(child: Text('No borrowed items currently.')),
          ],
        ),
      ),
    );
  }
}
