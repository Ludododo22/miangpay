import '../models/beneficiary_model.dart';
import '../models/country_model.dart';
import '../models/fee_quote_model.dart';
import '../models/operator_model.dart';
import '../models/receipt_model.dart';

class FakeTransferDatasource {
  static final List<BeneficiaryModel> _beneficiaries = [];

  static const countries = [
    CountryModel(
      code: 'BJ',
      name: 'Benin',
      flag: '\u{1F1E7}\u{1F1EF}',
      currency: 'XOF',
      phoneCode: '+229',
    ),
    CountryModel(
      code: 'GA',
      name: 'Gabon',
      flag: '\u{1F1EC}\u{1F1E6}',
      currency: 'XAF',
      phoneCode: '+241',
    ),
    CountryModel(
      code: 'CI',
      name: 'Cote d Ivoire',
      flag: '\u{1F1E8}\u{1F1EE}',
      currency: 'XOF',
      phoneCode: '+225',
    ),
    CountryModel(
      code: 'SN',
      name: 'Senegal',
      flag: '\u{1F1F8}\u{1F1F3}',
      currency: 'XOF',
      phoneCode: '+221',
    ),
    CountryModel(
      code: 'CM',
      name: 'Cameroun',
      flag: '\u{1F1E8}\u{1F1F2}',
      currency: 'XAF',
      phoneCode: '+237',
    ),
    CountryModel(
      code: 'TG',
      name: 'Togo',
      flag: '\u{1F1F9}\u{1F1EC}',
      currency: 'XOF',
      phoneCode: '+228',
    ),
    CountryModel(
      code: 'ML',
      name: 'Mali',
      flag: '\u{1F1F2}\u{1F1F1}',
      currency: 'XOF',
      phoneCode: '+223',
    ),
    CountryModel(
      code: 'BF',
      name: 'Burkina Faso',
      flag: '\u{1F1E7}\u{1F1EB}',
      currency: 'XOF',
      phoneCode: '+226',
    ),
    CountryModel(
      code: 'NE',
      name: 'Niger',
      flag: '\u{1F1F3}\u{1F1EA}',
      currency: 'XOF',
      phoneCode: '+227',
    ),
    CountryModel(
      code: 'CD',
      name: 'RDC',
      flag: '\u{1F1E8}\u{1F1E9}',
      currency: 'CDF',
      phoneCode: '+243',
    ),
  ];

  static const operators = [
    OperatorModel(
      id: 'mtn_bj',
      name: 'MTN Mobile Money',
      countryCode: 'BJ',
      serviceCode: 'MTN_BEN',
    ),
    OperatorModel(
      id: 'airtel_ga',
      name: 'Airtel Money',
      countryCode: 'GA',
      serviceCode: 'AIRTEL_GAB',
    ),
    OperatorModel(
      id: 'orange_ci',
      name: 'Orange Money',
      countryCode: 'CI',
      serviceCode: 'ORANGE_CI',
    ),
    OperatorModel(
      id: 'mtn_ci',
      name: 'MTN Mobile Money',
      countryCode: 'CI',
      serviceCode: 'MTN_CI',
    ),
    OperatorModel(
      id: 'orange_sn',
      name: 'Orange Money',
      countryCode: 'SN',
      serviceCode: 'ORANGE_SN',
    ),
    OperatorModel(
      id: 'free_sn',
      name: 'Free Money',
      countryCode: 'SN',
      serviceCode: 'FREE_SN',
    ),
    OperatorModel(
      id: 'orange_cm',
      name: 'Orange Money',
      countryCode: 'CM',
      serviceCode: 'ORANGE_CM',
    ),
    OperatorModel(
      id: 'mtn_cm',
      name: 'MTN Mobile Money',
      countryCode: 'CM',
      serviceCode: 'MTN_CM',
    ),
    OperatorModel(
      id: 'flooz_tg',
      name: 'Flooz',
      countryCode: 'TG',
      serviceCode: 'FLOOZ_TG',
    ),
    OperatorModel(
      id: 'tmoney_tg',
      name: 'T-Money',
      countryCode: 'TG',
      serviceCode: 'TMONEY_TG',
    ),
  ];

