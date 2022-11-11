import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meery_timer/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({Key key}) : super(key: key);

  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  bool loading = false;
  String backgroundType = "";
  Future<void> getBackground() async {
    final preferences = await SharedPreferences.getInstance();
    backgroundType = preferences.getString("background");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBackground(),
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
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          backgroundType == "Police"
                              ? "assets/backgroundtwo.jpg"
                              : "assets/background.jpg",
                        ),
                        fit: BoxFit.cover)),
                alignment: Alignment.center,
                // color: Color.fromRGBO(195, 176, 144, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(15)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text(
                        "هتسلّم امتي يا دفعة؟",
                        style: TextStyle(
                            package: "google_fonts_arabic",
                            fontFamily: ArabicFonts.Amiri,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    !loading
                        ? RawMaterialButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2100, 1, 1),
                                  locale: LocaleType.ar,
                                  theme: DatePickerTheme(
                                      itemStyle: TextStyle(
                                    fontSize: 16,
                                    package: "google_fonts_arabic",
                                    fontFamily: ArabicFonts.Cairo,
                                  )), onConfirm: (date) async {
                                setState(() {
                                  loading = true;
                                });
                                int timeStamp = date.millisecondsSinceEpoch;
                                final sharedPreference =
                                    await SharedPreferences.getInstance();
                                sharedPreference.setInt("dateKey", timeStamp);
                                print(date.toString());
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              });
                            },
                            elevation: 10.0,
                            fillColor: Colors.white70,
                            child: Text("دخّل معاد تسليمك",
                                style: TextStyle(
                                    fontSize: 16,
                                    package: "google_fonts_arabic",
                                    fontFamily: ArabicFonts.Cairo,
                                    fontWeight: FontWeight.bold)),
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
