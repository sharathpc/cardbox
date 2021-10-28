import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'flutter_credit_card.dart';
import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.cardType,
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
    this.cardHolderDecoration = const InputDecoration(
      labelText: 'Card holder',
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: 'Card number',
      hintText: 'XXXX XXXX XXXX XXXX',
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: 'Expired Date',
      hintText: 'MM/YY',
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
    ),
    this.cardTypeDecoration = const InputDecoration(labelText: 'Card Type'),
    this.cardPinDecoration = const InputDecoration(
      labelText: 'Card Pin',
      hintText: 'XXXX',
    ),
    required this.formKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
  }) : super(key: key);

  final String cardType;
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

  final InputDecoration cardTypeDecoration;
  final InputDecoration cardNumberDecoration;
  final InputDecoration cardHolderDecoration;
  final InputDecoration expiryDateDecoration;
  final InputDecoration cvvCodeDecoration;
  final InputDecoration cardPinDecoration;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late String cardType;
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  late String cardPin;
  bool isCvvFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _cardTypeController = TextEditingController();
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');
  final TextEditingController _cardPinController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardTypeNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();
  FocusNode cardPinNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardType = widget.cardType;
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;
    cardPin = widget.cardPin;

    creditCardModel = CreditCardModel(
      cardType,
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      cardPin,
      isCvvFocused,
    );
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardTypeController.addListener(() {
      setState(() {
        cardType = _cardTypeController.text;
        creditCardModel.cardType = cardType;
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
    cardTypeNode.dispose();
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
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                obscureText: widget.obscureNumber,
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(cardTypeNode);
                },
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: widget.cardNumberDecoration,
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      controller: _cardTypeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      focusNode: cardTypeNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(expiryDateNode);
                      },
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      decoration: widget.cardTypeDecoration,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      controller: _expiryDateController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      focusNode: expiryDateNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(cardHolderNode);
                      },
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      decoration: widget.expiryDateDecoration,
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

                        if (cardDate.isBefore(now) ||
                            month > 12 ||
                            month == 0) {
                          return widget.dateValidationMessage;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                focusNode: cardHolderNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(cvvFocusNode);
                },
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: widget.cardHolderDecoration,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.creditCardName],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      obscureText: widget.obscureCvv,
                      focusNode: cvvFocusNode,
                      controller: _cvvCodeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(cardPinNode);
                      },
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      decoration: widget.cvvCodeDecoration,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autofillHints: const <String>[
                        AutofillHints.creditCardSecurityCode
                      ],
                      onChanged: (String text) {
                        setState(() {
                          cvvCode = text;
                        });
                      },
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 3) {
                          return widget.cvvValidationMessage;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      obscureText: widget.obscurePin,
                      focusNode: cardPinNode,
                      controller: _cardPinController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        onCreditCardModelChange(creditCardModel);
                      },
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      decoration: widget.cardPinDecoration,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      /* onChanged: (String text) {
                        setState(() {
                          cvvCode = text;
                        });
                      }, */
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 4) {
                          return widget.cvvValidationMessage;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
