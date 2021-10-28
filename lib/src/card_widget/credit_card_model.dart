class CreditCardModel {
  CreditCardModel(
    this.cardType,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.cardPin,
    this.isCvvFocused,
  );

  String cardType = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isCvvFocused = false;
}
