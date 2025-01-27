import 'package:flutter/material.dart';
import 'package:lib_admin/widget/Order/order_widget.dart';

import '../suptitle_text.dart';

class OrderScreen extends StatefulWidget {
  static const routName = "/OrderScreen";
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isEmpyOrders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: SubTitleTextWidget(
          label: 'All Order', //Kiaralan kitaplar burda olacak ad ona gore deyişecek
        ),
      ),
      body: isEmpyOrders
          ? SizedBox
              .shrink() /* EmtyBagWidget(
              imagePath: AssetsManager.rounded_map, //Deyişecek
              title: 'No Order hes bee placed',
              buttonText: 'Get a book ',
              subtitle: '',
            )
            */
          : ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrderWidgetFree(),
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black54,
                  ),
              itemCount: 10),
    );
  }
}
