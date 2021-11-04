import 'package:cardbox/src/databse_service.dart';

/// A placeholder class that represents an entity or model.
class GroupItem {
  late int groupId;
  late String groupName;
  late int bankCodeId;

  GroupItem({
    required this.groupId,
    required this.groupName,
    required this.bankCodeId,
  });

  GroupItem.fromJson(Map<String, dynamic> json) {
    groupId = json[DatabseService.columnGroupId];
    groupName = json[DatabseService.columnGroupName];
    bankCodeId = json[DatabseService.columnGroupBankCodeId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DatabseService.columnGroupId] = groupId;
    data[DatabseService.columnGroupName] = groupName;
    data[DatabseService.columnGroupBankCodeId] = bankCodeId;
    return data;
  }
}

class CardItem {
  late int cardId;
  late int cardTypeCodeId;
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
    required this.cardId,
    required this.cardTypeCodeId,
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
    cardId = json[DatabseService.columnCardId];
    cardTypeCodeId = json[DatabseService.columnCardTypeCodeId];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DatabseService.columnCardId] = cardId;
    data[DatabseService.columnCardTypeCodeId] = cardTypeCodeId;
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

class BankItem {
  late int bankCodeId;
  late String bankName;
  late String bankLogo;

  BankItem({
    required this.bankCodeId,
    required this.bankName,
    required this.bankLogo,
  });

  static List<BankItem> banksList = [
    BankItem(
      bankCodeId: 10001,
      bankName: 'HDFC Bank',
      bankLogo: 'assets/images/banks/hdfc-10001.png',
    ),
    BankItem(
      bankCodeId: 10002,
      bankName: 'ICICI Bank',
      bankLogo: 'assets/images/banks/icici-10002.png',
    ),
    BankItem(
      bankCodeId: 10003,
      bankName: 'Axis Bank',
      bankLogo: 'assets/images/banks/axis-10003.png',
    ),
    BankItem(
      bankCodeId: 10004,
      bankName: 'Citi Bank',
      bankLogo: 'assets/images/banks/citi-10004.png',
    ),
    BankItem(
      bankCodeId: 10005,
      bankName: 'YES Bank',
      bankLogo: 'assets/images/banks/yes-10005.png',
    ),
    BankItem(
      bankCodeId: 10006,
      bankName: 'State Bank of India',
      bankLogo: 'assets/images/banks/sbi-10006.png',
    ),
    BankItem(
      bankCodeId: 10007,
      bankName: 'Kotak Mahindra Bank',
      bankLogo: 'assets/images/banks/kotak-10007.png',
    ),
    BankItem(
      bankCodeId: 10008,
      bankName: 'Canara Bank',
      bankLogo: 'assets/images/banks/canara-10008.png',
    ),
    BankItem(
      bankCodeId: 10009,
      bankName: 'Andhra Bank',
      bankLogo: 'assets/images/banks/andhra-10009.png',
    ),
    BankItem(
      bankCodeId: 10010,
      bankName: 'Bank of Baroda',
      bankLogo: 'assets/images/banks/bob-10010.png',
    ),
    BankItem(
      bankCodeId: 10011,
      bankName: 'DBS Bank',
      bankLogo: 'assets/images/banks/dbs-10011.png',
    ),
    BankItem(
      bankCodeId: 10012,
      bankName: 'Punjab National Bank',
      bankLogo: 'assets/images/banks/pnb-10012.png',
    ),
    BankItem(
      bankCodeId: 10013,
      bankName: 'Syndicate Bank',
      bankLogo: 'assets/images/banks/syndicate-10013.png',
    ),
    BankItem(
      bankCodeId: 10014,
      bankName: 'IDBI Bank',
      bankLogo: 'assets/images/banks/idbi-10014.png',
    ),
    BankItem(
      bankCodeId: 10015,
      bankName: 'IDFC Bank',
      bankLogo: 'assets/images/banks/idfc-10015.png',
    ),
    BankItem(
      bankCodeId: 10016,
      bankName: 'Union Bank of India',
      bankLogo: 'assets/images/banks/union-10016.png',
    ),
    BankItem(
      bankCodeId: 10017,
      bankName: 'Corporation Bank',
      bankLogo: 'assets/images/banks/corporation-10017.png',
    ),
  ];

  /* BankItem.fromJson(Map<String, dynamic> json) {
    bankCodeId = json[DatabseService.columnGroupId];
    bankName = json[DatabseService.columnGroupName];
    bankLogo = json[DatabseService.columnGroupBankCodeId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DatabseService.columnGroupId] = groupId;
    data[DatabseService.columnGroupName] = groupName;
    data[DatabseService.columnGroupBankCodeId] = bankCodeId;
    return data;
  } */
}

class ManageCardModel {
  int bankCodeId;
  int? cardId;

  ManageCardModel({
    required this.bankCodeId,
    this.cardId,
  });
}
