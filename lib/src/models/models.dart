import 'package:cardbox/src/databse_service.dart';

/// A placeholder class that represents an entity or model.
class CardItem {
  int? id;
  String? bankName;
  int? accountNumber;
  String? ifsCode;
  String? cardType;
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
    this.cardType,
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

  CardItem.fromJson(Map<String, dynamic> json) {
    id = json[DatabseService.columnId];
    bankName = json[DatabseService.columnBankName];
    accountNumber = json[DatabseService.columnAccountNumber];
    ifsCode = json[DatabseService.columnIFSCode];
    cardType = json[DatabseService.columnCardType];
    cardNumber = json[DatabseService.columnCardNumber];
    cardExpiryDate = json[DatabseService.columnCardExpiryDate];
    cardHolderName = json[DatabseService.columnCardHolderName];
    cardCvvCode = json[DatabseService.columnCardCvvCode];
    cardPin = json[DatabseService.columnCardPin];
    mobileNumber = json[DatabseService.columnMobileNumber];
    mobilePin = json[DatabseService.columnMobilePin];
    internetId = json[DatabseService.columnInternetId];
    internetPassword = json[DatabseService.columnInternetPassword];
    internetProfilePassword =
        json[DatabseService.columnInternetProfilePassword];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DatabseService.columnId] = id;
    data[DatabseService.columnBankName] = bankName;
    data[DatabseService.columnAccountNumber] = accountNumber;
    data[DatabseService.columnIFSCode] = ifsCode;
    data[DatabseService.columnCardType] = cardType;
    data[DatabseService.columnCardNumber] = cardNumber;
    data[DatabseService.columnCardExpiryDate] = cardExpiryDate;
    data[DatabseService.columnCardHolderName] = cardHolderName;
    data[DatabseService.columnCardCvvCode] = cardCvvCode;
    data[DatabseService.columnCardPin] = cardPin;
    data[DatabseService.columnMobileNumber] = mobileNumber;
    data[DatabseService.columnMobilePin] = mobilePin;
    data[DatabseService.columnInternetId] = internetId;
    data[DatabseService.columnInternetPassword] = internetPassword;
    data[DatabseService.columnInternetProfilePassword] =
        internetProfilePassword;
    return data;
  }
}
