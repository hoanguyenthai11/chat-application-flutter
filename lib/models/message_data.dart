class MessageData {
  final String senderName;
  final String messages;
  final DateTime messagesDate;
  final String dateMessage;
  final String profilePath;

  MessageData(
      {required this.senderName,
      required this.messages,
      required this.messagesDate,
      required this.dateMessage,
      required this.profilePath});
}
