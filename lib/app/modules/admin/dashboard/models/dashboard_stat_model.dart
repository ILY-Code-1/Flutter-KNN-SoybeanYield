import 'package:flutter/material.dart';

class DashboardStatModel {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color valueColor;
  final Color labelColor;

  const DashboardStatModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.valueColor,
    required this.labelColor,
  });
}
