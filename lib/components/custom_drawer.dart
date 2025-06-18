import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/theme_provider.dart';
import 'package:world_music_nancy/providers/user_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isLoggedIn = userProvider.isLoggedIn;

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              isLoggedIn ? userProvider.username ?? 'User' : 'Guest',
              style: const TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              isLoggedIn ? userProvider.email ?? '' : '',
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: isLoggedIn && userProvider.profileImage != null
                  ? NetworkImage(userProvider.profileImage!)
                  : null,
              child: isLoggedIn && userProvider.profileImage == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          NeonAwareTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          NeonAwareTile(
            leading: const Icon(Icons.library_music, color: Colors.white),
            title: const Text('Library', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushNamed(context, '/library'),
          ),
          NeonAwareTile(
            leading: const Icon(Icons.download, color: Colors.white),
            title: const Text('Downloads', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushNamed(context, '/downloads'),
          ),
          NeonAwareTile(
            leading: const Icon(Icons.color_lens, color: Colors.white),
            title: const Text('Toggle Theme', style: TextStyle(color: Colors.white)),
            onTap: () => themeProvider.toggleTheme(),
          ),
          if (isLoggedIn)
            NeonAwareTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                userProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        ],
      ),
    );
  }
}
