class LostFound {
  final String userId;
  final String title;
  final String description;
  final String? photoUrl; // optional now
  final String? facebook;
  final String? phone;
  final DateTime dateTime;
  final bool isLost;
 bool isResolved;// <-- bool in Dart
final String? id;
  LostFound({
    required this.userId,
    required this.title,
    required this.description,
   this.photoUrl,
    this.facebook,
    this.phone,
    required this.dateTime,
    required this.isLost,
    required this.isResolved,
    this.id
  });

  factory LostFound.fromMap(Map<String, dynamic> map) {
    return LostFound(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      photoUrl: map['photo_url'],
      facebook: map['facebook'],
      phone: map['phone'],
      dateTime: DateTime.parse(map['date_time']),
   isLost: map['is_lost'] as bool,        // already a boolean
    isResolved: map['is_resolved'] as bool, // int → bool
    );
  }

Map<String, dynamic> toMap() {
  return {
    'user_id': userId,
    'title': title,
    'description': description,
    'date_time': dateTime.toIso8601String(),
    'is_lost': isLost ? 1 : 0,
    'is_resolved': isResolved ? 1 : 0,
    if (photoUrl != null) 'photo_url': photoUrl,
    if (facebook != null) 'facebook': facebook,
    if (phone != null) 'phone': phone,
  };
}

}
