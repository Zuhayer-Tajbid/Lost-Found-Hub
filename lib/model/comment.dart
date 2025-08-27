class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName; // <-- add this
  final String text;
  final String? parentCommentId;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    this.parentCommentId,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      userName: map['user_name'] ?? '', // from join or manual query
      text: map['text'],
      parentCommentId: map['parent_comment_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'text': text,
      'parent_comment_id': parentCommentId,
    };
  }
}
