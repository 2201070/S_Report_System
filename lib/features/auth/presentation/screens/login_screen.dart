import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart'; //
import 'package:s_report_system/features/auth/presentation/screens/register_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_primary_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // مفتاح للتحقق من الحقول
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isLoading = false; // حالة التحميل لمنع الضغط المتكرر

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _syncWithApi(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('https://abdallahnasrat-001-site1.anytempurl.com/api/Auth/Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final apiData = jsonDecode(response.body);

      // احفظ الـ token والبيانات محلياً
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', apiData['token'] ?? '');
      await prefs.setString('firstName', apiData['firstName'] ?? '');
      await prefs.setInt('userId', apiData['userId'] ?? 0);
      await prefs.setString('role', apiData['role'] ?? '');
      await prefs.setInt('cityId', apiData['cityId'] ?? 0);

      debugPrint('✅ Token: ${apiData['token']}');
      debugPrint('✅ User: ${apiData['firstName']} - ${apiData['role']}');
    }
  } catch (e) {
    debugPrint('❌ API Error: $e');
  }
}

  // --- منطق تسجيل الدخول الفعلي ---
  Future<void> _handleLogin() async {
    // التحقق المبدئي من امتلاء الحقول
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _showSnackBar("الرجاء إدخال البريد الإلكتروني وكلمة المرور", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. محاولة تسجيل الدخول عبر Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // 2. تحديث بيانات المستخدم للتأكد من حالة التفعيل
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          await _syncWithApi(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  
  );
          // 3. التوجيه للوحة التحكم عند نجاح التفعيل
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        } else {
          // 4. حالة عدم تفعيل البريد
          await FirebaseAuth.instance.signOut();
          _showSnackBar("يرجى تفعيل حسابك من خلال الرابط المرسل إلى بريدك الإلكتروني أولاً.", Colors.orange);
        }
      }
    } on FirebaseAuthException catch (e) {
      // معالجة أخطاء Firebase
      String msg = "خطأ في البريد أو كلمة المرور";
      if (e.code == 'user-not-found') msg = "لا يوجد حساب بهذا البريد";
      if (e.code == 'wrong-password') msg = "كلمة المرور غير صحيحة";
      _showSnackBar(msg, Colors.red);
    } catch (e) {
      _showSnackBar("حدث خطأ: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 5)),
    );
  }

  void _handleBiometric() {
    // محاكاة البصمة تظل كما هي
    _showSnackBar("ميزة تسجيل الدخول بالبصمة غير متوفرة حالياً.", Colors.blue);
    
  }

  void _handleCreateAccount() {
    Navigator.push(context, MaterialPageRoute(builder: (_context) =>  ClientRegistrationPlatform()));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // منع الرجوع للخلف
      child: Scaffold(
        backgroundColor: AppColors.backgroundStart,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'auth.welcome_back'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'auth.sign_in_desc'.tr(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 48),
      
                    // Email Input
                    AppTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'auth.email'.tr(),
                      hintText: 'auth.email_hint'.tr(),
                    ),
                    const SizedBox(height: 24),
      
                    // Password Input
                    AppTextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      labelText: 'auth.password'.tr(),
                      hintText: 'auth.password_hint'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
      
                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24, height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() => _rememberMe = value ?? false);
                                },
                                fillColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) return AppColors.accentBlue;
                                  return const Color(0xFF161B22);
                                }),
                                side: const BorderSide(color: AppColors.borderPrimary, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'auth.remember_me'.tr(),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {}, // Forgot Password Logic
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(
                            'auth.forgot_pass'.tr(),
                            style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
      
                    // Login Button مع حالة الانتظار
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.accentBlue))
                        : AppPrimaryButton(
                            text: 'auth.sign_in'.tr(),
                            onPressed: _handleLogin,
                          ),
                    ),
                    const SizedBox(height: 24),
      
                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.borderPrimary, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('auth.or'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ),
                        const Expanded(child: Divider(color: AppColors.borderPrimary, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),
      
                    // Biometric Login Button
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        text: 'auth.login_face_id'.tr(),
                        onPressed: _handleBiometric,
                        icon: Icons.fingerprint,
                        isSecondary: true,
                      ),
                    ),
                    const SizedBox(height: 32),
      
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('auth.new_here'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        TextButton(
                          onPressed: _handleCreateAccount,
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(
                            'auth.create_account'.tr(),
                            style: const TextStyle(color: AppColors.accentBlue, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
      
                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'auth.terms'.tr(),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}