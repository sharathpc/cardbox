import 'package:cardbox/src/databse_service.dart';
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
    this.items = const [],
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
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              int recordId = await DatabseService.instance.insert({
                DatabseService.columnBankName: 'Axis Bank',
                DatabseService.columnAccountNumber: 0123456789876543,
                DatabseService.columnIFSCode: 'AX000045',
                DatabseService.columnCardTypeCodeId: 10001,
                DatabseService.columnCardNumber: 52566775445622455,
                DatabseService.columnCardExpiryDate: '12/20',
                DatabseService.columnCardHolderName: 'Sharath Chandra',
                DatabseService.columnCardCvvCode: 234,
                DatabseService.columnCardPin: 1234,
                DatabseService.columnMobileNumber: 9246100100,
                DatabseService.columnMobilePin: 1234,
                DatabseService.columnInternetId: 'sharathaxisbank',
                DatabseService.columnInternetPassword: 'password@123'
              });
              print(recordId);
            },
            child: const Text('Insert'),
          ),
          TextButton(
            onPressed: () async {
              List<Map<String, dynamic>> queryRows =
                  await DatabseService.instance.queryAll();

              print(queryRows);
            },
            child: const Text('Get all'),
          ),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> queryRow =
                  await DatabseService.instance.queryOne(1);

              print(queryRow['bankname']);
            },
            child: const Text('Get one'),
          ),
        ],
      ),
      /* ListView.builder(
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
      ), */
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
