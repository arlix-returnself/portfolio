import 'package:flutter/material.dart';

class ProfileLoadError extends StatelessWidget {
  const ProfileLoadError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, size: 48),
              SizedBox(height: 12),
              Text('Could not load profile data.', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
