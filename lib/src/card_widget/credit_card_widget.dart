import 'dart:math';

import 'package:flutter/material.dart';

import 'credit_card_animation.dart';
import 'credit_card_background.dart';
import 'credit_card_brand.dart';
import 'custom_card_brand_icon.dart';
import 'glassmorphism_config.dart';

// ignore: constant_identifier_names
const Map<CardBrand, String> CardBrandIconAsset = <CardBrand, String>{
  CardBrand.visa: 'assets/images/brands/visa.png',
  CardBrand.master: 'assets/images/brands/master.png',
  CardBrand.mastro: 'assets/images/brands/mastro.png',
  CardBrand.rupay: 'assets/images/brands/rupay.png',
  CardBrand.other: 'assets/images/brands/other.png',
};

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget(
      {Key? key,
      required this.cardType,
      required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvvCode,
      required this.cardPin,
      required this.showBackView,
      this.animationDuration = const Duration(milliseconds: 500),
      this.height,
      this.width,
      this.textStyle,
      this.cardBgColor = const Color(0xff1b447b),
      this.obscureCardNumber = true,
      this.obscureCardCvv = true,
      this.obscureCardPin = true,
      this.labelCardHolder = 'CARD HOLDER',
      this.labelExpiredDate = 'MM/YY',
      this.cardBrand,
      this.backgroundImage,
      this.glassmorphismConfig,
      this.isChipVisible = true,
      this.isSwipeGestureEnabled = true,
      this.customCardBrandIcons = const <CustomCardBrandIcon>[],
      required this.onCreditCardWidgetChange})
      : super(key: key);

  final String cardType;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String cardPin;
  final TextStyle? textStyle;
  final Color cardBgColor;
  final bool showBackView;
  final Duration animationDuration;
  final double? height;
  final double? width;
  final bool obscureCardNumber;
  final bool obscureCardCvv;
  final bool obscureCardPin;
  final void Function(CreditCardBrand) onCreditCardWidgetChange;
  final String? backgroundImage;
  final bool isChipVisible;
  final Glassmorphism? glassmorphismConfig;
  final bool isSwipeGestureEnabled;

  final String labelCardHolder;
  final String labelExpiredDate;

  final CardBrand? cardBrand;
  final List<CustomCardBrandIcon> customCardBrandIcons;

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

  bool isAmex = false;

  @override
  void initState() {
    super.initState();

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _gradientSetup();
    _updateRotations(false);
  }

  void _gradientSetup() {
    backgroundGradientColor = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: const <double>[0.1, 0.4, 0.7, 0.9],
      colors: <Color>[
        widget.cardBgColor.withOpacity(1),
        widget.cardBgColor.withOpacity(0.97),
        widget.cardBgColor.withOpacity(0.90),
        widget.cardBgColor.withOpacity(0.86),
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

    final CardBrand? cardBrand =
        widget.cardBrand ?? detectCCType(widget.cardNumber);
    widget.onCreditCardWidgetChange(CreditCardBrand(cardBrand));

    return Stack(
      children: <Widget>[
        _cardGesture(
          child: AnimationCard(
            animation: _frontRotation,
            child: _buildFrontContainer(),
          ),
        ),
        _cardGesture(
          child: AnimationCard(
            animation: _backRotation,
            child: _buildBackContainer(),
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
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    final String number = widget.obscureCardNumber
        ? widget.cardNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
        : widget.cardNumber;
    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      'AXIS BANK',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: widget.textStyle ??
                          defaultTextStyle.copyWith(fontSize: 13),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.cardType.isEmpty ? 'Debit Card' : widget.cardType,
                    style: widget.textStyle ??
                        defaultTextStyle.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF212121),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 2,
              child: Row(
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
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(
                widget.cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : number,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'VALID\nTHRU',
                    style: widget.textStyle ??
                        defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.expiryDate.isEmpty
                        ? widget.labelExpiredDate
                        : widget.expiryDate,
                    style: widget.textStyle ?? defaultTextStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      widget.cardHolderName.isEmpty
                          ? widget.labelCardHolder
                          : widget.cardHolderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: widget.textStyle ??
                          defaultTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  widget.cardBrand != null
                      ? getCardBrandImage(widget.cardBrand)
                      : getCardBrandIcon(widget.cardNumber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Builds a back container containing cvv
  ///
  Widget _buildBackContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Color(0xFF212121),
                fontFamily: 'halter',
                fontSize: 16,
              ),
            );

    final String cvv = widget.obscureCardCvv
        ? widget.cvvCode.replaceAll(RegExp(r'\d'), '*')
        : widget.cvvCode;

    final String pin = widget.obscureCardPin
        ? widget.cardPin.replaceAll(RegExp(r'\d'), '*')
        : widget.cardPin;

    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      child: Container(
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
                          widget.cvvCode.isEmpty ? 'XXX' : cvv,
                          maxLines: 1,
                          style: widget.textStyle ?? defaultTextStyle,
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
                          style: widget.textStyle ??
                              defaultTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.cardPin.isEmpty ? 'XXXX' : pin,
                          style: widget.textStyle ??
                              defaultTextStyle.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
  CardBrand detectCCType(String cardNumber) {
    //Default card type is other
    CardBrand cardBrand = CardBrand.other;

    if (cardNumber.isEmpty) {
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
    final List<CustomCardBrandIcon> customCardBrandIcon =
        getCustomCardBrandIcon(cardBrand!);
    if (customCardBrandIcon.isNotEmpty) {
      return customCardBrandIcon.first.cardImage;
    } else {
      return Image.asset(CardBrandIconAsset[cardBrand]!, height: 25);
    }
  }

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  Widget getCardBrandIcon(String cardNumber) {
    Widget icon;
    final CardBrand ccType = detectCCType(cardNumber);
    final List<CustomCardBrandIcon> customCardBrandIcon =
        getCustomCardBrandIcon(ccType);
    if (customCardBrandIcon.isNotEmpty) {
      icon = customCardBrandIcon.first.cardImage;
    } else {
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
    }

    return icon;
  }

  List<CustomCardBrandIcon> getCustomCardBrandIcon(
          CardBrand currentCardBrand) =>
      widget.customCardBrandIcons
          .where((CustomCardBrandIcon element) =>
              element.cardBrand == currentCardBrand)
          .toList();
}

class MaskedTextController extends TextEditingController {
  MaskedTextController(
      {String? text, required this.mask, Map<String, RegExp>? translator})
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
