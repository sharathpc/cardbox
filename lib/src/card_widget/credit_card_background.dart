import 'package:flutter/material.dart';

import 'constants.dart';
import 'glassmorphism_config.dart';

class CardBackground extends StatelessWidget {
  const CardBackground({
    Key? key,
    required this.backgroundGradientColor,
    required this.backgroundImage,
    required this.child,
    this.width,
    this.height,
    this.glassmorphismConfig,
  }) : super(key: key);

  final String? backgroundImage;
  final Widget child;
  final Gradient backgroundGradientColor;
  final Glassmorphism? glassmorphismConfig;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double screenWidth = constraints.maxWidth.isInfinite
          ? MediaQuery.of(context).size.width
          : constraints.maxWidth;
      final double screenHeight = MediaQuery.of(context).size.height;
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(AppConstants.creditCardPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: glassmorphismConfig != null
                  ? glassmorphismConfig!.gradient
                  : backgroundGradientColor,
              image: backgroundImage != null
                  ? DecorationImage(
                      image: ExactAssetImage(
                        backgroundImage!,
                      ),
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
            width: width ?? screenWidth,
            height: height ??
                (orientation == Orientation.portrait
                    ? (((width ?? screenWidth) -
                            (AppConstants.creditCardPadding * 2)) *
                        AppConstants.creditCardAspectRatio)
                    : screenHeight / 2),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                child: child,
              ),
            ),
          ),
        ],
      );
    });
  }
}
