import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String body;
  final Color accentColor;

  const InfoCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardLabel(context)
                .copyWith(fontWeight: FontWeight.bold, color: accentColor),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.inputLabel(context)
                .copyWith(color: accentColor.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 8),
          Text(body, style: AppTextStyles.bodyText(context)),
        ],
      ),
    );
  }
}
