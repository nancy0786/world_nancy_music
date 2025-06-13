
import 'package:flutter/material.dart';

class NeonTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Tab> tabs;

  const NeonTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs,
      indicator: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
