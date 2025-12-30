class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final int lessons;
  final String duration;
  final String imageUrl;
  final String category;
  bool isEnrolled;
  double progress;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.lessons,
    required this.duration,
    required this.imageUrl,
    required this.category,
    this.isEnrolled = false,
    this.progress = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'lessons': lessons,
      'duration': duration,
      'imageUrl': imageUrl,
      'category': category,
      'isEnrolled': isEnrolled,
      'progress': progress,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      lessons: json['lessons'],
      duration: json['duration'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      isEnrolled: json['isEnrolled'] ?? false,
      progress: json['progress'] ?? 0.0,
    );
  }
}