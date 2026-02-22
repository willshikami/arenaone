import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d').format(now);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formattedDate,
            style: GoogleFonts.figtree(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: Colors.black, size: 24),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                _BadgeIcon(color: Colors.blue),
                _BadgeIcon(color: Colors.green),
                _BadgeIcon(color: Colors.teal),
                Text('+3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey, // Background color while loading
              ),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.blue,
                  child: Text('4', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final Color color;
  const _BadgeIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SportSelector extends StatelessWidget {
  final List<Map<String, dynamic>> sports = [
    {'name': 'NBA', 'icon': Icons.sports_basketball},
    {'name': 'MLB', 'icon': Icons.sports_baseball},
    {'name': 'NHL', 'icon': Icons.sports_hockey},
    {'name': 'NFL', 'icon': Icons.sports_football},
    {'name': 'EPL', 'icon': Icons.sports_soccer},
    {'name': 'Tennis', 'icon': Icons.sports_tennis},
  ];

  SportSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sport = sports[index]['name'] as String;
          final icon = sports[index]['icon'] as IconData;
          final isSelected = sport == 'NBA';

          return FilterChip(
            avatar: Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 16),
            label: Text(sport),
            selected: isSelected,
            onSelected: (selected) {},
            backgroundColor: Colors.grey.shade100,
            selectedColor: Colors.black,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? Colors.black : Colors.transparent),
            ),
          );
        },
      ),
    );
  }
}
