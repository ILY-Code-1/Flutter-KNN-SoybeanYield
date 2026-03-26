import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: AppTextStyles.detailLabel(context)),
          ),
          Expanded(
            flex: 5,
            child: Text(': $value', style: AppTextStyles.detailValue(context)),
          ),
        ],
      ),
    );
  }
}
