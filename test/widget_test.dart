//// Import the test package and Counter class
//import 'package:test/test.dart';
////import 'package:counter_app/counter.dart';
//
//void main() {
//  group('Login', () {
//    test('valid user', () {
//      //expect(Counter().value, 0);
//    });
//
//    test('invalid user', () {
//      //final counter = Counter();
//
//      //counter.increment();
//
//      //expect(counter.value, 1);
//    });
//
//    test('value should be decremented', () {
//      //final counter = Counter();
//
//      //counter.decrement();
//
//      //expect(counter.value, -1);
//    });
//  });
//}
import 'package:plant_vibez/pages/LoginPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('empty email returns error string', () {

    final result = EmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('non-empty email returns null', () {

    final result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {

    final result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {

    final result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}