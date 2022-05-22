import 'package:test/test.dart';
import 'package:user_onboarding/helpers/helpers.dart';

void main() {
  group('TextHelper', () {
    final textHelper = TextHelper();
    test('should return false if invalid email is passed', () {
      expect(textHelper.validateEmail("1232345"), false);
    });
    test('should return true if valid email is passed', () {
      expect(textHelper.validateEmail("test@mail.com"), true);
    });
  });
}
