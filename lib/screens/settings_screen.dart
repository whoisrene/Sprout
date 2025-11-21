import 'package:flutter/material.dart';
import 'package:sprout/main.dart';
import 'package:sprout/services/user_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  double soundLevel = 0.5;
  ThemeMode selectedTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // load saved theme (optional)
    UserStorage.loadThemeMode().then((saved) {
      if (saved != null) {
        setState(() => selectedTheme = saved);
      }
    });
  }

  Future<void> _onThemeChanged(ThemeMode? mode) async {
    if (mode == null) return;
    setState(() => selectedTheme = mode);
    themeModeNotifier.value = mode;
    await UserStorage.saveThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // General category
          ExpansionTile(
            title: const Text('General'),
            leading: const Icon(Icons.settings),
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
              ListTile(
                title: const Text('Sound Level'),
                subtitle: Slider(
                  value: soundLevel,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: (soundLevel * 100).round().toString(),
                  onChanged: (value) {
                    setState(() => soundLevel = value);
                  },
                ),
              ),
            ],
          ),

          // Appearance category
          ExpansionTile(
            title: const Text('Appearance'),
            leading: const Icon(Icons.color_lens),
            children: [
              ListTile(
                title: const Text('Theme'),
                subtitle: DropdownButton<ThemeMode>(
                  value: selectedTheme,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('Automatic'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: _onThemeChanged,
                ),
              ),
            ],
          ),

          // Account category
          ExpansionTile(
            title: const Text('Account'),
            leading: const Icon(Icons.person),
            children: const [
              ListTile(title: Text('Change Username')),
              ListTile(title: Text('Change Password')),
            ],
          ),
        ],
      ),
    );
  }
}

