import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:user_onboarding/helpers/API/dioInstance.dart';
import 'package:user_onboarding/models/models.dart';

void main() {
  group('dioInstance', () {
    DioInstance dioInstance = DioInstance();
    test('accessToken to be empty', () async {
      expect(await dioInstance.accessToken, '');
    });
    test('accessToken to be dummyToken', () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', 'dummyToken');
      expect(await dioInstance.accessToken, 'dummyToken');
      await prefs.clear();
    });

    group('errorHelper', () {
      test('should return Network Error', () {
        DIOResponseBody response = dioInstance.errorHelper(null);
        expect(response.data, 'Network Error');
      });
      test('should return error message', () {
        Map<dynamic, dynamic> payload = {
          'response': {
            'data': {
              'message': 'error message',
            }
          }
        };
        DIOResponseBody response = dioInstance.errorHelper(payload);
        expect(response.data, 'error message');
      });
    });
  });
}
