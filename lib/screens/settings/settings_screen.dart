import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'الإعدادات'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'الإشعارات'),
          SwitchListTile(
            title: const Text('إشعارات لحظية'),
            subtitle: const Text('تلقي إشعارات مباشرة على هاتفك'),
            secondary: const Icon(LucideIcons.bell),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('إشعارات البريد الإلكتروني'),
            subtitle: const Text('تلقي ملخصات وتقارير على بريدك'),
            secondary: const Icon(LucideIcons.mail),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          const Divider(height: 32),
          _buildSectionTitle(context, 'الحساب'),
          ListTile(
            leading: const Icon(LucideIcons.lock),
            title: const Text('تغيير كلمة المرور'),
            trailing: const Icon(LucideIcons.chevronLeft),
            onTap: () {
              // TODO: Navigate to change password screen
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.trash2, color: Colors.red),
            title: const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Show delete account confirmation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
