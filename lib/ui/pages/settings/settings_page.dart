import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/providers.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final settings = useProvider(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pengaturan',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 14),
          SwitchListTile(
            title: Text('Rekomendasi Restoran'),
            subtitle: Text('Notifikasi rekomendasi restoran tiap jam 11:00'),
            value: settings.isRestaurantRecomendationNotificationEnabled,
            onChanged: (value) {
              context
                  .read(settingsProvider)
                  .toggleRestaurantRecomendationNotification(value);
            },
          )
        ],
      ),
    );
  }
}
