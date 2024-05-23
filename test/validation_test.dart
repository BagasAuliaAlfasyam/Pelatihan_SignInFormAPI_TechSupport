import 'package:flutter_test/flutter_test.dart';
import 'package:pelatihan_jagoit_1/validator/email_validator.dart';
import 'package:pelatihan_jagoit_1/validator/password_validator.dart';

void main() {
  group("Email Validation", () {
    test("Empty Email", () {
      expect(validateEmail(""), 'Email is Required');
    });

    test("Null Email", () {
      expect(validateEmail(null), 'Email is Required');
    });

    test("Invalid Email Format", () {
      expect(
          validateEmail("invalidemail"), 'Please enter a valid email address');
      expect(validateEmail("invalid@domain"),
          'Please enter a valid email address');
      expect(
          validateEmail("@domain.com"), 'Please enter a valid email address');
    });

    test("Valid Email", () {
      expect(validateEmail("test@example.com"), null);
    });
  });

  group("Password Validation", () {
    test("Empty Password", () {
      expect(validatePassword(""), 'Password is Required');
    });

    test("Null Password", () {
      expect(validatePassword(null), 'Password is Required');
    });

    test("Password less than 8 characters", () {
      expect(
          validatePassword("Pass1!"), 'Password must be at least 8 characters');
    });

    test("Password without uppercase letter", () {
      expect(validatePassword("password1!"),
          'Password must contain at least one uppercase letter');
    });

    test("Password without lowercase letter", () {
      expect(validatePassword("PASSWORD1!"),
          'Password must contain at least one lowercase letter');
    });

    test("Password without number", () {
      expect(validatePassword("Password!"),
          'Password must contain at least one number');
    });

    test("Password without special character", () {
      expect(validatePassword("Password1"),
          'Password must contain at least one special character');
    });

    test("Valid Password", () {
      expect(validatePassword("Password1!"), null);
    });
  });
}
