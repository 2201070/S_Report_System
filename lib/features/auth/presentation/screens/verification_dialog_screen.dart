import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatelessWidget {
  final String userEmail;

  const VerificationScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF12151C);
    final Color cardColor = const Color(0xFF1D2128);
    final Color accentColor = const Color(0xFF00B4D8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // أيقونة توضيحية لعملية التفعيل
              Icon(Icons.mark_email_read_outlined, size: 100, color: accentColor),
              const SizedBox(height: 40),
              
              const Text(
                'تفعيل حسابك',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'لقد أرسلنا رابط تفعيل إلى:',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userEmail,
                      style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'يرجى الضغط على الرابط الموجود في الرسالة لتتمكن من استخدام كافة صلاحيات منصة S-Report.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // أزرار التحكم
              ElevatedButton(
                onPressed: () async {
                  // تسجيل الخروج لضمان إعادة المصادقة بعد التفعيل
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('اذهب لتسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              
              TextButton(
                onPressed: () async {
                  // إمكانية إعادة إرسال الرابط إذا لم يصل
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إعادة إرسال الرابط بنجاح')),
                    );
                  }
                },
                child: Text('لم يصلك الرابط؟ إعادة الإرسال', style: TextStyle(color: Colors.grey[400])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}