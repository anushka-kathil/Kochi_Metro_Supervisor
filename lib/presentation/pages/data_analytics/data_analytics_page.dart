import 'package:flutter/material.dart';

class DataAnalyticsPage extends StatelessWidget {
  const DataAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/da.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
