import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/fake_transfer_datasource.dart';
import '../../data/models/beneficiary_model.dart';
import '../../data/models/country_model.dart';
import '../../data/models/fee_quote_model.dart';
import '../../data/models/receipt_model.dart';
import '../../data/repositories/transfer_repository_impl.dart';

final transferRepositoryProvider = Provider<TransferRepositoryImpl>((ref) {
  return TransferRepositoryImpl(FakeTransferDatasource());
});

final countriesProvider = FutureProvider<List<CountryModel>>((ref) {
  return ref.watch(transferRepositoryProvider).getCountries();
});

final beneficiariesProvider = FutureProvider<List<BeneficiaryModel>>((ref) {
  return ref.watch(transferRepositoryProvider).getBeneficiaries();
});

class TransferDraft {
  final String transferType;
  final CountryModel? sourceCountry;
  final BeneficiaryModel? beneficiary;
  final double amount;
  final FeeQuoteModel? quote;
  final ReceiptModel? receipt;

  const TransferDraft({
    this.transferType = 'send',
    this.sourceCountry,
    this.beneficiary,
    this.amount = 0,
    this.quote,
    this.receipt,
  });

  TransferDraft copyWith({
    String? transferType,
    CountryModel? sourceCountry,
    BeneficiaryModel? beneficiary,
    double? amount,
    FeeQuoteModel? quote,
    ReceiptModel? receipt,
  }) {
    return TransferDraft(
      transferType: transferType ?? this.transferType,
      sourceCountry: sourceCountry ?? this.sourceCountry,
      beneficiary: beneficiary ?? this.beneficiary,
      amount: amount ?? this.amount,
      quote: quote ?? this.quote,
      receipt: receipt ?? this.receipt,
    );
  }
}

class TransferDraftNotifier extends StateNotifier<TransferDraft> {
  TransferDraftNotifier(this.ref) : super(const TransferDraft());

  final Ref ref;

  void setType(String type) => state = state.copyWith(transferType: type);
  void setSourceCountry(CountryModel country) => state = state.copyWith(sourceCountry: country);
  void setBeneficiary(BeneficiaryModel beneficiary) => state = state.copyWith(beneficiary: beneficiary);

  Future<void> setAmount(double amount) async {
    final source = state.sourceCountry;
    final beneficiary = state.beneficiary;
    if (source == null || beneficiary == null) {
      state = state.copyWith(amount: amount);
      return;
    }
    final quote = await ref.read(transferRepositoryProvider).calculateFee(
      amount: amount,
      sourceCountry: source,
      destinationCountry: beneficiary.country,
    );
    state = state.copyWith(amount: amount, quote: quote);
  }

  Future<ReceiptModel> submit() async {
    final beneficiary = state.beneficiary;
    final source = state.sourceCountry;
    final quote = state.quote;
    if (beneficiary == null || source == null || quote == null) {
      throw StateError('Transfert incomplet');
    }
    final receipt = await ref.read(transferRepositoryProvider).submitTransfer(
      beneficiary: beneficiary,
      sourceCountry: source,
      quote: quote,
    );
    state = state.copyWith(receipt: receipt);
    return receipt;
  }
}

final transferDraftProvider = StateNotifierProvider<TransferDraftNotifier, TransferDraft>((ref) {
  return TransferDraftNotifier(ref);
});
