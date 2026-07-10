class FormValidators {
  const FormValidators._();

  static String? required(String? value,
      {String message = 'Champ obligatoire'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? phone(String? value) {
    final normalized = value?.replaceAll(RegExp(r'[\s-]'), '') ?? '';
    if (normalized.isEmpty) return 'Numéro obligatoire';
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalized)) {
      return 'Numéro invalide';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Mot de passe obligatoire';
    if (text.length < 6) return 'Minimum 6 caractères';
    return null;
  }
}
