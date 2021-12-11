import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../card_widget/credit_card_form.dart';
import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';
import '../group_list/group_list_view.dart';

class ManageCardView extends StatefulWidget {
  const ManageCardView({
    Key? key,
    required this.bankCodeId,
    this.groupId,
    this.cardId,
  }) : super(key: key);

  static const routeName = '/add_card';
  final int bankCodeId;
  final int? groupId;
  final int? cardId;

  @override
  State<ManageCardView> createState() => _ManageCardViewState();
}

class _ManageCardViewState extends State<ManageCardView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future getCardFuture;
  late BankItem bank;
  CardItem cardItem = CardItem(cardTypeCodeId: 11001, cardColorCodeId: 12001);
  bool isBackFocused = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    bank = BankItem.banksList
        .firstWhere((item) => item.bankCodeId == widget.bankCodeId);
    cardItem.cardId = widget.cardId;
    cardItem.cardGroupId = widget.groupId;
    isEdit = cardItem.cardId != null;
    getCardFuture = getAndPopulateCard();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text('${isEdit ? 'Edit' : 'Add'} Card'),
        trailing: TextButton(
          child: const Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final cardData = {
                DatabseService.columnCardId: cardItem.cardId,
                DatabseService.columnCardGroupId: cardItem.cardGroupId,
                DatabseService.columnCardTypeCodeId: cardItem.cardTypeCodeId,
                DatabseService.columnCardColorCodeId: cardItem.cardColorCodeId,
                DatabseService.columnAccountName:
                    cardItem.cardTypeCodeId == 11001
                        ? cardItem.accountName
                        : null,
                DatabseService.columnAccountNumber:
                    cardItem.cardTypeCodeId == 11001
                        ? cardItem.accountNumber
                        : null,
                DatabseService.columnIFSCode:
                    cardItem.cardTypeCodeId == 11001 ? cardItem.ifsCode : null,
                DatabseService.columnCardNumber:
                    (cardItem.cardTypeCodeId == 11001 ||
                            cardItem.cardTypeCodeId == 11002)
                        ? cardItem.cardNumber
                        : null,
                DatabseService.columnCardExpiryDate:
                    (cardItem.cardTypeCodeId == 11001 ||
                            cardItem.cardTypeCodeId == 11002)
                        ? cardItem.cardExpiryDate
                        : null,
                DatabseService.columnCardHolderName:
                    (cardItem.cardTypeCodeId == 11001 ||
                            cardItem.cardTypeCodeId == 11002)
                        ? cardItem.cardHolderName
                        : null,
                DatabseService.columnCardCvvCode:
                    (cardItem.cardTypeCodeId == 11001 ||
                            cardItem.cardTypeCodeId == 11002)
                        ? cardItem.cardCvvCode
                        : null,
                DatabseService.columnCardPin:
                    (cardItem.cardTypeCodeId == 11001 ||
                            cardItem.cardTypeCodeId == 11002)
                        ? cardItem.cardPin
                        : null,
                DatabseService.columnMobileNumber:
                    cardItem.cardTypeCodeId == 11004
                        ? cardItem.mobileNumber
                        : null,
                DatabseService.columnMobilePin: cardItem.cardTypeCodeId == 11004
                    ? cardItem.mobilePin
                    : null,
                DatabseService.columnInternetId:
                    cardItem.cardTypeCodeId == 11005
                        ? cardItem.internetId
                        : null,
                DatabseService.columnInternetUsername:
                    cardItem.cardTypeCodeId == 11005
                        ? cardItem.internetUsername
                        : null,
                DatabseService.columnInternetPassword:
                    cardItem.cardTypeCodeId == 11005
                        ? cardItem.internetPassword
                        : null,
                DatabseService.columnInternetProfilePassword:
                    cardItem.cardTypeCodeId == 11005
                        ? cardItem.internetProfilePassword
                        : null,
                DatabseService.columnUpiId:
                    cardItem.cardTypeCodeId == 11006 ? cardItem.upiId : null,
                DatabseService.columnUpiPin:
                    cardItem.cardTypeCodeId == 11006 ? cardItem.upiPin : null,
              };
              if (isEdit) {
                await DatabseService.instance.updateCard(cardData);
              } else {
                cardItem.cardId =
                    await DatabseService.instance.insertCard(cardData);
              }
              Navigator.pop(context);
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder(
          future: getCardFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  CreditCardWidget(
                    bankLogo: bank.bankLogo,
                    cardTypeCodeId: cardItem.cardTypeCodeId,
                    cardColorCodeId: cardItem.cardColorCodeId,
                    accountName: cardItem.accountName,
                    accountNumber: cardItem.accountNumber,
                    ifsCode: cardItem.ifsCode,
                    cardNumber: cardItem.cardNumber,
                    expiryDate: cardItem.cardExpiryDate,
                    cardHolderName: cardItem.cardHolderName,
                    cvvCode: cardItem.cardCvvCode,
                    cardPin: cardItem.cardPin,
                    mobileNumber: cardItem.mobileNumber,
                    mobilePin: cardItem.mobilePin,
                    upiId: cardItem.upiId,
                    upiPin: cardItem.upiPin,
                    internetId: cardItem.internetId,
                    internetUsername: cardItem.internetUsername,
                    internetPassword: cardItem.internetPassword,
                    internetProfilePassword: cardItem.internetProfilePassword,
                    showBackView: isBackFocused,
                    obscureData: false,
                    isSwipeGestureEnabled: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CreditCardForm(
                    formKey: formKey,
                    isEdit: isEdit,
                    obscureData: false,
                    cardTypeCodeId: cardItem.cardTypeCodeId,
                    cardColorCodeId: cardItem.cardColorCodeId,
                    accountName: cardItem.accountName,
                    accountNumber: cardItem.accountNumber,
                    ifsCode: cardItem.ifsCode,
                    cardNumber: cardItem.cardNumber,
                    cardHolderName: cardItem.cardHolderName,
                    expiryDate: cardItem.cardExpiryDate,
                    cvvCode: cardItem.cardCvvCode,
                    cardPin: cardItem.cardPin,
                    mobileNumber: cardItem.mobileNumber,
                    mobilePin: cardItem.mobilePin,
                    upiId: cardItem.upiId,
                    upiPin: cardItem.upiPin,
                    internetId: cardItem.internetId,
                    internetUsername: cardItem.internetUsername,
                    internetPassword: cardItem.internetPassword,
                    internetProfilePassword: cardItem.internetProfilePassword,
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  Visibility(
                    visible: isEdit,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        CupertinoFormSection(
                          children: [
                            CupertinoFormRow(
                              padding: EdgeInsets.zero,
                              child: CupertinoTextFormFieldRow(
                                readOnly: true,
                                style: const TextStyle(
                                  color: CupertinoColors.systemRed,
                                ),
                                initialValue: 'Delete Card',
                                onTap: () => showDeleteCardSheet(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 80.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardItem.cardTypeCodeId = creditCardModel!.cardTypeCodeId;
      cardItem.cardColorCodeId = creditCardModel.cardColorCodeId;
      cardItem.accountName = creditCardModel.accountName;
      cardItem.accountNumber = creditCardModel.accountNumber;
      cardItem.ifsCode = creditCardModel.ifsCode;
      cardItem.cardNumber = creditCardModel.cardNumber;
      cardItem.cardExpiryDate = creditCardModel.expiryDate;
      cardItem.cardHolderName = creditCardModel.cardHolderName;
      cardItem.cardCvvCode = creditCardModel.cvvCode;
      cardItem.cardPin = creditCardModel.cardPin;
      cardItem.mobileNumber = creditCardModel.mobileNumber;
      cardItem.mobilePin = creditCardModel.mobilePin;
      cardItem.upiId = creditCardModel.upiId;
      cardItem.upiPin = creditCardModel.upiPin;
      cardItem.internetId = creditCardModel.internetId;
      cardItem.internetUsername = creditCardModel.internetUsername;
      cardItem.internetPassword = creditCardModel.internetPassword;
      cardItem.internetProfilePassword =
          creditCardModel.internetProfilePassword;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }

  Future<void> getAndPopulateCard() async {
    if (isEdit) {
      final Map<String, dynamic> cardRow =
          await DatabseService.instance.queryOneCard(widget.cardId);
      cardItem = CardItem.fromJson(cardRow);
    }
    return;
  }

  deleteGroup() async {
    await DatabseService.instance.deleteCard(cardItem.cardId ?? 0);
    Navigator.popUntil(
      context,
      ModalRoute.withName(GroupListView.routeName),
    );
  }

  showDeleteCardSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'Delete Group',
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                deleteGroup();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }
}
