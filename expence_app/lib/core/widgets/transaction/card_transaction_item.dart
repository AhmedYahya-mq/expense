import 'package:flutter/material.dart';

class CardTransactionItem extends StatelessWidget {
  const CardTransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.isIncome,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Colors.white
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey[700]!
                : Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // الأيقونة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isIncome
                      ? [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ]
                      : [
                          Colors.red.shade400,
                          Colors.red.shade600,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isIncome ? Colors.green : Colors.red).withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // العنوان والوصف
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // المبلغ والوقت
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isIncome ? "+$amount ريال" : "-$amount ريال",
                  style: TextStyle(
                    color:
                        isIncome ? Colors.green.shade400 : Colors.red.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
