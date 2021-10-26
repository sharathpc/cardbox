/// A placeholder class that represents an entity or model.
class CardItem {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  const CardItem(
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
  );

  CardItem.fromJson(Map<String, dynamic> json)
      : cardNumber = json['cardNumber'],
        expiryDate = json['expiryDate'],
        cardHolderName = json['cardHolderName'],
        cvvCode = json['cvvCode'];

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
      };
}
