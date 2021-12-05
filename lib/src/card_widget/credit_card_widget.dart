import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'credit_card_model.dart';
import 'credit_card_animation.dart';
import 'credit_card_background.dart';

// ignore: constant_identifier_names
const Map<CardBrand, String> CardBrandIconAsset = <CardBrand, String>{
  CardBrand.visa: 'assets/images/brands/visa.png',
  CardBrand.master: 'assets/images/brands/master.png',
  CardBrand.mastro: 'assets/images/brands/mastro.png',
  CardBrand.rupay: 'assets/images/brands/rupay.png',
  CardBrand.other: 'assets/images/brands/other.png',
};

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({
    Key? key,
    required this.bankLogo,
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
    this.upiPin,
    this.internetId,
    this.internetUsername,
    this.internetPassword,
    this.internetProfilePassword,
    required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height,
    this.width,
    this.obscureData = true,
    this.isChipVisible = true,
    this.isSwipeGestureEnabled = true,
  }) : super(key: key);

  final String bankLogo;
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
  final String? upiPin;
  final String? internetId;
  final String? internetUsername;
  final String? internetPassword;
  final String? internetProfilePassword;
  final bool showBackView;
  final Duration animationDuration;
  final double? height;
  final double? width;
  final bool obscureData;
  final bool isChipVisible;
  final bool isSwipeGestureEnabled;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  late Gradient backgroundGradientColor;
  late bool isFrontVisible = true;
  late bool isGestureUpdate = false;

  @override
  void initState() {
    super.initState();

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _updateRotations(false);
  }

  void _gradientSetup() {
    final GradientColorModel cardBgColor = GradientColorModel.gradientsList
        .firstWhere((item) => item.gradientCodeId == widget.cardColorCodeId);
    backgroundGradientColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: cardBgColor.gradientColors,
      stops: const [
        0.3,
        0.75,
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// If uer adds CVV then toggle the card from front to back..
    /// controller forward starts animation and shows back layout.
    /// controller reverse starts animation and shows front layout.
    ///
    if (!isGestureUpdate) {
      _updateRotations(false);
      if (widget.showBackView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    } else {
      isGestureUpdate = false;
    }

    _gradientSetup();

    //final CardBrand? cardBrand = detectCCType(widget.cardNumber);
    //widget.onCreditCardWidgetChange(CreditCardBrand(cardBrand));

    return Stack(
      children: <Widget>[
        _cardGesture(
          child: AnimationCard(
            animation: _frontRotation,
            child: CardBackground(
              backgroundGradientColor: backgroundGradientColor,
              height: widget.height,
              width: widget.width,
              child: _buildFrontContainer(),
            ),
          ),
        ),
        _cardGesture(
          child: AnimationCard(
            animation: _backRotation,
            child: CardBackground(
              backgroundGradientColor: backgroundGradientColor,
              height: widget.height,
              width: widget.width,
              child: _buildBackContainer(),
            ),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide(false);
  }

  void _rightRotation() {
    _toggleSide(true);
  }

  void _toggleSide(bool isRightTap) {
    _updateRotations(!isRightTap);
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }

  void _updateRotations(bool isRightSwipe) {
    setState(() {
      final bool rotateToLeft =
          (isFrontVisible && !isRightSwipe) || !isFrontVisible && isRightSwipe;

      ///Initialize the Front to back rotation tween sequence.
      _frontRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
                    begin: 0.0, end: rotateToLeft ? (pi / 2) : (-pi / 2))
                .chain(CurveTween(curve: Curves.linear)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (-pi / 2) : (pi / 2)),
            weight: 50.0,
          ),
        ],
      ).animate(controller);

      ///Initialize the Back to Front rotation tween sequence.
      _backRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (pi / 2) : (-pi / 2)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
                    begin: rotateToLeft ? (-pi / 2) : (pi / 2), end: 0.0)
                .chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 50.0,
          ),
        ],
      ).animate(controller);
    });
  }

  ///
  /// Builds a front container containing
  /// Card number, Exp. year and Card holder name
  ///
  Widget _buildFrontContainer() {
    switch (widget.cardTypeCodeId) {
      case 11001:
        return _buildBankFrontContainer();
      case 11002:
      case 11003:
        return _buildCardFrontContainer();
      case 11004:
        return _buildMobileFrontContainer();
      case 11005:
        return _buildInternetFrontContainer();
      default:
        return const SizedBox();
    }
  }

  ///
  /// Builds a back container containing cvv
  ///
  Widget _buildBackContainer() {
    switch (widget.cardTypeCodeId) {
      case 11001:
        return _buildEmptyBackContainer();
      case 11002:
      case 11003:
        return _buildCardBackContainer();
      case 11004:
        return _buildEmptyBackContainer();
      case 11005:
        return _buildEmptyBackContainer();
      default:
        return const SizedBox();
    }
  }

  Row cardHeader(CardTypeModel? cardType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.asset(
            widget.bankLogo,
            height: 25,
          ),
        ),
        Row(
          children: [
            const IconTheme(
              data: IconThemeData(
                color: Colors.white70,
                size: 20,
              ),
              child: Icon(Icons.credit_card),
            ),
            const SizedBox(width: 5),
            Text(
              cardType == null ? 'DEBIT CARD' : cardType.cardTypeName,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  _buildBankFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white70,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    String? accountNumber;
    if (widget.accountNumber != null) {
      accountNumber = widget.obscureData
          ? widget.accountNumber.toString().replaceAll(RegExp(r'\d'), '*')
          : widget.accountNumber.toString();
    }
    final String accountIfsCode = widget.ifsCode ?? '';
    final String accountHolderName = widget.accountName ?? '';

    final CardTypeModel? cardType = CardTypeModel.cardTypesList
        .firstWhereOrNull(
            (item) => item.cardTypeCodeId == widget.cardTypeCodeId);
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardHeader(cardType),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const IconTheme(
                data: IconThemeData(
                  color: Colors.white70,
                  size: 45,
                ),
                child: Icon(Icons.account_balance),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACCOUNT NUMBER',
                    style: defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    accountNumber ?? 'XXXXXXXXXXXXXXXX',
                    style: defaultTextStyle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'IFSC\nCODE',
                style: defaultTextStyle.copyWith(fontSize: 7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              Text(
                accountIfsCode.isEmpty ? 'BANKXXXXXX' : accountIfsCode,
                style: defaultTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            accountHolderName.isEmpty ? 'ACCOUNT HOLDER' : accountHolderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: defaultTextStyle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  _buildCardFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white70,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    String? cardNumber;
    if (widget.cardNumber != null) {
      final String cardStringNumber = MaskedTextController(
        mask: '0000 0000 0000 0000',
        text: widget.cardNumber.toString(),
      ).text;

      cardNumber = widget.obscureData
          ? cardStringNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
          : cardStringNumber;
    }

    final String expiryDate = widget.expiryDate ?? '';
    final String cardHolderName = widget.cardHolderName ?? '';

    final CardTypeModel? cardType = CardTypeModel.cardTypesList
        .firstWhereOrNull(
            (item) => item.cardTypeCodeId == widget.cardTypeCodeId);
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardHeader(cardType),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (widget.isChipVisible)
                Image.asset(
                  'assets/images/chip.png',
                  width: 35,
                  height: 35,
                ),
              const Spacer(),
              if (widget.isChipVisible)
                const IconTheme(
                  data: IconThemeData(
                    color: Color(0xFF212121),
                    size: 35,
                  ),
                  child: Icon(Icons.contactless_outlined),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            cardNumber ?? 'XXXX XXXX XXXX XXXX',
            style: defaultTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'VALID\nTHRU',
                style: defaultTextStyle.copyWith(fontSize: 7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              Text(
                expiryDate.isEmpty ? 'MM/YY' : expiryDate,
                style: defaultTextStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  cardHolderName.isEmpty ? 'CARD HOLDER' : cardHolderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: defaultTextStyle.copyWith(fontSize: 14),
                ),
              ),
              getCardBrandIcon(cardNumber)
            ],
          ),
        ],
      ),
    );
  }

  _buildMobileFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white70,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    String? mobileNumber;
    if (widget.mobileNumber != null) {
      final String mobileStringNumber = MaskedTextController(
        mask: '000-000-0000',
        text: widget.mobileNumber.toString(),
      ).text;

      mobileNumber = widget.obscureData
          ? mobileStringNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
          : mobileStringNumber;
    }
    String? mobilePin;
    if (widget.mobilePin != null) {
      mobilePin = widget.obscureData
          ? widget.mobilePin.toString().replaceAll(RegExp(r'\d'), '*')
          : widget.mobilePin.toString();
    }
    String? upiPin;
    if (widget.upiPin != null) {
      upiPin = widget.obscureData
          ? widget.upiPin.toString().replaceAll(RegExp(r'\d'), '*')
          : widget.upiPin.toString();
    }

    final CardTypeModel? cardType = CardTypeModel.cardTypesList
        .firstWhereOrNull(
            (item) => item.cardTypeCodeId == widget.cardTypeCodeId);
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardHeader(cardType),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconTheme(
                data: IconThemeData(
                  color: Colors.white70,
                  size: 45,
                ),
                child: Icon(Icons.stay_current_portrait),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'MOBILE\nNUMBER',
                      style: defaultTextStyle.copyWith(fontSize: 7),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      mobileNumber ?? 'XXX-XXX-XXXX',
                      style: defaultTextStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'MOBILE\nPIN',
                    style: defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    mobilePin ?? 'XXXXXX',
                    style: defaultTextStyle,
                  ),
                ],
              ),
              const SizedBox(
                width: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'UPI\nPIN',
                    style: defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    upiPin ?? 'XXXXXX',
                    style: defaultTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildInternetFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white70,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    final String internetId = widget.internetId ?? '';
    final String internetUsername = widget.internetUsername ?? '';

    String? internetPassword;
    if (widget.internetPassword != null) {
      internetPassword = widget.obscureData
          ? widget.internetPassword.toString().replaceAll(RegExp(r'\S'), '*')
          : widget.internetPassword.toString();
    }

    String? internetProfilePassword;
    if (widget.internetProfilePassword != null) {
      internetProfilePassword = widget.obscureData
          ? widget.internetProfilePassword
              .toString()
              .replaceAll(RegExp(r'\S'), '*')
          : widget.internetProfilePassword.toString();
    }

    final CardTypeModel? cardType = CardTypeModel.cardTypesList
        .firstWhereOrNull(
            (item) => item.cardTypeCodeId == widget.cardTypeCodeId);
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardHeader(cardType),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconTheme(
                data: IconThemeData(
                  color: Colors.white70,
                  size: 45,
                ),
                child: Icon(Icons.language),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'USER\nID',
                          style: defaultTextStyle.copyWith(fontSize: 7),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          internetId.isEmpty ? 'XXXXXXXXXX' : internetId,
                          style: defaultTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'USER\nNAME',
                          style: defaultTextStyle.copyWith(fontSize: 7),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          internetUsername.isEmpty
                              ? 'XXXXXXXXXX'
                              : internetUsername,
                          style: defaultTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'USER\nPASSWORD',
                style: defaultTextStyle.copyWith(fontSize: 7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              Text(
                internetPassword ?? '************',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: defaultTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'PROFILE\nPASSWORD',
                style: defaultTextStyle.copyWith(fontSize: 7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              Text(
                internetProfilePassword ?? '************',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: defaultTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBackContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBackContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white70,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    String? cardCvv;
    if (widget.cvvCode != null) {
      cardCvv = widget.obscureData
          ? widget.cvvCode.toString().replaceAll(RegExp(r'\d'), '*')
          : widget.cvvCode.toString();
    }
    String? cardPin;
    if (widget.cardPin != null) {
      cardPin = widget.obscureData
          ? widget.cardPin.toString().replaceAll(RegExp(r'\d'), '*')
          : widget.cardPin.toString();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Container(
                    height: 42,
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        cardCvv ?? 'XXX',
                        maxLines: 1,
                        style: defaultTextStyle.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/hologram.png',
                      height: 40,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'CARD\nPIN',
                        style: defaultTextStyle.copyWith(
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        cardPin ?? 'XXXX',
                        style: defaultTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardGesture({required Widget child}) {
    bool isRightSwipe = true;
    return widget.isSwipeGestureEnabled
        ? GestureDetector(
            onPanEnd: (_) {
              isGestureUpdate = true;
              if (isRightSwipe) {
                _leftRotation();
              } else {
                _rightRotation();
              }
            },
            onPanUpdate: (DragUpdateDetails details) {
              // Swiping in right direction.
              if (details.delta.dx > 0) {
                isRightSwipe = true;
              }

              // Swiping in left direction.
              if (details.delta.dx < 0) {
                isRightSwipe = false;
              }
            },
            child: child,
          )
        : child;
  }

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardBrand, Set<List<String>>> cardNumPatterns =
      <CardBrand, Set<List<String>>>{
    CardBrand.visa: <List<String>>{
      <String>['4'],
    },
    CardBrand.master: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2720'],
    },
    CardBrand.mastro: <List<String>>{
      <String>['5018'],
      <String>['5020'],
      <String>['5038'],
      <String>['5893'],
      <String>['6304'],
      <String>['6759'],
      <String>['6761'],
      <String>['6762'],
      <String>['6763'],
    },
    CardBrand.rupay: <List<String>>{
      <String>['60'],
      <String>['65'],
      <String>['81'],
      <String>['82'],
      <String>['508'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardBrand detectCCType(String? cardNumber) {
    //Default card type is other
    CardBrand cardBrand = CardBrand.other;

    if (cardNumber == null) {
      return cardBrand;
    }

    cardNumPatterns.forEach(
      (CardBrand type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardBrand = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardBrand = type;
              break;
            }
          }
        }
      },
    );

    return cardBrand;
  }

  Widget getCardBrandImage(CardBrand? cardBrand) {
    return Image.asset(CardBrandIconAsset[cardBrand]!, height: 25);
  }

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  Widget getCardBrandIcon(String? cardNumber) {
    Widget icon;
    final CardBrand ccType = detectCCType(cardNumber);

    switch (ccType) {
      case CardBrand.visa:
        icon = Image.asset(
          CardBrandIconAsset[ccType]!,
          height: 25,
        );
        break;

      case CardBrand.master:
        icon = Image.asset(
          CardBrandIconAsset[ccType]!,
          height: 25,
        );
        break;

      case CardBrand.mastro:
        icon = Image.asset(
          CardBrandIconAsset[ccType]!,
          height: 25,
        );
        break;

      case CardBrand.rupay:
        icon = Image.asset(
          CardBrandIconAsset[ccType]!,
          height: 25,
        );
        break;

      default:
        icon = Image.asset(
          CardBrandIconAsset[CardBrand.other]!,
          height: 25,
        );
        break;
    }

    return icon;
  }
}

class MaskedTextController extends TextEditingController {
  MaskedTextController(
      {text, required this.mask, Map<String, RegExp>? translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  late Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text.isNotEmpty) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String? mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask!.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

enum CardBrand {
  visa,
  master,
  mastro,
  rupay,
  other,
}
