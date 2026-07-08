import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/kyc/presentation/screens/kyc_address_screen.dart';
import '../../features/kyc/presentation/screens/kyc_document_screen.dart';
import '../../features/kyc/presentation/screens/kyc_intro_screen.dart';
import '../../features/kyc/presentation/screens/kyc_pending_screen.dart';
import '../../features/kyc/presentation/screens/kyc_personal_info_screen.dart';
import '../../features/kyc/presentation/screens/kyc_review_screen.dart';
import '../../features/kyc/presentation/screens/kyc_selfie_screen.dart';
import '../../features/beneficiaries/presentation/screens/beneficiaries_screen.dart';
import '../../features/beneficiaries/presentation/screens/beneficiary_detail_screen.dart';
import '../../features/beneficiaries/presentation/screens/add_beneficiary_screen.dart';
import '../../features/history/presentation/screens/transaction_detail_screen.dart';
import '../../features/history/presentation/screens/history_receipt_screen.dart';

import '../../features/cards/presentation/screens/cards_screen.dart';
import '../../features/cards/presentation/screens/card_detail_screen.dart';
import '../../features/cards/presentation/screens/create_card_screen.dart';
import '../../features/cards/presentation/screens/topup_card_screen.dart';
import '../../features/cards/presentation/screens/card_settings_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_tiers_screen.dart';
import '../../features/loyalty/presentation/screens/rewards_store_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_challenges_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_history_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_referral_screen.dart';
import '../../features/main/presentation/screens/main_navigation_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/messages_screen.dart';
import '../../features/notifications/presentation/screens/notification_settings_center_screen.dart';
import '../../features/onboarding/presentation/screens/country_selection_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/security_center_screen.dart';
import '../../features/profile/presentation/screens/mobile_money_accounts_screen.dart';
import '../../features/profile/presentation/screens/connected_devices_screen.dart';
import '../../features/profile/presentation/screens/security_log_screen.dart';
import '../../features/profile/presentation/screens/kyc_status_screen.dart';
import '../../features/profile/presentation/screens/preferences_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';
import '../../features/profile/presentation/screens/referral_screen.dart';
import '../../features/promotions/presentation/screens/promotions_screen.dart';
import '../../features/promotions/presentation/screens/promotion_detail_screen.dart';
import '../../features/promotions/presentation/screens/coupons_screen.dart';
import '../../features/promotions/presentation/screens/campaigns_screen.dart';
import '../../features/promotions/presentation/screens/savings_center_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/support/presentation/screens/faq_screen.dart';
import '../../features/support/presentation/screens/support_chat_screen.dart';
import '../../features/support/presentation/screens/support_tickets_screen.dart';
import '../../features/support/presentation/screens/new_ticket_screen.dart';
import '../../features/support/presentation/screens/contact_support_screen.dart';
import '../../features/kyc/presentation/screens/kyc_rejected_screen.dart';
import '../../features/system/presentation/screens/offline_screen.dart';
import '../../features/system/presentation/screens/maintenance_screen.dart';
import '../../features/system/presentation/screens/server_error_screen.dart';
import '../../features/system/presentation/screens/update_required_screen.dart';

