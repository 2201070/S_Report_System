import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime date;
  

  AppNotification({
    required this.title,
    required this.body,
    required this.date,
    
  });

  // دالة تحويل البيانات (Mapping) من قاعدة البيانات إلى هيكل المنصة
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      title: map['title'] ?? 'بدون عنوان',
      body: map['body'] ?? 'بدون تفاصيل',
      // التعديل الهندسي لمنع الأخطاء: تحويل آمن للزمن
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