  Future<List<CountryModel>> getCountries() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return countries;
  }

  Future<List<OperatorModel>> getOperators(String countryCode) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return operators
        .where((operator) => operator.countryCode == countryCode)
        .toList();
  }

  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _ensureSeedBeneficiaries();
    return List<BeneficiaryModel>.unmodifiable(_beneficiaries);
  }

  Future<BeneficiaryModel> createBeneficiary({
    required String fullName,
    required String phone,
    required CountryModel country,
    required OperatorModel operator,
    required bool isFavorite,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _ensureSeedBeneficiaries();
    final beneficiary = BeneficiaryModel(
      id: 'b_custom_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      phone: phone,
      country: country,
      operator: operator,
      isFavorite: isFavorite,
      initials: _initials(fullName),
    );
    _beneficiaries.insert(0, beneficiary);
    return beneficiary;
  }

  Future<BeneficiaryModel> updateBeneficiary({
    required String id,
    required String fullName,
    required String phone,
    required CountryModel country,
    required OperatorModel operator,
    required bool isFavorite,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _ensureSeedBeneficiaries();
    final index = _beneficiaries.indexWhere((item) => item.id == id);
    if (index == -1) throw StateError('Beneficiaire introuvable');

    final beneficiary = _beneficiaries[index].copyWith(
      fullName: fullName,
      phone: phone,
      country: country,
      operator: operator,
      isFavorite: isFavorite,
      initials: _initials(fullName),
    );
    _beneficiaries[index] = beneficiary;
    return beneficiary;
  }

  Future<void> deleteBeneficiary(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _ensureSeedBeneficiaries();
    _beneficiaries.removeWhere((item) => item.id == id);
  }

  Future<BeneficiaryModel> toggleBeneficiaryFavorite(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _ensureSeedBeneficiaries();
    final index = _beneficiaries.indexWhere((item) => item.id == id);
    if (index == -1) throw StateError('Beneficiaire introuvable');

    final beneficiary = _beneficiaries[index].copyWith(
      isFavorite: !_beneficiaries[index].isFavorite,
    );
    _beneficiaries[index] = beneficiary;
    return beneficiary;
  }

  Future<FeeQuoteModel> calculateFee({
    required double amount,
    required CountryModel sourceCountry,
    required CountryModel destinationCountry,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final isIntraCountry = sourceCountry.code == destinationCountry.code;
    final percent = isIntraCountry ? 0.015 : 0.025;
    final rate =
        sourceCountry.currency == destinationCountry.currency ? 1.0 : 1.0;
    final fee = amount * percent;
    return FeeQuoteModel(
      amount: amount,
      fee: fee,
      exchangeRate: rate,
      receivedAmount: (amount - fee) * rate,
      sourceCurrency: sourceCountry.currency,
      destinationCurrency: destinationCountry.currency,
    );
  }

  Future<ReceiptModel> submitTransfer({
    required BeneficiaryModel beneficiary,
    required CountryModel sourceCountry,
    required FeeQuoteModel quote,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return ReceiptModel(
      reference: 'MP${DateTime.now().millisecondsSinceEpoch}',
      senderName: 'Jean Dupont',
      receiverName: beneficiary.fullName,
      corridor: '${sourceCountry.code} -> ${beneficiary.country.code}',
      operatorName: beneficiary.operator.name,
      amount: quote.amount,
      fee: quote.fee,
      receivedAmount: quote.receivedAmount,
      currency: quote.sourceCurrency,
      createdAt: DateTime.now(),
    );
  }

  void _ensureSeedBeneficiaries() {
    if (_beneficiaries.isNotEmpty) return;

    final bj = countries.firstWhere((c) => c.code == 'BJ');
    final ci = countries.firstWhere((c) => c.code == 'CI');
    final sn = countries.firstWhere((c) => c.code == 'SN');
    final cm = countries.firstWhere((c) => c.code == 'CM');
    final mtnBj = operators.firstWhere((o) => o.countryCode == 'BJ');
    final orangeCi = operators.firstWhere((o) => o.id == 'orange_ci');
    final orangeSn = operators.firstWhere((o) => o.id == 'orange_sn');
    final mtnCm = operators.firstWhere((o) => o.id == 'mtn_cm');

    _beneficiaries.addAll([
      BeneficiaryModel(
        id: 'b1',
        fullName: 'Ahmed Diallo',
        phone: '+229 61 23 45 67',
        country: bj,
        operator: mtnBj,
        isFavorite: true,
        initials: 'AD',
      ),
      BeneficiaryModel(
        id: 'b2',
        fullName: 'Fatou Koffi',
        phone: '+225 07 44 55 66',
        country: ci,
        operator: orangeCi,
        isFavorite: true,
        initials: 'FK',
      ),
      BeneficiaryModel(
        id: 'b3',
        fullName: 'Mamadou Ndiaye',
        phone: '+221 77 321 45 98',
        country: sn,
        operator: orangeSn,
        isFavorite: false,
        initials: 'MN',
      ),
      BeneficiaryModel(
        id: 'b4',
        fullName: 'Jean Fotso',
        phone: '+237 6 71 00 44 22',
        country: cm,
        operator: mtnCm,
        isFavorite: false,
        initials: 'JF',
      ),
    ]);
  }

  String _initials(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final value = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return value.isEmpty ? '?' : value;
  }
}
