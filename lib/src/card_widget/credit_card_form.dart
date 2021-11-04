import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'flutter_credit_card.dart';
import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.cardTypeCodeId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.cardPin,
    this.obscureCvv = false,
    this.obscureNumber = false,
    this.obscurePin = false,
    required this.onCreditCardModelChange,
    required this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    required this.formKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
  }) : super(key: key);

  final int cardTypeCodeId;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String cardPin;
  final String cvvValidationMessage;
  final String dateValidationMessage;
  final String numberValidationMessage;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color? cursorColor;
  final bool obscureCvv;
  final bool obscureNumber;
  final bool obscurePin;
  final GlobalKey<FormState> formKey;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  CardTypeModel? selectedCardType;
  late int cardTypeCodeId;
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  late String cardPin;
  bool isBackFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final TextEditingController _cardTypeController = TextEditingController();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');
  final TextEditingController _cardPinController =
      MaskedTextController(mask: '0000');

  FocusNode cardNumberNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardPinNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isBackFocused =
        cvvFocusNode.hasFocus || cardPinNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardTypeCodeId = widget.cardTypeCodeId;
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;
    cardPin = widget.cardPin;

    creditCardModel = CreditCardModel(
      cardTypeCodeId,
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      cardPin,
      isBackFocused,
    );
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);
    cardPinNode.addListener(textFieldFocusDidChange);

    _cardTypeController.addListener(() {
      setState(() {
        cardTypeCodeId = selectedCardType!.cardTypeCodeId;
        creditCardModel.cardTypeCodeId = cardTypeCodeId;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardPinController.addListener(() {
      setState(() {
        cardPin = _cardPinController.text;
        creditCardModel.cardPin = cardPin;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void dispose() {
    cardNumberNode.dispose();
    cardHolderNode.dispose();
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    cardPinNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CupertinoFormSection(
            header: const Text('Card Type'),
            children: [
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  readOnly: true,
                  controller: _cardTypeController,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(cardNumberNode);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'Card Type',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'Debit Card',
                  onTap: () => showCardTypePicker(context),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          CupertinoFormSection(
            header: const Text('Card Details'),
            children: [
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  autofocus: true,
                  obscureText: widget.obscureNumber,
                  controller: _cardNumberController,
                  focusNode: cardNumberNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(expiryDateNode);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'Card Number',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'XXXX XXXX XXXX XXXX',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.creditCardNumber],
                  validator: (String? value) {
                    // Validate less that 13 digits +3 white spaces
                    if (value!.isEmpty || value.length < 16) {
                      return widget.numberValidationMessage;
                    }
                    return null;
                  },
                ),
              ),
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  controller: _expiryDateController,
                  focusNode: expiryDateNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(cardHolderNode);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'Expired Date',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'XX/XX',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[
                    AutofillHints.creditCardExpirationDate
                  ],
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return widget.dateValidationMessage;
                    }
                    final DateTime now = DateTime.now();
                    final List<String> date = value.split(RegExp(r'/'));
                    final int month = int.parse(date.first);
                    final int year = int.parse('20${date.last}');
                    final DateTime cardDate = DateTime(year, month);

                    if (cardDate.isBefore(now) || month > 12 || month == 0) {
                      return widget.dateValidationMessage;
                    }
                    return null;
                  },
                ),
              ),
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  controller: _cardHolderNameController,
                  focusNode: cardHolderNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(cvvFocusNode);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'Card Holder',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'John Doe',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.creditCardName],
                ),
              ),
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  obscureText: widget.obscureCvv,
                  controller: _cvvCodeController,
                  focusNode: cvvFocusNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(cardPinNode);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'CVV',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'XXX',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[
                    AutofillHints.creditCardSecurityCode
                  ],
                  validator: (String? value) {
                    if (value!.isEmpty || value.length < 3) {
                      return widget.cvvValidationMessage;
                    }
                    return null;
                  },
                ),
              ),
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  obscureText: widget.obscurePin,
                  controller: _cardPinController,
                  focusNode: cardPinNode,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    onCreditCardModelChange(creditCardModel);
                  },
                  prefix: const SizedBox(
                    width: 100,
                    child: Text(
                      'Card Pin',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  placeholder: 'XXXX',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (String? value) {
                    if (value!.isEmpty || value.length < 4) {
                      return widget.numberValidationMessage;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showCardTypePicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => SizedBox(
        height: 280,
        child: CupertinoPicker(
          backgroundColor: CupertinoDynamicColor.resolve(
            CupertinoColors.systemBackground,
            context,
          ),
          scrollController: FixedExtentScrollController(
            initialItem: selectedCardType != null
                ? CardTypeModel.cardTypesList.indexWhere((item) =>
                    item.cardTypeCodeId == selectedCardType!.cardTypeCodeId)
                : -1,
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedCardType = CardTypeModel.cardTypesList[index];
              _cardTypeController.text = selectedCardType!.cardTypeName;
            });
          },
          itemExtent: 32.0,
          children: CardTypeModel.cardTypesList.map((CardTypeModel item) {
            return Center(
              heightFactor: double.maxFinite,
              widthFactor: double.infinity,
              child: Text(
                item.cardTypeName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
