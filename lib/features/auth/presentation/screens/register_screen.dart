import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:s_report_system/features/auth/data/models/user_registration_model.dart';
import 'package:s_report_system/features/auth/presentation/screens/verification_dialog_screen.dart';



// --- 2. شاشة التسجيل الأساسية ---
class ClientRegistrationPlatform extends StatefulWidget {
  @override
  _ClientRegistrationPlatformState createState() => _ClientRegistrationPlatformState();
}

class _ClientRegistrationPlatformState extends State<ClientRegistrationPlatform> {
  final _formKey = GlobalKey<FormState>();

  // وحدات التحكم
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isVolunteer = false;
  String _selectedGender = "male";
  int _selectedCityId = 1;

  final Color bgColor = const Color(0xFF12151C);
  final Color fieldColor = const Color(0xFF1D2128);
  final Color accentColor = const Color(0xFF00B4D8);
  Future<void> _registerToApi() async {
  try {
    final response = await http.post(
      Uri.parse('https://abdallahnasrat-001-site1.anytempurl.com/api/Auth/LogUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nationalId': _nationalIdController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'secondName': _secondNameController.text.trim(),
        'homeAddress': _addressController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': _selectedGender,
        'birthdate': DateTime.now().toIso8601String(),
        'volunteer': _isVolunteer,
        'cityId': _selectedCityId,
      }),
    );
    debugPrint('API Register: ${response.statusCode} - ${response.body}');
     if (response.statusCode == 200) {
      final apiData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', apiData['userId'] ?? 0);
      await prefs.setString('firstName', apiData['firstName'] ?? '');
      await prefs.setString('role', apiData['role'] ?? '');
      await prefs.setInt('cityId', apiData['cityId'] ?? 0);
      debugPrint('✅ userId saved: ${apiData['userId']}');
    }


  } catch (e) {
    debugPrint('API Register Error: $e');
  }
}


  // --- دالة التسجيل الفوري (Firebase) ---
  Future<void> _registerImmediately() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1. فحص هل الرقم القومي موجود مسبقاً في Firestore
      final checkNationalId = await FirebaseFirestore.instance
          .collection('users')
          .where('nationalId', isEqualTo: _nationalIdController.text.trim())
          .get();

      if (checkNationalId.docs.isNotEmpty) {
        throw 'عذراً، هذا الرقم القومي مسجل بحساب آخر بالفعل.';
      }

      // 2. إنشاء الحساب في Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // 3. إرسال رابط تفعيل الإيميل فوراً
        await user.sendEmailVerification();

        // 4. حفظ البيانات باستخدام الموديل في Firestore
        UserRegistrationModel userData = UserRegistrationModel(
          nationalId: _nationalIdController.text.trim(),
          firstName: _firstNameController.text.trim(),
          secondName: _secondNameController.text.trim(),
          homeAddress: _addressController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          gender: _selectedGender,
          birthdate: DateTime.now().toIso8601String(),
          volunteer: _isVolunteer,
          cityId: _selectedCityId,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData.toJson());

            await _registerToApi();

            await FirebaseAuth.instance.signOut();

        // 5. التوجيه لصفحة التفعيل (التي تم برمجتها سابقاً)
        if (mounted) {
          // تأكد أنك قمت بعمل import لصفحة VerificationScreen
    Navigator.push(context, MaterialPageRoute(builder: (_context) =>  VerificationScreen(userEmail: _emailController.text,)));
        }
      }
    } on FirebaseAuthException catch (e) {
      String msg = "حدث خطأ أثناء التسجيل";
      if (e.code == 'email-already-in-use') msg = "هذا البريد مسجل بالفعل";
      if (e.code == 'weak-password') msg = "كلمة المرور ضعيفة جداً";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.orange[900]));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('تسجيل حساب جديد'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField(controller: _secondNameController, hintText: 'الاسم الثاني', icon: Icons.person_outline)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(controller: _firstNameController, hintText: 'الاسم الأول', icon: Icons.person)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(controller: _nationalIdController, hintText: 'الرقم القومي', icon: Icons.credit_card, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(controller: _emailController, hintText: 'البريد الإلكتروني', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(controller: _addressController, hintText: 'عنوان السكن', icon: Icons.home_outlined),
                const SizedBox(height: 16),
                _buildTextField(controller: _phoneController, hintText: 'رقم الهاتف', icon: Icons.phone_android, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                
               DropdownButtonFormField<int>(
  value: _selectedCityId,
  dropdownColor: fieldColor,
  style: const TextStyle(color: Colors.white),
  decoration: _inputDecoration('المحافظة', Icons.location_city),
  items: const [
    DropdownMenuItem(value: 1,  child: Text('القاهرة')),
    DropdownMenuItem(value: 2,  child: Text('الجيزة')),
    DropdownMenuItem(value: 3,  child: Text('الإسكندرية')),
    DropdownMenuItem(value: 4,  child: Text('الدقهلية')),
    DropdownMenuItem(value: 5,  child: Text('البحر الأحمر')),
    DropdownMenuItem(value: 6,  child: Text('البحيرة')),
    DropdownMenuItem(value: 7,  child: Text('الفيوم')),
    DropdownMenuItem(value: 8,  child: Text('الغربية')),
    DropdownMenuItem(value: 9,  child: Text('الإسماعيلية')),
    DropdownMenuItem(value: 10, child: Text('المنوفية')),
    DropdownMenuItem(value: 11, child: Text('المنيا')),
    DropdownMenuItem(value: 12, child: Text('القليوبية')),
    DropdownMenuItem(value: 13, child: Text('الوادي الجديد')),
    DropdownMenuItem(value: 14, child: Text('الشرقية')),
    DropdownMenuItem(value: 15, child: Text('السويس')),
    DropdownMenuItem(value: 16, child: Text('أسوان')),
    DropdownMenuItem(value: 17, child: Text('أسيوط')),
    DropdownMenuItem(value: 18, child: Text('بني سويف')),
    DropdownMenuItem(value: 19, child: Text('بورسعيد')),
    DropdownMenuItem(value: 20, child: Text('دمياط')),
    DropdownMenuItem(value: 21, child: Text('الشرقية - شركيا')),
    DropdownMenuItem(value: 22, child: Text('جنوب سيناء')),
    DropdownMenuItem(value: 23, child: Text('كفر الشيخ')),
    DropdownMenuItem(value: 24, child: Text('مطروح')),
    DropdownMenuItem(value: 25, child: Text('الأقصر')),
    DropdownMenuItem(value: 26, child: Text('قنا')),
    DropdownMenuItem(value: 27, child: Text('شمال سيناء')),
    DropdownMenuItem(value: 29, child: Text('سوهاج')),
  ],
  onChanged: (val) => setState(() => _selectedCityId = val!),
),
                const SizedBox(height: 20),

                // النوع
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('أنثى', style: TextStyle(color: Colors.white)),
                    Radio<String>(value: "female", groupValue: _selectedGender, activeColor: accentColor, onChanged: (v) => setState(() => _selectedGender = v!)),
                    const SizedBox(width: 20),
                    const Text('ذكر', style: TextStyle(color: Colors.white)),
                    Radio<String>(value: "male", groupValue: _selectedGender, activeColor: accentColor, onChanged: (v) => setState(() => _selectedGender = v!)),
                  ],
                ),

                const SizedBox(height: 16),
                _buildTextField(controller: _passwordController, hintText: 'كلمة المرور', icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 16),
                _buildTextField(controller: _confirmPasswordController, hintText: 'تأكيد كلمة المرور', icon: Icons.lock_reset, isPassword: true),
                const SizedBox(height: 10),

                SwitchListTile(
                  title: const Text('الرغبة في التطوع', style: TextStyle(color: Colors.white, fontSize: 14)),
                  value: _isVolunteer,
                  activeColor: accentColor,
                  onChanged: (val) => setState(() => _isVolunteer = val),
                ),

                const SizedBox(height: 30),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _registerImmediately,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('إنشاء الحساب وتفعيل البريد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: fieldColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hintText, icon),
      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
    );
  }
}