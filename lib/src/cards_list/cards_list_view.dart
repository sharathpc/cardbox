import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../models/models.dart';
import '../settings/settings_view.dart';
import '../card_detail/card_detail_view.dart';
import '../add_card/add_card_view.dart';

/// Displays a list of CardItems.
class CardsListView extends StatelessWidget {
  const CardsListView({
    Key? key,
    this.items = const [
      CardItem('52566775445622455', '12/20', 'Sharath Chandra', '234'),
      CardItem('52566775445622455', '12/20', 'Sharath Chandra', '234'),
      CardItem('52566775445622455', '12/20', 'Sharath Chandra', '234'),
      CardItem('52566775445622455', '12/20', 'Sharath Chandra', '234'),
    ],
  }) : super(key: key);

  static const routeName = '/';

  final List<CardItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'cardsListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final CardItem cardItem = items[index];

          return InkWell(
            onTap: () => {
              Navigator.pushNamed(
                context,
                CardDetailView.routeName,
                arguments: cardItem,
              ),
            },
            child: CreditCardWidget(
              cardNumber: cardItem.cardNumber,
              expiryDate: cardItem.expiryDate,
              cardHolderName: cardItem.cardHolderName,
              cvvCode: cardItem.cvvCode,
              showBackView: false,
              isHolderNameVisible: true,
              isChipVisible: false,
              cardBgColor: Colors.black,
              isSwipeGestureEnabled: false,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(
            context,
            AddCardView.routeName,
          )
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
