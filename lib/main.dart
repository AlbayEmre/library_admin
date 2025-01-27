import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lib_admin/Colors/theme_Data.dart';
import 'package:lib_admin/Provider/Product_Provider.dart';
import 'package:lib_admin/Provider/theme_provider.dart';
import 'package:lib_admin/screens/Dashboard_Screen.dart';
import 'package:lib_admin/screens/Serach_Screen.dart';
import 'package:lib_admin/screens/editorUploadProduct.dart';
import 'package:lib_admin/widget/Order/order_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(), //Firebase'yi başlatmak için kullanılır
      //! AsyncSnapshot  -> ile bir hata dönerse onu kontrol için
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) //asenkron işlemin devam etmekte
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          //Eyer başarısız olur ise
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: SelectableText(snapshot.error.toString()),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            //!Burda   Providerleimizi Belirtmrliyiz
            ChangeNotifierProvider(
              create: (_) {
                return ThemeProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return ProductProvider();
              },
            ),
          ],

          //todo ->Conumer : genellikle bir değişkenin değerini dinleyip görüntülemek için kullanılan bir widgettir
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) // themeProvider ile tamayı dinliyoruz
                {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Library_Admin ", //!! Deyişecek

                theme: styles.themeData(
                  isDarkTheme: themeProvider.getIsDerkTehme,
                  context: context,
                ), //!Gelen veriye göre dark<> light arasidna geçiş yapıyoruz

                // home: LoginScreen(), //RootScreen
                home: DashboardScreen(),

                //!Ekranda doğrudan Navigator.pushname((context), ViwedResentyScreen.routName ) ile gidebilmek için kullanılır
                //   routes: {},
                routes: {
                  OrderScreen.routName: (context) => OrderScreen(), //pushNamed için
                  SearchScreen.routName: (context) => SearchScreen(), //pushNamed için
                  EditoruploadproductScreen.routName: (context) => EditoruploadproductScreen(), //pushNamed için
                },
              );
            },
          ),
        );
      },
    );
  }
}
