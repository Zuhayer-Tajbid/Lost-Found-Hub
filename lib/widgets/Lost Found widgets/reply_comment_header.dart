import 'package:flutter/material.dart';

class ReplyCommentHeader extends StatefulWidget {
  const ReplyCommentHeader({
    super.key,
    this.replyingToUserName,
    this.replyingToCommentId,
    required this.onClose,
  });

  final void Function() onClose;
  final String? replyingToCommentId;
  final String? replyingToUserName;
  @override
  State<ReplyCommentHeader> createState() => _ReplyCommentHeaderState();
}

class _ReplyCommentHeaderState extends State<ReplyCommentHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "Replying to ${widget.replyingToUserName}",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }
}
