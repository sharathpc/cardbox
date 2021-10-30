class CreditCardModel {
  CreditCardModel(
    this.cardType,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.cardPin,
    this.isBackFocused,
  );

  String cardType = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isBackFocused = false;
}
