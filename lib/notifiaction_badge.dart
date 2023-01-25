import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key,required this.totalNoti});
  final int totalNoti;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),
      child: Center(
        child: Padding(padding: const EdgeInsets.all(8.0),
        child: Text("$totalNoti"),
        ),

      ),
    );
  }
}