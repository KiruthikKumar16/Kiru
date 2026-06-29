import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> _notifications = const [
    {
      'title': 'Friend Request',
      'body': 'Sophie Miller sent you a friend request.',
      'time': '2m ago',
      'icon': 'person_add',
    },
    {
      'title': 'Outfit Liked',
      'body': 'Marcus Chen liked your Kyoto Day 2 outfit pairing.',
      'time': '1h ago',
      'icon': 'favorite',
    },
    {
      'title': 'Trip Twin Alert ✈️',
      'body': '3 travelers in Kiru are heading to Paris on the same dates as you!',
      'time': '3h ago',
      'icon': 'flight',
    },
    {
      'title': 'Weather Alert 🌧️',
      'body': 'Rain forecast for tomorrow in Amalfi. Check updated outfit suggestions.',
      'time': '5h ago',
      'icon': 'wb_cloudy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: _notifications.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final notif = _notifications[index];
            IconData iconData;
            switch (notif['icon']) {
              case 'favorite':
                iconData = Icons.favorite;
                break;
              case 'person_add':
                iconData = Icons.person_add;
                break;
              case 'flight':
                iconData = Icons.flight;
                break;
              default:
                iconData = Icons.notifications;
            }

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(iconData, color: AppColors.primary, size: 20),
              ),
              title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(notif['body']!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              trailing: Text(notif['time']!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            );
          },
        ),
      ),
    );
  }
}
