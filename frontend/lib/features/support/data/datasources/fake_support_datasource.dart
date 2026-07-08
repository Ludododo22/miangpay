import '../models/chat_message_model.dart';
import '../models/faq_item_model.dart';
import '../models/support_ticket_model.dart';

class FakeSupportDatasource {
  Future<List<FaqItemModel>> getFaqs() async {
    return const [
      FaqItemModel(
        id: 'faq_1',
        category: 'Transfert',
        question: 'Combien de temps prend un transfert ?',
        answer: 'La plupart des transferts sont traités en moins de 30 secondes. Certains opérateurs peuvent prendre quelques minutes selon leur disponibilité.',
      ),
      FaqItemModel(
        id: 'faq_2',
        category: 'KYC',
        question: 'Pourquoi dois-je vérifier mon identité ?',
        answer: 'La vérification KYC protège votre compte et permet de respecter les règles applicables aux services financiers.',
      ),
      FaqItemModel(
        id: 'faq_3',
        category: 'Cartes',
        question: 'Comment bloquer ma carte virtuelle ?',
        answer: 'Depuis Mes cartes, ouvrez le détail de la carte puis utilisez l’action Bloquer ou Gel temporaire.',
      ),
      FaqItemModel(
        id: 'faq_4',
        category: 'Sécurité',
        question: 'Que faire si je ne reconnais pas une connexion ?',
        answer: 'Ouvrez Profil > Sécurité > Appareils connectés, déconnectez l’appareil suspect puis changez votre PIN.',
      ),
    ];
  }

  Future<List<SupportTicketModel>> getTickets() async {
    return [
      SupportTicketModel(
        id: '#MP-4521',
        subject: 'Transfert en attente vers Ahmed',
        category: 'Transaction',
        status: 'En cours',
        lastMessage: 'Un conseiller vérifie le statut opérateur.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      SupportTicketModel(
        id: '#MP-4478',
        subject: 'Question sur les frais Gabon → Bénin',
        category: 'Frais',
        status: 'Résolu',
        lastMessage: 'Les frais dépendent du corridor et de votre niveau fidélité.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<List<ChatMessageModel>> getChatMessages() async {
    return [
      ChatMessageModel(id: '1', message: 'Bonjour, je suis l’assistant MiangPay. Comment puis-je vous aider ?', fromUser: false, sentAt: DateTime.now().subtract(const Duration(minutes: 8))),
      ChatMessageModel(id: '2', message: 'Je veux suivre un transfert.', fromUser: true, sentAt: DateTime.now().subtract(const Duration(minutes: 7))),
      ChatMessageModel(id: '3', message: 'Bien sûr. Ouvrez Activités puis sélectionnez la transaction concernée pour voir la timeline.', fromUser: false, sentAt: DateTime.now().subtract(const Duration(minutes: 6))),
    ];
  }
}
