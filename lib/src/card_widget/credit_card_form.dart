import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'flutter_credit_card.dart';
import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.formKey,
    required this.isEdit,
    required this.cardTypeCodeId,
    required this.cardColorCodeId,
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
    this.obscureData = false,
    required this.onCreditCardModelChange,
  }) : super(key: key);

  final bool isEdit;
  final int cardTypeCodeId;
  final int cardColorCodeId;
  final String? accountName;
  final int? accountNumber;
  final String? ifsCode;
  final int? cardNumber;
  final String? expiryDate;
  final String? cardHolderName;
  final String? cvvCode;
  final String? cardPin;
  final int? mobileNumber;
  final String? mobilePin;
  final String? upiId;
  final String? upiPin;
  final String? internetId;
  final String? internetUsername;
  final String? internetPassword;
  final String? internetProfilePassword;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final bool obscureData;
  final GlobalKey<FormState> formKey;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late CardTypeModel selectedCardType;
  late int cardTypeCodeId;
  late int cardColorCodeId;
  late String? accountName;
  late int? accountNumber;
  late String? ifsCode;
  late int? cardNumber;
  late String? expiryDate;
  late String? cardHolderName;
  late String? cvvCode;
  late String? cardPin;
  late int? mobileNumber;
  late String? mobilePin;
  late String? upiId;
  late String? upiPin;
  late String? internetId;
  late String? internetUsername;
  late String? internetPassword;
  late String? internetProfilePassword;
  bool isBackFocused = false;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final TextEditingController _cardTypeController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifsCodeController = TextEditingController();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');
  final TextEditingController _cardPinController =
      MaskedTextController(mask: '0000');
  final MaskedTextController _mobileNumberController =
      MaskedTextController(mask: '000-000-0000');
  final MaskedTextController _mobilePinController =
      MaskedTextController(mask: '000000');
  final TextEditingController _upiIdController = TextEditingController();
  final MaskedTextController _upiPinController =
      MaskedTextController(mask: '000000');
  final TextEditingController _internetIdController = TextEditingController();
  final TextEditingController _internetUsernameController =
      TextEditingController();
  final TextEditingController _internetPasswordController =
      TextEditingController();
  final TextEditingController _internetProfilePasswordController =
      TextEditingController();

  FocusNode accountNumberNode = FocusNode();
  FocusNode ifsCodeNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardPinNode = FocusNode();
  FocusNode mobilePinNode = FocusNode();
  FocusNode upiPinNode = FocusNode();
  FocusNode internetUsernameNode = FocusNode();
  FocusNode internetPasswordNode = FocusNode();
  FocusNode internetProfilePasswordNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isBackFocused =
        cvvFocusNode.hasFocus || cardPinNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    selectedCardType = CardTypeModel.cardTypesList
        .firstWhere((item) => item.cardTypeCodeId == widget.cardTypeCodeId);
    cardTypeCodeId = widget.cardTypeCodeId;
    cardColorCodeId = widget.cardColorCodeId;
    accountName = widget.accountName;
    accountNumber = widget.accountNumber;
    ifsCode = widget.ifsCode;
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;
    cardPin = widget.cardPin;
    mobileNumber = widget.mobileNumber;
    mobilePin = widget.mobilePin;
    upiId = widget.upiId;
    upiPin = widget.upiPin;
    internetId = widget.internetId;
    internetUsername = widget.internetUsername;
    internetPassword = widget.internetPassword;
    internetProfilePassword = widget.internetProfilePassword;

    _cardTypeController.text = selectedCardType.cardTypeName;
    _accountNameController.text = accountName ?? '';
    _accountNumberController.text = accountNumber?.toString() ?? '';
    _ifsCodeController.text = ifsCode ?? '';
    _cardNumberController.text = cardNumber.toString();
    _expiryDateController.text = expiryDate ?? '';
    _cardHolderNameController.text = cardHolderName ?? '';
    _cvvCodeController.text = cvvCode.toString();
    _cardPinController.text = cardPin.toString();
    _mobileNumberController.text = mobileNumber.toString();
    _mobilePinController.text = mobilePin.toString();
    _upiIdController.text = upiId ?? '';
    _upiPinController.text = upiPin.toString();
    _internetIdController.text = internetId ?? '';
    _internetUsernameController.text = internetUsername ?? '';
    _internetPasswordController.text = internetPassword ?? '';
    _internetProfilePasswordController.text = internetProfilePassword ?? '';

    creditCardModel = CreditCardModel(
      cardTypeCodeId,
      cardColorCodeId,
      accountName,
      accountNumber,
      ifsCode,
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      cardPin,
      mobileNumber,
      mobilePin,
      upiId,
      upiPin,
      internetId,
      internetUsername,
      internetPassword,
      internetProfilePassword,
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
        cardTypeCodeId = selectedCardType.cardTypeCodeId;
        creditCardModel.cardTypeCodeId = cardTypeCodeId;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _accountNameController.addListener(() {
      setState(() {
        accountName = _accountNameController.text;
        creditCardModel.accountName = accountName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _accountNumberController.addListener(() {
      setState(() {
        accountNumber = int.tryParse(_accountNumberController.text);
        creditCardModel.accountNumber = accountNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _ifsCodeController.addListener(() {
      setState(() {
        ifsCode = _ifsCodeController.text;
        creditCardModel.ifsCode = ifsCode;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber =
            int.tryParse(_cardNumberController.text.replaceAll(' ', ''));
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

    _mobileNumberController.addListener(() {
      setState(() {
        mobileNumber =
            int.tryParse(_mobileNumberController.text.replaceAll('-', ''));
        creditCardModel.mobileNumber = mobileNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _mobilePinController.addListener(() {
      setState(() {
        mobilePin = _mobilePinController.text;
        creditCardModel.mobilePin = mobilePin;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _upiIdController.addListener(() {
      setState(() {
        upiId = _upiIdController.text;
        creditCardModel.upiId = upiId;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _upiPinController.addListener(() {
      setState(() {
        upiPin = _upiPinController.text;
        creditCardModel.upiPin = upiPin;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _internetIdController.addListener(() {
      setState(() {
        internetId = _internetIdController.text;
        creditCardModel.internetId = internetId;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _internetUsernameController.addListener(() {
      setState(() {
        internetUsername = _internetUsernameController.text;
        creditCardModel.internetUsername = internetUsername;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _internetPasswordController.addListener(() {
      setState(() {
        internetPassword = _internetPasswordController.text;
        creditCardModel.internetPassword = internetPassword;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _internetProfilePasswordController.addListener(() {
      setState(() {
        internetProfilePassword = _internetProfilePasswordController.text;
        creditCardModel.internetProfilePassword = internetProfilePassword;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void dispose() {
    accountNumberNode.dispose();
    ifsCodeNode.dispose();
    cardHolderNode.dispose();
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    cardPinNode.dispose();
    mobilePinNode.dispose();
    upiPinNode.dispose();
    internetUsernameNode.dispose();
    internetPasswordNode.dispose();
    internetProfilePasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: GradientColorModel.gradientsList.map((item) {
              return GestureDetector(
                child: Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: item.gradientColors,
                      stops: const [0.3, 0.75],
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      width: 3.0,
                      color: item.gradientCodeId == cardColorCodeId
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    cardColorCodeId = item.gradientCodeId;
                    creditCardModel.cardColorCodeId = cardColorCodeId;
                    onCreditCardModelChange(creditCardModel);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(
            height: 40.0,
          ),
          CupertinoFormSection(
            children: [
              CupertinoFormRow(
                padding: EdgeInsets.zero,
                child: CupertinoTextFormFieldRow(
                  readOnly: true,
                  controller: _cardTypeController,
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
          getCardTypeForm(),
        ],
      ),
    );
  }

  Widget getCardTypeForm() {
    switch (selectedCardType.cardTypeCodeId) {
      case 11001:
        return bankCardForm(context);
      case 11002:
      case 11003:
        return atmCardForm(context);
      case 11004:
        return mobileCardForm(context);
      case 11005:
        return internetCardForm(context);
      case 11006:
        return upiCardForm(context);
      default:
        return const SizedBox();
    }
  }

  CupertinoFormSection bankCardForm(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            autofocus: !widget.isEdit,
            controller: _accountNameController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(accountNumberNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Account Name',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'Account Holder Name',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please input Account Holder Name';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            obscureText: widget.obscureData,
            controller: _accountNumberController,
            focusNode: accountNumberNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(ifsCodeNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Account Number',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'Bank Account Number',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty || value.length > 18) {
                return 'Please input a valid number';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            controller: _ifsCodeController,
            focusNode: ifsCodeNode,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              onCreditCardModelChange(creditCardModel);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'IFSC Code',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'Bank IFSC Code',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please input a IFSC Code';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  CupertinoFormSection atmCardForm(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            autofocus: !widget.isEdit,
            obscureText: widget.obscureData,
            controller: _cardNumberController,
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
                return 'Please input a valid number';
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
            placeholder: 'MM/YY',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[
              AutofillHints.creditCardExpirationDate
            ],
            validator: (String? value) {
              const String dateValidationMessage = 'Please input a valid date';
              if (value!.isEmpty) {
                return dateValidationMessage;
              }
              final DateTime now = DateTime.now();
              final List<String> date = value.split(RegExp(r'/'));
              final int month = int.parse(date.first);
              final int year = int.parse('20${date.last}');
              final DateTime cardDate = DateTime(year, month);

              if (cardDate.isBefore(now) || month > 12 || month == 0) {
                return dateValidationMessage;
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
            obscureText: widget.obscureData,
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
            autofillHints: const <String>[AutofillHints.creditCardSecurityCode],
            validator: (String? value) {
              if (value!.isEmpty || value.length < 3) {
                return 'Please input a valid CVV';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            obscureText: widget.obscureData,
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
                return 'Please input a valid Pin';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  CupertinoFormSection mobileCardForm(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            autofocus: !widget.isEdit,
            obscureText: widget.obscureData,
            controller: _mobileNumberController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(mobilePinNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Mobile Number',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'XXX-XXX-XXXX',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty || value.length < 10) {
                return 'Please input a valid number';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            obscureText: widget.obscureData,
            controller: _mobilePinController,
            focusNode: mobilePinNode,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              onCreditCardModelChange(creditCardModel);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Mobile Pin',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'XXXXXX',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty || value.length < 4) {
                return 'Please input a valid Pin';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  CupertinoFormSection internetCardForm(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            autofocus: !widget.isEdit,
            obscureText: widget.obscureData,
            controller: _internetIdController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(internetUsernameNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Net Banking ID',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'User ID',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please input a Net Banking ID';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            controller: _internetUsernameController,
            focusNode: internetUsernameNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(internetProfilePasswordNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Net Banking Name',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'User Name',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please input a Net Banking User Name';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            controller: _internetPasswordController,
            focusNode: internetPasswordNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(internetProfilePasswordNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Password',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: '**********',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please input a Password';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            controller: _internetProfilePasswordController,
            focusNode: internetProfilePasswordNode,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              onCreditCardModelChange(creditCardModel);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'Profile Password',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: '**********',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  CupertinoFormSection upiCardForm(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            obscureText: widget.obscureData,
            controller: _upiIdController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(upiPinNode);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'UPI Id',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'username@bank',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty || value.contains('@')) {
                return 'Please input a valid UPI Id';
              }
              return null;
            },
          ),
        ),
        CupertinoFormRow(
          padding: EdgeInsets.zero,
          child: CupertinoTextFormFieldRow(
            obscureText: widget.obscureData,
            controller: _upiPinController,
            focusNode: upiPinNode,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              onCreditCardModelChange(creditCardModel);
            },
            prefix: const SizedBox(
              width: 100,
              child: Text(
                'UPI Pin',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            placeholder: 'XXXXXX',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.length < 4) {
                return 'Please input a valid Pin';
              }
              return null;
            },
          ),
        ),
      ],
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
            initialItem: CardTypeModel.cardTypesList.indexWhere((item) =>
                item.cardTypeCodeId == selectedCardType.cardTypeCodeId),
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedCardType = CardTypeModel.cardTypesList[index];
              _cardTypeController.text = selectedCardType.cardTypeName;
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
