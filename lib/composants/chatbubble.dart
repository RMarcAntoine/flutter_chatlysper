import 'package:chatlysper_app/themes/themeprovid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                color: isCurrentUser
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black)),
          ),
          SizedBox(height: 5),
          Text(
            formattedDate,
            style: TextStyle(
              color: isCurrentUser
                  ? Colors.white70
                  : (isDarkMode ? Colors.white70 : Colors.black54),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
