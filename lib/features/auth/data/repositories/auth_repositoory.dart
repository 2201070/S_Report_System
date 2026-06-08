import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_registration_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register(UserRegistrationModel userData, String password) async {
    final check = await _firestore
        .collection("users")
        .where("nationalId", isEqualTo: userData.nationalId)
        .get();

    if (check.docs.isNotEmpty) {
      throw Exception("الرقم القومي مستخدم بالفعل");
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: userData.email,
      password: password,
    );

    await credential.user!.sendEmailVerification();

    await _firestore
        .collection("users")
        .doc(credential.user!.uid)
        .set(userData.toJson());
  }
}