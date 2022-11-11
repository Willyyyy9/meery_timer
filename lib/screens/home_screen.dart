import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:meery_timer/screens/date_picker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool lessThanZero = false;
  String backgroundType = "";

  String replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }

    return input;
  }

  Future<String> getDaysLeft() async {
    final preferences = await SharedPreferences.getInstance();
    backgroundType = preferences.getString("background");
    print(backgroundType);
    int dateStamp = preferences.getInt("dateKey");
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateStamp);
    print(dateTime.difference(DateTime.now()).inDays.toString());
    if (dateTime.difference(DateTime.now()).inDays < 0) {
      lessThanZero = true;
      return replaceFarsiNumber("0");
    } else
      return replaceFarsiNumber(
          dateTime.difference(DateTime.now()).inDays.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getDaysLeft(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: Get.height * 0.2,
                  centerTitle: true,
                  title: ToggleSwitch(
                    fontSize: 16.0,
                    initialLabelIndex: backgroundType == "Police" ? 0 : 1,
                    cornerRadius: 16,
                    activeBgColors: [
                      [Colors.blue],
                      [Colors.brown]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.grey[900],
                    customTextStyles: [
                      TextStyle(
                          package: "google_fonts_arabic",
                          fontFamily: ArabicFonts.Amiri,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      TextStyle(
                          package: "google_fonts_arabic",
                          fontFamily: ArabicFonts.Amiri,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ],
                    labels: ['داخلية', 'حربية'],
                    onToggle: (index) async {
                      final preferences = await SharedPreferences.getInstance();
                      String type = '';
                      if (index == 0) {
                        type = "Police";
                      } else if (index == 1) {
                        type = "Military";
                      }
                      await preferences.setString("background", type);

                      setState(() {
                        backgroundType = type;
                      });
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                extendBodyBehindAppBar: true,
                extendBody: true,
                bottomNavigationBar: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: RawMaterialButton(
                      onPressed: () async {
                        final preferences =
                            await SharedPreferences.getInstance();
                        preferences.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DatePickerScreen()),
                            (route) => false);
                      },
                      elevation: 4.0,
                      fillColor: Colors.white60,
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                      ),
                      padding: EdgeInsets.all(5),
                      shape: CircleBorder()),
                ),
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            backgroundType == "Police"
                                ? "assets/backgroundtwo.jpg"
                                : "assets/background.jpg",
                          ),
                          fit: BoxFit.cover)),
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        child: lessThanZero
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "مبــروك",
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "يا",
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "ابو التسليم",
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.data,
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "ايام",
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "يا ميـري",
                                    style: TextStyle(
                                        package: "google_fonts_arabic",
                                        fontFamily: ArabicFonts.Amiri,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
