import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helper_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:weather_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherTracker());
}

class WeatherTracker extends StatelessWidget {
  const WeatherTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String currentImage = dayImage;
  Color buttonColor = dayButtonColor;
  dynamic humidity;
  dynamic temperature;
  String time = "";
  String date = "";
  bool ledState = true;
  late DatabaseReference ledRef;
  late DatabaseReference tempRef;
  late DatabaseReference humidityRef;
  Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  @override
  void initState() {
    super.initState();
    updateTimeAndDate();
  }

  void initializeRealtimeListeners() {
    ledRef = FirebaseDatabase.instance.ref().child('LED_State');
    tempRef = FirebaseDatabase.instance.ref().child('Temp');
    humidityRef = FirebaseDatabase.instance.ref().child('Humidity');

    tempRef.onValue.listen((DatabaseEvent event) {
      updateTimeAndDate();
      temperature = event.snapshot.value;
      setState(() {});
    });

    humidityRef.onValue.listen((DatabaseEvent event) {
      updateTimeAndDate();
      humidity = event.snapshot.value;
      setState(() {});
    });
  }

  void _toggleLED() async {
    ledState = ledState == true ? false : true;
    setState(() {});
    await ledRef.set(ledState);
  }

  void _toggleTheme() {
    setState(() {
      if (currentImage == dayImage) {
        currentImage = nightImage;
        buttonColor = nightButtonColor;
      } else {
        currentImage = dayImage;
        buttonColor = dayButtonColor;
      }
    });
  }

  void updateTimeAndDate() {
    final now = DateTime.now();
    date = "${now.day}/${now.month}/${now.year}";
    time = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    if (((now.hour >= 18 || now.hour < 6) && currentImage != nightImage) ||
        ((now.hour < 18 && now.hour > 6) && currentImage != dayImage)) {
      _toggleTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(currentImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FutureBuilder(
            future: firebase,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                initializeRealtimeListeners();
                if (temperature != null) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 210),
                    child: Column(
                      children: [
                        Text(
                          "$temperature°",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 90,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const Text(
                          "Cairo, Egypt",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildStyledText("Date: $date"),
                              const SizedBox(height: 8),
                              buildStyledText("Time: $time"),
                              const SizedBox(height: 8),
                              buildStyledText("Humidity: $humidity%"),
                              const SizedBox(height: 8),
                              buildStyledText("LED state: $ledState"),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: _toggleLED,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text("Toggle LED"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return showLoadingIndicator("Poor Internet Connection!");
                }
              } else {
                return showLoadingIndicator(
                    "Something wrong with firebase, please hold on");
              }
            },
          ),
        ),
      ),
    );
  }
}
