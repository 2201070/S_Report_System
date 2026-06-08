import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
 const SplashScreen({super.key});

 @override
 State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
 late AnimationController _glowController;
 late AnimationController _progressController;
 late AnimationController _fadeController;

 late Animation<double> _glowAnimation;
late Animation<double> _fadeAnimation;
 late Animation<double> _scaleAnimation;
 late Animation<double> _progressAnimation;

@override
 void initState() {
super.initState();

 // Fade and Scale for initial entry
 _fadeController = AnimationController(
 vsync: this,
 duration: const Duration(milliseconds: 500),
 );
 _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
parent: _fadeController,
 curve: Curves.easeOut,
 ));
_scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
 parent: _fadeController,
 curve: Curves.easeOut,
 ));

// Glow Animation (cycles between 20.0 and 40.0)
 _glowController = AnimationController(
 vsync: this,
 duration: const Duration(seconds: 2),
 )..repeat(reverse: true);

_glowAnimation = Tween<double>(begin: 20.0, end: 40.0).animate(CurvedAnimation(
 parent: _glowController,
 curve: Curves.easeInOut,
));

 // Progress bar reading from 0% to 100% over 2.5 seconds
 _progressController = AnimationController(
 vsync: this,
 duration: const Duration(milliseconds: 2500),
);

_progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
parent: _progressController,
 curve: Curves.easeInOut,
 ));

 _startAnimations();
 }

 void _startAnimations() async {
 _fadeController.forward();
  
 // Slight delay for progress bar start based on React's delay of 0.9s
 await Future.delayed(const Duration(milliseconds: 900));
 _progressController.forward();

 // 3 seconds total navigation delay based on timer
 await Future.delayed(const Duration(milliseconds: 2100)); // 0.9s + 2.1s = 3.0s total

 if (!mounted) return;

 
 final user = FirebaseAuth.instance.currentUser;

  if (user != null && user.emailVerified) {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      // مسجل دخول → روح للـ Dashboard
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // Firebase موجود بس مفيش token → روح للـ Login
      Navigator.pushReplacementNamed(context, '/login');
    }
  } else {
    // مش مسجل → روح للـ Onboarding
    Navigator.pushReplacementNamed(context, '/onboarding');
  }
 }

 @override
 void dispose() {
 _fadeController.dispose();
 _glowController.dispose();
 _progressController.dispose();
 super.dispose();
 }
@override
  Widget build(BuildContext context) {
    // ... كود الـ UI الخاص بك يظل كما هو تماماً ...
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildLogoWithGlow(),
                    ),
                  ),
                  _buildAppTitle(),
                  _buildTagline(),
                  _buildProgressBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // دوال مساعدة للحفاظ على نظافة الـ build
  Widget _buildLogoWithGlow() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 128, height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(colors: [AppColors.accentBlue, Color(0xFF0077B6)]),
              boxShadow: [BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.6), blurRadius: _glowAnimation.value, spreadRadius: 2)],
            ),
            child: const Center(child: Icon(Icons.volume_up_rounded, color: AppColors.backgroundStart, size: 64)),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _progressAnimation.value > 0 ? 1.0 : 0.0,
          child: Container(
            width: 256, height: 4,
            decoration: BoxDecoration(color: const Color(0xFF1D2128), borderRadius: BorderRadius.circular(2)),
            clipBehavior: Clip.hardEdge,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progressAnimation.value,
              child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.accentBlue, Colors.green]))),
            ),
          ),
        );
      },
    );
  }
  
  // شطبنا الأكواد المكررة لسهولة القراءة
  Widget _buildAppTitle() => const Text('S-Report', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2.0));
  Widget _buildTagline() => const Text('Your Voice for a Better Community', style: TextStyle(color: AppColors.textSecondary, fontSize: 16));
}