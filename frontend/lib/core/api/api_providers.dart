import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

enum DataSourceMode { fake, api }

final dataSourceModeProvider = Provider<DataSourceMode>((ref) {
  const mode = String.fromEnvironment(
    'MIANGPAY_DATA_SOURCE',
    defaultValue: 'fake',
  );
  return mode.toLowerCase() == 'api' ? DataSourceMode.api : DataSourceMode.fake;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
