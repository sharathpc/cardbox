import 'package:flutter/material.dart';

class CreditCardModel {
  CreditCardModel(
    this.cardTypeCodeId,
    this.cardColorCodeId,
    this.accountName,
    this.accountNumber,
    this.ifsCode,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.cardPin,
    this.mobileNumber,
    this.mobilePin,
    this.upiId,
    this.upiPin,
    this.internetId,
    this.internetUsername,
    this.internetPassword,
    this.internetProfilePassword,
    this.isBackFocused,
  );

  int cardTypeCodeId;
  int cardColorCodeId;
  String? accountName;
  int? accountNumber;
  String? ifsCode;
  int? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  String? cardPin;
  int? mobileNumber;
  String? mobilePin;
  String? upiId;
  String? upiPin;
  String? internetId;
  String? internetUsername;
  String? internetPassword;
  String? internetProfilePassword;
  bool isBackFocused = false;
}

class CardTypeModel {
  CardTypeModel(
    this.cardTypeCodeId,
    this.cardTypeName,
    this.cardColorCodeId,
  );

  int cardTypeCodeId;
  String cardTypeName;
  int cardColorCodeId;

  static List<CardTypeModel> cardTypesList = [
    CardTypeModel(11001, 'Bank Card', 12001),
    CardTypeModel(11002, 'Debit Card', 12002),
    CardTypeModel(11003, 'Credit Card', 12002),
    CardTypeModel(11004, 'Mobile Card', 12003),
    CardTypeModel(11005, 'Internet Card', 12004),
    CardTypeModel(11006, 'UPI Card', 12005),
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
        Colors.grey,
        Colors.blueGrey,
      ],
    ),
    GradientColorModel(
      12003,
      [
        Colors.purple.shade300,
        Colors.indigo.shade300,
      ],
    ),
    GradientColorModel(
      12004,
      [
        Colors.green.shade300,
        Colors.blue.shade300,
      ],
    ),
    GradientColorModel(
      12005,
      [
        Colors.indigo.shade300,
        Colors.pink.shade200,
      ],
    ),
  ];
}
