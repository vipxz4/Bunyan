import 'package:firebase_auth/firebase_auth.dart';

String handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'صيغة البريد الإلكتروني غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.';
    case 'user-not-found':
      return 'عذراً، لم نتمكن من العثور على حساب بهذا البريد الإلكتروني.';
    case 'wrong-password':
      return 'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';
    case 'email-already-in-use':
      return 'هذا البريد الإلكتروني مسجل لدينا بالفعل. هل تريد تسجيل الدخول؟';
    case 'weak-password':
      return 'كلمة المرور ضعيفة جدًا. يرجى اختيار كلمة مرور أقوى.';
    case 'user-disabled':
      return 'تم تعطيل هذا الحساب. يرجى التواصل مع الدعم الفني.';
    case 'too-many-requests':
      return 'لقد حاولت تسجيل الدخول عدة مرات. يرجى المحاولة مرة أخرى لاحقاً.';
    case 'network-request-failed':
      return 'حدث خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';
    default:
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }
}
