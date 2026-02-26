import 'package:flutter/material.dart';

class KPICard extends StatelessWidget {
final String title;
final String value;
final IconData icon;
final Color color;

const KPICard({
super.key,
required this.title,
required this.value,
required this.icon,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: color.withOpacity(0.12),
borderRadius: BorderRadius.circular(18),
),
child: Row(
children: [
CircleAvatar(
radius: 24,
backgroundColor: color,
child: Icon(icon, color: Colors.white),
),
const SizedBox(width: 14),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(title,
style: const TextStyle(
fontSize: 13, color: Colors.black54)),
const SizedBox(height: 6),
Text(value,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold)),
],
),
],
),
);
}
}
