/// A placeholder class that represents an entity or model.
class CardItem {
  final int id;
  final String bankName;
  int? accountNumber;
  String? ifsCode;
  int? cardTypeCodeId;
  int? cardNumber;
  String? cardExpiryDate;
  String? cardHolderName;
  int? cardCvvCode;
  int? cardPin;
  int? mobileNumber;
  int? mobilePin;
  String? internetId;
  String? internetPassword;
  String? internetProfilePassword;

  CardItem({
    required this.id,
    required this.bankName,
    this.accountNumber,
    this.ifsCode,
    this.cardTypeCodeId,
    this.cardNumber,
    this.cardExpiryDate,
    this.cardHolderName,
    this.cardCvvCode,
    this.cardPin,
    this.mobileNumber,
    this.mobilePin,
    this.internetId,
    this.internetPassword,
    this.internetProfilePassword,
  });

  /* CardItem.fromJson(Map<String, dynamic> json)
      : cardNumber = json['cardNumber'],
        expiryDate = json['expiryDate'],
        cardHolderName = json['cardHolderName'],
        cvvCode = json['cvvCode'];

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
      }; */
}
