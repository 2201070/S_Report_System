import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SystemAuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // دالة تسجيل الدخول وربط الإشعارات
  Future<void> loginAndSetupNotifications(String email, String password) async {
    try {
      // 1. إجراء عملية المصادقة (تسجيل الدخول)
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? currentUser = userCredential.user;

      if (currentUser != null) {
        print('System Log: تمت المصادقة بنجاح للمستخدم: ${currentUser.uid}');

        // 2. طلب صلاحية الإشعارات من نظام التشغيل (مهمة في أنظمة iOS و Android 13+)
        await _messaging.requestPermission();

        // 3. استخراج المعرف الرقمي (FCM Token) الخاص بالجهاز الحالي
        String? deviceToken = await _messaging.getToken();

        if (deviceToken != null) {
          // 4. توثيق الـ Token داخل قاعدة البيانات المركزية (Firestore)
          await _firestore.collection('users').doc(currentUser.uid).set({
            'fcmToken': deviceToken,
            'lastLogin': FieldValue.serverTimestamp(), // اختياري: لتوثيق وقت الدخول
          }, SetOptions(merge: true)); // نستخدم merge حتى لا نمسح باقي بيانات المستخدم

          print('System Log: تم ربط المعرف الرقمي بحساب المستخدم بنجاح.');
        }

        // 5. الاستماع لتحديثات الـ Token في الخلفية لضمان استمرارية النظام
        _messaging.onTokenRefresh.listen((newToken) async {
          await _firestore.collection('users').doc(currentUser.uid).update({
            'fcmToken': newToken,
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      print('System Error: خطأ في المصادقة - ${e.message}');
      // يمكنك هنا إضافة أكواد إظهار رسائل الخطأ للمستخدم
    } catch (e) {
      print('System Error: حدث خطأ غير متوقع - $e');
    }
  }
}