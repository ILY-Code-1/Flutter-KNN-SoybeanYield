import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const DetailRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: AppTextStyles.detailLabel(context)),
        ),
        Text(': ', style: AppTextStyles.detailLabel(context)),
        Text(
          value,
          style: AppTextStyles.detailLabel(context).copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}
