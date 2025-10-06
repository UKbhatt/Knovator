import 'package:flutter/material.dart';

class PrimaryLoader extends StatelessWidget {
  const PrimaryLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
