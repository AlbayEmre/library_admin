import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // Localden ya da kameradan resim çekmek için

import 'package:firebase_storage/firebase_storage.dart';
import 'package:lib_admin/Colors/app_constans.dart';
import 'package:lib_admin/Colors/theme_Advance.dart';
import 'package:lib_admin/Colors/validator(Wigdet).dart';
import 'package:lib_admin/Model/book_model.dart';
import 'package:lib_admin/Services/myapp_functions.dart';
import 'package:lib_admin/widget/Loading_Manager.dart';
import 'package:lib_admin/widget/suptitle_text.dart';

import 'package:uuid/uuid.dart';

class EditoruploadproductScreen extends StatefulWidget {
  static const routName = "/EditoruploadproductScreen";
  EditoruploadproductScreen({super.key, this.bookModel});
  final BookModel? bookModel;

  @override
  State<EditoruploadproductScreen> createState() => _EditoruploadproductScreenState();
}

class _EditoruploadproductScreenState extends State<EditoruploadproductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage; // Kamera ya da galeriden image alabilmek için
  late TextEditingController _titleController;
  late TextEditingController _writerController; // price
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _publishedController;
  late TextEditingController _PageCountController;

  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  bool _isLoading = false;
  // String? bookImageUrl;

  @override
  void initState() {
    if (widget.bookModel != null) {
      // Yeni ürün mü yoksa var olan mı
      isEditing = true;
      productNetworkImage = widget.bookModel!.BookImage;
      _categoryValue = widget.bookModel!.BookCatagory;
    }

    _titleController = TextEditingController(text: widget.bookModel?.bookTitle);
    _writerController = TextEditingController(text: widget.bookModel?.bookWriter); // price to writer
    _descriptionController = TextEditingController(text: widget.bookModel?.BookDescription);
    _quantityController = TextEditingController(text: widget.bookModel?.bookQuantity.toString());
    _publishedController = TextEditingController(text: widget.bookModel?.Numberofpages.toString());
    _PageCountController = TextEditingController(text: widget.bookModel?.Publisher.toString());
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _writerController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _PageCountController.dispose();
    _publishedController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _writerController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _PageCountController.clear();
    _publishedController.clear();
    removePickedImage();
  }

  Future<void> _addBooks() async {
    print("state1");
    if (_pickedImage == null) {
      MyAppFuncrions.showErrorOrWaningDialog(
        context: context,
        subtitle: "Plaese add image",
        fct: () {},
      );
      return;
    }
    print("state2");
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      // Add book logic here
      try {
        print("statetry");
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance.ref().child("bookImages").child("${_titleController.text}.png");
        await ref.putFile(File(_pickedImage!.path));
        productNetworkImage = await ref.getDownloadURL();
        final bookId = Uuid().v4(); //Benzersiz id
        await FirebaseFirestore.instance.collection("books").doc(bookId).set({
          'bookId': bookId, //Uuid().v4();
          'bookTitle': _titleController.text,
          'BookCatagory': _categoryValue,
          'BookDescription': _descriptionController.text,
          'BookImage': productNetworkImage,
          'bookQuantity': _quantityController.text,
          'bookWriter': _writerController.text,
          'Numberofpages': _PageCountController.text,
          'Publisher': _publishedController.text,
          'createdAt': Timestamp.now(), //Füncel oluşturma samanı (FireStore function)
        });
        print("stateasdasd");
        Fluttertoast.showToast(msg: "Book has beed added Success", textColor: Colors.blue);
        if (!mounted) {
          return;
        }
        print("state3");
        MyAppFuncrions.showErrorOrWaningDialog(
            context: context,
            subtitle: "Clear Form ?",
            fct: () {
              //Olumlu ise => çalıştır
              clearForm();
            });
      } on FirebaseException catch (error) {
        await MyAppFuncrions.showErrorOrWaningDialog(context: context, subtitle: error.message.toString(), fct: () {});
      } catch (error) {
        await MyAppFuncrions.showErrorOrWaningDialog(context: context, subtitle: error.toString(), fct: () {});
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    print("state4");
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFuncrions.ImagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        // _pickedImage güncellendiğinde _titleController'ı temizle
        _titleController.clear();
        setState(() {});
      },
      gallaryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        // _pickedImage güncellendiğinde _titleController'ı temizle
        _titleController.clear();
        setState(() {});
      },
      removeFCT: () async {
        _pickedImage = null;
        setState(() {});
      },
    );
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _editBooks() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null) {
      MyAppFuncrions.showErrorOrWaningDialog(
        context: context,
        subtitle: "Please add an image",
        fct: () {},
      );
      return;
    }

    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        // Güncellenecek kitabın ID'si uuid
        final String bookId = widget.bookModel!.bookId;

        // Güncelleme işlemi Firestore'da belirli bir dokümanı güncellemekle gerçekleştirilir
        await FirebaseFirestore.instance.collection("books").doc(bookId).update({
          'bookTitle': _titleController.text,
          'BookCatagory': _categoryValue,
          'BookDescription': _descriptionController.text,
          'bookQuantity': _quantityController.text,
          'bookWriter': _writerController.text,
          'Numberofpages': _PageCountController.text,
          'Publisher': _publishedController.text,
        });

        // Eğer kullanıcı resmi değiştirmişse, yeni resmi Firebase Storage'a yükleyin ve Firestore'daki dokümanı güncelleyin
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance.ref().child("bookImages").child("${_titleController.text}.png");
          await ref.putFile(File(_pickedImage!.path));
          final productNetworkImage = await ref.getDownloadURL();

          // Güncellenmiş resmi Firestore'daki dokümana ekle
          await FirebaseFirestore.instance.collection("books").doc(bookId).update({
            'BookImage': productNetworkImage,
          });
        }

        Fluttertoast.showToast(msg: "Book has been updated successfully");

        // İşlem tamamlandığında formu temizleyin
        clearForm();
      } catch (error) {
        // Hata durumunda kullanıcıya bildirim gösterin
        await MyAppFuncrions.showErrorOrWaningDialog(context: context, subtitle: error.toString(), fct: () {});
      } finally {
        // İşlem tamamlandığında loading durumunu güncelleyin
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Localden image çekebilmek için

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const GradyanTheme(),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomSheet: SizedBox(
              height: kBottomNavigationBarHeight + 10,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Container(
                  color: Color.fromARGB(255, 208, 243, 248),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          backgroundColor: const Color.fromARGB(255, 242, 209, 109),
                        ),
                        onPressed: clearForm,
                        label: Text("Clear"),
                        icon: Icon(Icons.clear),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          backgroundColor: const Color.fromARGB(255, 242, 209, 109),
                        ),
                        onPressed: () {
                          if (isEditing) {
                            _editBooks();
                          } else {
                            _addBooks();
                          }
                        },
                        label: Text(
                          isEditing ? "Save Book" : "New Book",
                        ),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 248, 250, 216),
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
                label: isEditing ? "Edit Book" : "New Book",
              ),
            ),
            body: LoadingManager(
              isLoadlin: _isLoading,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      if (isEditing && productNetworkImage != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            productNetworkImage!,
                            height: size.height * 0.7,
                            alignment: Alignment.center,
                          ),
                        ),
                      ] else if (_pickedImage == null) ...[
                        SizedBox(
                          width: size.width * 0.4 + 10,
                          height: size.height * 0.2,
                          child: DottedBorder(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 80,
                                    color: Colors.amber,
                                  ),
                                  TextButton(
                                    onPressed: localImagePicker,
                                    child: Text("Add Image"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_pickedImage!.path),
                            height: size.width * 0.5,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                      if (_pickedImage != null || productNetworkImage != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: localImagePicker,
                              child: Text("Add Image"),
                            ),
                            TextButton(
                              onPressed: removePickedImage,
                              child: Text(
                                "Remove Image",
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      ],
                      DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: const Color.fromARGB(255, 209, 209, 209),
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          underline: SizedBox(),
                          value: _categoryValue,
                          hint: Text("Chose a category"),
                          items: AppConstans.catogoriesDropDownList,
                          onChanged: (String? value) {
                            setState(() {
                              _categoryValue = value;
                            });
                          }),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                key: ValueKey("Title"),
                                maxLength: 80,
                                minLines: 1,
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration(
                                  hintText: "Book Title:",
                                ),
                                validator: (value) {
                                  return MyValidators.uploadBookText(
                                    value: value,
                                    toBeReturnedString: "Please enter a valid title",
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _writerController,
                                      key: ValueKey("Writer"),
                                      minLines: 1,
                                      maxLines: 1,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        prefix: SubTitleTextWidget(
                                          label: "B.W.",
                                          color: Colors.blue,
                                        ),
                                        hintText: "Book Writer:",
                                      ),
                                      validator: (value) {
                                        return MyValidators.uploadBookText(
                                          value: value,
                                          toBeReturnedString: "Please enter a writer",
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 1, // Diğeri ile aynı miktarda alan kaplayacak
                                    child: TextFormField(
                                      controller: _quantityController,
                                      key: ValueKey("quantity"),
                                      minLines: 1,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        prefix: SubTitleTextWidget(
                                          label: "QTY:",
                                          color: Colors.blue,
                                        ),
                                        hintText: "Quantity:",
                                      ),
                                      validator: (value) {
                                        return MyValidators.uploadBookText(
                                          value: value,
                                          toBeReturnedString: "Quantity is missing",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _publishedController,
                                      key: ValueKey("Publisher"),
                                      minLines: 1,
                                      maxLines: 1,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        prefix: SubTitleTextWidget(
                                          label: "P:",
                                          color: Colors.blue,
                                        ),
                                        hintText: "Publisher:",
                                      ),
                                      validator: (value) {
                                        return MyValidators.uploadBookText(
                                          value: value,
                                          toBeReturnedString: "Please enter a Publisher",
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 1, // Diğeri ile aynı miktarda alan kaplayacak
                                    child: TextFormField(
                                      controller: _PageCountController,
                                      key: ValueKey("Pages"),
                                      minLines: 1,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        prefix: SubTitleTextWidget(
                                          label: "QTY:",
                                          color: Colors.blue,
                                        ),
                                        hintText: "Number of pages:",
                                      ),
                                      validator: (value) {
                                        return MyValidators.uploadBookText(
                                          value: value,
                                          toBeReturnedString: "Number of pages is missing",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _descriptionController,
                                key: ValueKey("Description"),
                                minLines: 5,
                                maxLines: 8,
                                maxLength: 1000,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  prefix: SubTitleTextWidget(
                                    label: "D:",
                                    color: Colors.blue,
                                  ),
                                  hintText: "Description:",
                                ),
                                validator: (value) {
                                  return MyValidators.uploadBookText(
                                    value: value,
                                    toBeReturnedString: "Description is problematic",
                                  );
                                },
                              ),
                              SizedBox(height: kBottomNavigationBarHeight + 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
