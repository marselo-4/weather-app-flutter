import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_map_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weather App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // _buildMenuItem(
                //   icon: Icons.location_on_outlined,
                //   text: 'Current Location',
                //   badge: 1,
                //   onTap: () => Navigator.pop(context),
                //   enabled: false,
                // ),
                _buildMenuItem(
                  icon: Icons.favorite_outline,
                  text: 'Saved Locations',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  enabled: false,
                ),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  text: 'Search History',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  enabled: false,
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  text: 'Weather Alerts',
                  badge: 3,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  enabled: false,
                ),
                const Divider(),
                _buildMenuItem(
                  icon: Icons.map_outlined,
                  text: 'Weather Map',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const WeatherMapScreen(
                              apiKey: '117c225d3b7af650b6792e6fbbb07137',
                            ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  enabled: false,
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.brightness_6_outlined, color: Colors.grey[400]),
                const SizedBox(width: 12),
                Text('Dark Mode', style: TextStyle(color: Colors.grey[400])),
                const Spacer(),
                Switch(
                  value: false,
                  onChanged: null,
                  activeColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                  inactiveThumbColor: Colors.grey[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    int? badge,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: enabled ? onTap : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: enabled ? Colors.grey[600] : Colors.grey[400],
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: enabled ? Colors.black : Colors.grey[400],
          ),
        ),
        trailing:
            badge != null && enabled
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                : null,
      ),
    );
  }
}
