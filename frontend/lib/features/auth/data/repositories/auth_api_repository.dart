import '../../../../core/api/api_client.dart';

class AuthApiRepository {
  const AuthApiRepository(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    required String country,
    required String operator,
    required String password,
  }) async {
    final response = await _client.postJson(
      '/auth/register',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'country': country,
        'operator': operator,
        'password': password,
      },
    );
    _client.setBearerToken(response['token']?.toString());
    return response;
  }

  Future<Map<String, dynamic>> login(
      {required String phone, required String password}) async {
    final response = await _client.postJson(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    );
    _client.setBearerToken(response['token']?.toString());
    return response;
  }

  Future<Map<String, dynamic>> verifyOtp(
      {required String phone, required String code}) {
    return _client.postJson(
      '/auth/verify-otp',
      data: {
        'phone': phone,
        'code': code,
      },
    );
  }
}
