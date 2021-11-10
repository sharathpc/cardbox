import 'dart:math';

import 'package:flutter/material.dart';

import 'card_widget/flutter_credit_card.dart';

import 'models/models.dart';

class CardSlider extends StatefulWidget {
  const CardSlider({
    Key? key,
    required this.height,
    required this.cardItemsList,
  }) : super(key: key);

  final double height;
  final List<CardItem> cardItemsList;

  @override
  State<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  late double positionYline1;
  late double positionYline2;
  late double _middleAreaHeight;
  late double _outsideCardInterval;
  late double scrollOffsetY;

  List<CardItem> _cardInfoList = [];

  @override
  void initState() {
    super.initState();
    positionYline1 = widget.height * 0.1;
    positionYline2 = positionYline1 + 200;

    _middleAreaHeight = positionYline2 - positionYline1;
    _outsideCardInterval = 30.0;
    scrollOffsetY = 0;

    for (var i = 0; i < widget.cardItemsList.length; i++) {
      CardItem cardInfo = widget.cardItemsList[i];
      if (i == 0) {
        cardInfo.postionY = positionYline1;
        cardInfo.opacity = 1.0;
        cardInfo.scale = 1.0;
        cardInfo.rotate = 1.0;
      } else {
        cardInfo.postionY = positionYline2 + (i - 1) * 30;
        cardInfo.opacity = 0.7 - (i - 1) * 0.1;
        cardInfo.scale = 0.9;
        cardInfo.rotate = -60;
      }
    }

    _cardInfoList = widget.cardItemsList.reversed.toList();
  }

  _buildCards() {
    List widgetList = [];

    for (CardItem cardInfo in _cardInfoList) {
      widgetList.add(
        Positioned(
          top: cardInfo.postionY,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(pi / 180 * cardInfo.rotate)
              ..scale(cardInfo.scale),
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: cardInfo.opacity,
              child: CreditCardWidget(
                bankLogo: '', //selectedBank.bankLogo
                cardTypeCodeId: cardInfo.cardTypeCodeId,
                cardColorCodeId: cardInfo.cardColorCodeId,
                cardNumber: cardInfo.cardNumber,
                expiryDate: cardInfo.cardExpiryDate,
                cardHolderName: cardInfo.cardHolderName,
                cvvCode: cardInfo.cardCvvCode,
                cardPin: cardInfo.cardPin,
                showBackView: false,
                obscureData: true,
                isSwipeGestureEnabled: false,
              ),
            ),
          ),
        ),
      );
    }

    return widgetList;
  }

  _updateCardsPosition(double offsetY) {
    void updatePosition(
        CardItem cardInfo, double firstCardAtAreaIdx, int cardIdx) {
      double currentCardAtAtreaIdx = firstCardAtAreaIdx + cardIdx;

      if (currentCardAtAtreaIdx < 0) {
        cardInfo.postionY =
            positionYline1 + currentCardAtAtreaIdx * _outsideCardInterval;

        cardInfo.rotate =
            -90.0 / _outsideCardInterval * (positionYline1 - cardInfo.postionY);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        cardInfo.scale = 1.0 -
            0.2 / _outsideCardInterval * (positionYline1 - cardInfo.postionY);
        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        //1.0->0.7
        cardInfo.opacity = 1.0 -
            0.7 / _outsideCardInterval * (positionYline1 - cardInfo.postionY);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAtreaIdx >= 0 && currentCardAtAtreaIdx < 1) {
        cardInfo.postionY =
            positionYline1 + currentCardAtAtreaIdx * _middleAreaHeight;

        cardInfo.rotate = -60.0 /
            (positionYline2 - positionYline1) *
            (cardInfo.postionY - positionYline1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;

        //0.9->1.0
        cardInfo.scale = 1.0 -
            0.1 /
                (positionYline2 - positionYline1) *
                (cardInfo.postionY - positionYline1);
        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        //0.7->1.0
        cardInfo.opacity = 1.0 -
            0.3 /
                (positionYline2 - positionYline1) *
                (cardInfo.postionY - positionYline1);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAtreaIdx >= 1) {
        cardInfo.postionY =
            positionYline2 + (currentCardAtAtreaIdx - 1) * _outsideCardInterval;

        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    scrollOffsetY += offsetY;
    double firstCardAtAreaIdx = scrollOffsetY / _middleAreaHeight;

    for (var i = 0; i < _cardInfoList.length; i++) {
      CardItem cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
      updatePosition(cardInfo, firstCardAtAreaIdx, i);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails d) {
        _updateCardsPosition(d.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails d) {
        scrollOffsetY =
            (scrollOffsetY / _middleAreaHeight).round() * _middleAreaHeight;
        _updateCardsPosition(0);
      },
      child: SizedBox(
        //width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            ..._buildCards(),
          ],
        ),
      ),
    );
  }
}
