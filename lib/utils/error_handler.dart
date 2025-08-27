import 'package:firebase_auth/firebase_auth.dart';

String handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'weak-password':
      return 'كلمة المرور ضعيفة جداً.';
    case 'email-already-in-use':
      return 'هذا البريد الإلكتروني مستخدم بالفعل.';
    case 'user-not-found':
      return 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';
    case 'wrong-password':
      return 'كلمة المرور غير صحيحة.';
    case 'invalid-email':
      return 'البريد الإلكتروني غير صالح.';
    default:
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }
}
