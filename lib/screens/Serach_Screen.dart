import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:lib_admin/Model/book_model.dart';
import 'package:lib_admin/widget/product_widget.dart';

import 'package:provider/provider.dart';

import '../Provider/Product_Provider.dart';

import '../widget/suptitle_text.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoadingBook = true;

  Future<void> FetchBook() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false); //sürekli dinleme

    try {
      //! Bitene kadar bekle
      Future.wait({
        productProvider.fetchProducts(),
      });
    } catch (error) {
      print(error.toString());
    }
  }

  //bağımlılıkların değişmesi durumunda bazı işlemler yapmak için.
  @override
  void didChangeDependencies() {
    if (_isLoadingBook) {
      FetchBook();
    }
    super.didChangeDependencies();
  }

  late TextEditingController searchTextController;
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<BookModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCatogory = ModalRoute.of(context)!.settings.arguments as String?; //Gelen veri

    List<BookModel> bookList = passedCatogory == null
        ? productProvider.products
        : productProvider.findByCategory(categoryName: passedCatogory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SubTitleTextWidget(
            fontSize: 20,
            label: passedCatogory ?? 'Book Serach ',
          ),
        ),
        body: bookList.isEmpty
            ? const Center(
                child: Text("There aren't any books"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              searchTextController.text = "";
                            });
                          },
                          child: Icon(
                            Icons.close_sharp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          print("Gairdi");
                          productListSearch =
                              productProvider.searchQuery(searchText: searchTextController.text, passedList: bookList);
                          print("Çıktı :${productListSearch.length}");
                        });
                      },
                      onSubmitted: (value) {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (searchTextController.text.isNotEmpty && productListSearch.isEmpty) ...[
                      Center(
                        child: SubTitleTextWidget(
                          label: "No Book Found${productListSearch.length} / ${searchTextController.text} ",
                        ),
                      ),
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        mainAxisSpacing: 12,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        itemCount: searchTextController.text.isNotEmpty ? productListSearch.length : bookList.length,
                        builder: (context, index) {
                          return ProductWidget(
                            //  bookNameId: bookList[index].bookTitle,
                            bookNameId: searchTextController.text.isNotEmpty
                                ? productListSearch[index].bookId
                                : bookList[index].bookId,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/*

                                */