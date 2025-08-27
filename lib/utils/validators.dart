class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني.';
    }
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور.';
    }
    if (value.length < 8) {
      return 'يجب أن لا تقل كلمة المرور عن 8 أحرف.';
    }
    return null;
  }

  static String? validateYemeniPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف.';
    }
    // Regex for Yemeni phone numbers (mobile + landline)
    final phoneRegex = RegExp(
        r'^(((\+|00)9677|0?7)[01378]\d{7}|((\+|00)967|0)[1-7]\d{6})$');
    if (!phoneRegex.hasMatch(value)) {
      return 'صيغة رقم الهاتف اليمني غير صحيحة.';
    }
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName.';
    }
    return null;
  }
}
