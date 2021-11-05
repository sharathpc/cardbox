import 'package:flutter/material.dart';

class CreditCardModel {
  CreditCardModel(
    this.cardTypeCodeId,
    this.cardColorCodeId,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.cardPin,
    this.isBackFocused,
  );

  int cardTypeCodeId;
  int cardColorCodeId;
  double? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  int? cvvCode;
  int? cardPin;
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

class GradientColorModel {
  GradientColorModel(
    this.gradientCodeId,
    this.gradientColors,
  );

  int gradientCodeId;
  List<Color> gradientColors;

  static List<GradientColorModel> gradientsList = [
    GradientColorModel(
      12001,
      [
        const Color(0xFF4AA3F2),
        const Color(0xFFAF92FB),
      ],
    ),
    GradientColorModel(
      12002,
      [
        Colors.amber,
        Colors.redAccent,
      ],
    ),
    GradientColorModel(
      12003,
      [
        Colors.grey,
        Colors.blueGrey,
      ],
    ),
    GradientColorModel(
      12004,
      [
        Colors.purple,
        Colors.indigo,
      ],
    ),
    GradientColorModel(
      12005,
      [
        Colors.cyan,
        Colors.green,
      ],
    ),
  ];
}
