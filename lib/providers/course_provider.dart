import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class CourseProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  User? _currentUser;
  List<Course> _allCourses = [];
  List<Course> _enrolledCourses = [];

  User? get currentUser => _currentUser;
  List<Course> get allCourses => _allCourses;
  List<Course> get enrolledCourses => _enrolledCourses;

  CourseProvider() {
    _initializeCourses();
    loadUser();
    loadEnrolledCourses();
  }

  void _initializeCourses() {
    _allCourses = [
      Course(
        id: '1',
        title: 'Flutter Development',
        description: 'Learn to build beautiful mobile applications with Flutter framework. Master widgets, state management, and navigation.',
        instructor: 'Dr. Ahmed Ali',
        lessons: 24,
        duration: '8 weeks',
        imageUrl: '📱',
        category: 'Mobile Development',
      ),
      Course(
        id: '2',
        title: 'Business Management',
        description: 'Comprehensive business management course covering leadership, strategy, and operations management.',
        instructor: 'Prof. Sarah Johnson',
        lessons: 18,
        duration: '6 weeks',
        imageUrl: '💼',
        category: 'Business',
      ),
      Course(
        id: '3',
        title: 'Data Science',
        description: 'Master data analysis, machine learning, and statistical methods for data-driven decision making.',
        instructor: 'Dr. Mohamed Hassan',
        lessons: 30,
        duration: '10 weeks',
        imageUrl: '📊',
        category: 'Technology',
      ),
      Course(
        id: '4',
        title: 'Digital Marketing',
        description: 'Learn SEO, social media marketing, content strategy, and digital advertising techniques.',
        instructor: 'Layla Ahmed',
        lessons: 20,
        duration: '7 weeks',
        imageUrl: '📈',
        category: 'Marketing',
      ),
      Course(
        id: '5',
        title: 'Graphic Design',
        description: 'Master Adobe Creative Suite, design principles, typography, and visual communication.',
        instructor: 'Omar Khalil',
        lessons: 16,
        duration: '5 weeks',
        imageUrl: '🎨',
        category: 'Design',
      ),
    ];
  }

  Future<void> login(User user) async {
    await _storage.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _currentUser = await _storage.getUser();
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await _storage.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> enrollCourse(Course course) async {
    course.isEnrolled = true;
    if (!_enrolledCourses.any((c) => c.id == course.id)) {
      _enrolledCourses.add(course);
      await _storage.saveEnrolledCourses(_enrolledCourses);
      notifyListeners();
    }
  }

  Future<void> loadEnrolledCourses() async {
    _enrolledCourses = await _storage.getEnrolledCourses();
    for (var enrolled in _enrolledCourses) {
      final index = _allCourses.indexWhere((c) => c.id == enrolled.id);
      if (index != -1) {
        _allCourses[index].isEnrolled = true;
        _allCourses[index].progress = enrolled.progress;
      }
    }
    notifyListeners();
  }

  Future<void> updateProgress(String courseId, double progress) async {
    final enrolledIndex = _enrolledCourses.indexWhere((c) => c.id == courseId);
    if (enrolledIndex != -1) {
      _enrolledCourses[enrolledIndex].progress = progress;
      await _storage.saveEnrolledCourses(_enrolledCourses);
      
      final allIndex = _allCourses.indexWhere((c) => c.id == courseId);
      if (allIndex != -1) {
        _allCourses[allIndex].progress = progress;
      }
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.logout();
    _currentUser = null;
    _enrolledCourses.clear();
    for (var course in _allCourses) {
      course.isEnrolled = false;
      course.progress = 0.0;
    }
    notifyListeners();
  }
}