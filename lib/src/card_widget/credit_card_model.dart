class CreditCardModel {
  CreditCardModel(
    this.cardTypeCodeId,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.cardPin,
    this.isBackFocused,
  );

  int cardTypeCodeId;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isBackFocused = false;
}

class CardTypeModel {
  CardTypeModel(
    this.cardTypeCodeId,
    this.cardTypeName,
  );

  int cardTypeCodeId;
  String cardTypeName;

  static List<CardTypeModel> cardTypesList = [
    CardTypeModel(11001, 'Bank Card'),
    CardTypeModel(11002, 'Debit Card'),
    CardTypeModel(11003, 'Credit Card'),
    CardTypeModel(11004, 'Mobile Card'),
    CardTypeModel(11005, 'Internet Card'),
  ];
}
