abstract final class AppValidators {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  static String? requiredText(
    String? value, {
    required String fieldName,
    int minimumLength = 1,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$fieldName is required';
    if (text.length < minimumLength) {
      return '$fieldName must be at least $minimumLength characters';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(text)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? strongPassword(String? value) {
    final basicError = AppValidators.password(value);
    if (basicError != null) return basicError;
    final passwordValue = value!;
    if (!RegExp(r'[A-Z]').hasMatch(passwordValue) ||
        !RegExp(r'[a-z]').hasMatch(passwordValue) ||
        !RegExp(r'[0-9]').hasMatch(passwordValue) ||
        !RegExp(r'[^A-Za-z0-9]').hasMatch(passwordValue)) {
      return 'Use uppercase, lowercase, a number, and a symbol';
    }
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
