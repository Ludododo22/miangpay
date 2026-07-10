class ApiJson {
  const ApiJson._();

  static List<Map<String, dynamic>> dataList(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return const [];
  }

  static Map<String, dynamic> dataMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  static List<Map<String, dynamic>> list(
      Map<String, dynamic> json, String key) {
    final data = json[key];
    if (data is List) {
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return const [];
  }

  static String string(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString();
    return text.isEmpty ? fallback : text;
  }

  static double decimal(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int integer(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool boolean(Object? value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return switch (value.toLowerCase()) {
        'true' || '1' || 'yes' => true,
        'false' || '0' || 'no' => false,
        _ => fallback,
      };
    }
    return fallback;
  }

  static DateTime date(Object? value) {
    return DateTime.tryParse(string(value)) ?? DateTime.now();
  }
}
