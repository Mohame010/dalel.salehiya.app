class Validators {

  static String? phone(String value) {
    if (value.isEmpty) return "Phone is required";
    if (value.length < 10) return "Invalid phone number";
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }

  static String? name(String value) {
    if (value.isEmpty) return "Name is required";
    return null;
  }
}