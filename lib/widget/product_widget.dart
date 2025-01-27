import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:lib_admin/Provider/Product_Provider.dart';
import 'package:lib_admin/screens/editorUploadProduct.dart';
import 'package:lib_admin/widget/suptitle_text.dart';

import 'package:provider/provider.dart';

import '../Provider/theme_provider.dart';

class ProductWidget extends StatefulWidget {
  ProductWidget({super.key, required this.bookNameId});
  final String bookNameId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProId(widget.bookNameId);
    return getCurrProduct == null
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.all(0.0),
            child: GestureDetector(
              //-> tıklanmayı dinle (GestureDetector) ile
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditoruploadproductScreen(
                        bookModel: getCurrProduct,
                      );
                    },
                  ),
                );
              },
              child: Container(
                decoration: !context.watch<ThemeProvider>().getIsDerkTehme
                    ? BoxDecoration(color: Color.fromARGB(30, 87, 164, 223), borderRadius: BorderRadius.circular(20))
                    : BoxDecoration(color: Color.fromARGB(39, 45, 59, 183), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.BookImage,
                        height: size.height * 0.2,
                        width: size.width * 0.4,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: SubTitleTextWidget(
                              label: getCurrProduct.bookTitle,
                              fontSize: 15,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(),
                            /*  child: HeardButtonWidget(
                              bookID: getCurrProduct.bookTitle,
                            ),*/
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SubTitleTextWidget(
                              label: getCurrProduct.bookWriter, //!Yazar
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(255, 0, 170, 255),
                            ),
                          ),
                          Flexible(
                            child: Material(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.lightBlue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {},
                                splashColor: Colors.grey,
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
