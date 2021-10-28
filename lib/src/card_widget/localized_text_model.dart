class LocalizedText {
  const LocalizedText({
    this.cardTypeLabel = _cardTypeLabelDefault,
    this.cardTypeHint = _cardTypeHintDefault,
    this.cardNumberLabel = _cardNumberLabelDefault,
    this.cardNumberHint = _cardNumberHintDefault,
    this.expiryDateLabel = _expiryDateLabelDefault,
    this.expiryDateHint = _expiryDateHintDefault,
    this.cvvLabel = _cvvLabelDefault,
    this.cvvHint = _cvvHintDefault,
    this.cardPinLabel = _cardPinLabelDefault,
    this.cardPinHint = _cardPinHintDefault,
    this.cardHolderLabel = _cardHolderLabelDefault,
    this.cardHolderHint = _cardHolderHintDefault,
  });

  static const String _cardTypeLabelDefault = 'Card Type';
  static const String _cardTypeHintDefault = '';
  static const String _cardNumberLabelDefault = 'Card number';
  static const String _cardNumberHintDefault = 'xxxx xxxx xxxx xxxx';
  static const String _expiryDateLabelDefault = 'Expiry Date';
  static const String _expiryDateHintDefault = 'MM/YY';
  static const String _cvvLabelDefault = 'CVV';
  static const String _cvvHintDefault = 'XXXX';
  static const String _cardPinLabelDefault = 'Card Pin';
  static const String _cardPinHintDefault = 'XXXX';
  static const String _cardHolderLabelDefault = 'Card Holder';
  static const String _cardHolderHintDefault = '';

  final String cardTypeLabel;
  final String cardTypeHint;
  final String cardNumberLabel;
  final String cardNumberHint;
  final String expiryDateLabel;
  final String expiryDateHint;
  final String cvvLabel;
  final String cvvHint;
  final String cardPinLabel;
  final String cardPinHint;
  final String cardHolderLabel;
  final String cardHolderHint;
}
