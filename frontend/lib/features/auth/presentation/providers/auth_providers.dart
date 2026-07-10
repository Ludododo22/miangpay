import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/repositories/auth_api_repository.dart';

final authApiRepositoryProvider = Provider<AuthApiRepository>((ref) {
  return AuthApiRepository(ref.watch(apiClientProvider));
});
