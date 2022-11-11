import 'package:flutter/material.dart';
import 'package:meery_timer/screens/date_picker_screen.dart';
import 'package:meery_timer/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkDate() async {
    final preferences = await SharedPreferences.getInstance();
    bool dateSet = preferences.containsKey("dateKey");
    return dateSet;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'عداد الميري',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: checkDate(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data) {
                  return HomeScreen();
                } else {
                  return DatePickerScreen();
                }
              } else {
                return Container();
              }
            }));
  }
}
