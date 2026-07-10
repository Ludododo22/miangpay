class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'MIANGPAY_API_BASE_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );

  static const timeout = Duration(seconds: 20);
}