import '../../features/transfer/presentation/screens/transfer_type_screen.dart';
import '../../features/transfer/presentation/screens/transfer_country_screen.dart';
import '../../features/transfer/presentation/screens/transfer_beneficiary_screen.dart';
import '../../features/transfer/presentation/screens/new_beneficiary_screen.dart';
import '../../features/transfer/presentation/screens/transfer_amount_screen.dart';
import '../../features/transfer/presentation/screens/transfer_summary_screen.dart';
import '../../features/transfer/presentation/screens/transfer_pin_screen.dart';
import '../../features/transfer/presentation/screens/transfer_processing_screen.dart';
import '../../features/transfer/presentation/screens/transfer_success_screen.dart';
import '../../features/transfer/presentation/screens/transfer_receipt_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/country-selection', builder: (_, __) => const CountrySelectionScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/otp', builder: (_, __) => const OtpScreen()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/kyc-intro', builder: (_, __) => const KycIntroScreen()),
      GoRoute(path: '/kyc-personal-info', builder: (_, __) => const KycPersonalInfoScreen()),
      GoRoute(path: '/kyc-address', builder: (_, __) => const KycAddressScreen()),
      GoRoute(path: '/kyc-document', builder: (_, __) => const KycDocumentScreen()),
      GoRoute(path: '/kyc-selfie', builder: (_, __) => const KycSelfieScreen()),
      GoRoute(path: '/kyc-review', builder: (_, __) => const KycReviewScreen()),
      GoRoute(path: '/kyc-pending', builder: (_, __) => const KycPendingScreen()),
      GoRoute(path: '/kyc-rejected', builder: (_, __) => const KycRejectedScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const MainNavigationScreen()),
      GoRoute(path: '/transfer', builder: (_, __) => const TransferTypeScreen()),
      GoRoute(path: '/transfer/countries', builder: (_, __) => const TransferCountryScreen()),
      GoRoute(path: '/transfer/beneficiary', builder: (_, __) => const TransferBeneficiaryScreen()),
      GoRoute(path: '/transfer/new-beneficiary', builder: (_, __) => const NewBeneficiaryScreen()),
      GoRoute(path: '/transfer/amount', builder: (_, __) => const TransferAmountScreen()),
      GoRoute(path: '/transfer/summary', builder: (_, __) => const TransferSummaryScreen()),
      GoRoute(path: '/transfer/pin', builder: (_, __) => const TransferPinScreen()),
      GoRoute(path: '/transfer/processing', builder: (_, __) => const TransferProcessingScreen()),
      GoRoute(path: '/transfer/success', builder: (_, __) => const TransferSuccessScreen()),
      GoRoute(path: '/transfer/receipt', builder: (_, __) => const TransferReceiptScreen()),
      GoRoute(path: '/beneficiaries', builder: (_, __) => const BeneficiariesScreen()),
      GoRoute(path: '/beneficiaries/new', builder: (_, __) => const AddBeneficiaryScreen()),
      GoRoute(
        path: '/beneficiaries/detail/:id',
        builder: (_, state) => BeneficiaryDetailScreen(beneficiaryId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(
        path: '/history/detail/:reference',
        builder: (_, state) => TransactionDetailScreen(reference: state.pathParameters['reference']!),
      ),
      GoRoute(
        path: '/history/receipt/:reference',
        builder: (_, state) => HistoryReceiptScreen(reference: state.pathParameters['reference']!),
      ),
      GoRoute(path: '/cards', builder: (_, __) => const CardsScreen()),
      GoRoute(path: '/cards/create', builder: (_, __) => const CreateCardScreen()),
      GoRoute(
        path: '/cards/detail/:id',
        builder: (_, state) => CardDetailScreen(cardId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/cards/topup/:id',
        builder: (_, state) => TopUpCardScreen(cardId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/cards/settings/:id',
        builder: (_, state) => CardSettingsScreen(cardId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/loyalty', builder: (_, __) => const LoyaltyScreen()),
      GoRoute(path: '/loyalty/tiers', builder: (_, __) => const LoyaltyTiersScreen()),
      GoRoute(path: '/loyalty/rewards', builder: (_, __) => const RewardsStoreScreen()),
      GoRoute(path: '/loyalty/challenges', builder: (_, __) => const LoyaltyChallengesScreen()),
      GoRoute(path: '/loyalty/history', builder: (_, __) => const LoyaltyHistoryScreen()),
      GoRoute(path: '/loyalty/referral', builder: (_, __) => const LoyaltyReferralScreen()),
      GoRoute(path: '/promotions', builder: (_, __) => const PromotionsScreen()),
      GoRoute(
        path: '/promotions/detail/:id',
        builder: (_, state) => PromotionDetailScreen(promotionId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/promotions/coupons', builder: (_, __) => const CouponsScreen()),
      GoRoute(path: '/promotions/campaigns', builder: (_, __) => const CampaignsScreen()),
      GoRoute(path: '/promotions/savings', builder: (_, __) => const SavingsCenterScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/notifications/messages', builder: (_, __) => const MessagesScreen()),
      GoRoute(path: '/notifications/settings', builder: (_, __) => const NotificationSettingsCenterScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/profile/edit', builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: '/profile/security', builder: (_, __) => const SecurityCenterScreen()),
      GoRoute(path: '/profile/mobile-money', builder: (_, __) => const MobileMoneyAccountsScreen()),
      GoRoute(path: '/profile/devices', builder: (_, __) => const ConnectedDevicesScreen()),
      GoRoute(path: '/profile/security-log', builder: (_, __) => const SecurityLogScreen()),
      GoRoute(path: '/profile/kyc-status', builder: (_, __) => const KycStatusScreen()),
      GoRoute(path: '/profile/preferences', builder: (_, __) => const PreferencesScreen()),
      GoRoute(path: '/profile/notifications-settings', builder: (_, __) => const NotificationSettingsScreen()),
      GoRoute(path: '/profile/referral', builder: (_, __) => const ReferralScreen()),
      GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
      GoRoute(path: '/support/faq', builder: (_, __) => const FaqScreen()),
      GoRoute(path: '/support/chat', builder: (_, __) => const SupportChatScreen()),
      GoRoute(path: '/support/tickets', builder: (_, __) => const SupportTicketsScreen()),
      GoRoute(path: '/support/new-ticket', builder: (_, __) => const NewTicketScreen()),
      GoRoute(path: '/support/contact', builder: (_, __) => const ContactSupportScreen()),
      GoRoute(path: '/system/offline', builder: (_, __) => const OfflineScreen()),
      GoRoute(path: '/system/maintenance', builder: (_, __) => const MaintenanceScreen()),
      GoRoute(path: '/system/server-error', builder: (_, __) => const ServerErrorScreen()),
      GoRoute(path: '/system/update-required', builder: (_, __) => const UpdateRequiredScreen()),
    ],
  );
}
