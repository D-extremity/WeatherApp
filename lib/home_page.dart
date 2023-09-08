import 'dart:convert';
// import 'dart:html';
// import 'dart:js_interop';
import 'dart:ui';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/additional_info.dart';
import 'package:weather/hourly_forecast.dart';
import 'package:weather/meant_to_be_hidden.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainHomePage();
  }
}

String newCity = "delhi";

class _MainHomePage extends State<StatefulWidget> {
  String temp = "+-";
  String weather = '----';
  IconData icon = Icons.satellite_alt_outlined;
  @override
  void initState() {
    super.initState();
    // print(newCity);

    ///to start it as before building of other things to get less awaiting time
    // getCurrentWeather(city: newCity);
  }

  Future getCurrentWeather({required String city}) async {
    try {
      final result = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$appId",
        ),
      );
      // debugPrint(result.body);
      final data = jsonDecode(result.body);
      // print(data['cod'].runtimeType);
      if (data['cod'] != '200') {
        setState(() {
          newCity = "Delhi";
        });
      }

      return data; //returning fetched api data
    } catch (e) {
      // ignore: use_build_context_synchronously
      throw "Error Occured";
    }
    // print(data['list'][0]['weather'][0]['description']);

    // print(data['cod']);
    // print(data['list'][0]['main']['temp']);
    // print(mainTemp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentWeather(city: newCity),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              alignment: Alignment.center,
              child: Lottie.asset("assets/animation/satellite.json",
                  animate: true));
        }
        if (snapshot.hasError) {
          throw "Error Occured";
        }

        final data = snapshot.data!;

        double mainTemp = data['list'][0]['main']['temp'] - 273;
        weather = data['list'][0]['weather'][0]['description'];
        temp = mainTemp.toStringAsFixed(1);
        String skyIcon = data['list'][0]['weather'][0]['main'];
        IconData iconData;
        switch (skyIcon) {
          case 'Coluds':
            iconData = Icons.cloud_outlined;
          case 'Clear':
            iconData = Icons.satellite_alt_outlined;
          case 'Rain':
            iconData = Icons.thunderstorm_outlined;
          case 'Snow':
            iconData = Icons.ac_unit_sharp;
          default:
            iconData = Icons.wb_sunny;
        }
        final humid = data['list'][0]['main']['humidity'];
        final pressure = data['list'][0]['main']['pressure'];
        final maxTemp = (data['list'][0]['main']['temp_max'] - 273)
            .toString()
            .substring(0, 4);
        final speed =
            (data['list'][0]['wind']['speed'] * 4).toString().substring(0, 4);
        IconData skYIcon(String sky) {
          IconData iconData;
          iconData = switch (sky) {
            'Coluds' => Icons.cloud_outlined,
            'Clear' => Icons.satellite_alt_outlined,
            'Rain' => Icons.thunderstorm_outlined,
            'Snow' => Icons.ac_unit_sharp,
            _ => Icons.wb_sunny
          };
          return iconData;
        }

        TextEditingController getCity = TextEditingController();
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade900,
            appBar: AppBar(
              title: const Text(
                "Weather",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.grey.shade900,
              elevation: 0,
              actions: [
                Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 180,
                      height: 40,
                      child: TextField(
                        enableInteractiveSelection: true,
                        onTapOutside: (event) =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        controller: getCity,
                        style: const TextStyle(
                          textBaseline: TextBaseline.ideographic,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          hintText: "  Patna",
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    if (getCity.text.toString().isNotEmpty) {
                      // print(getCity.text.toString());
                      try {
                        setState(() {
                          newCity = getCity.text.toString();
                        });
                      } catch (e) {
                        setState(() {
                          newCity = "delhi";
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Empty Field")));
                    }
                  },
                  icon: const Icon(Icons.find_replace_rounded),
                  iconSize: 30,
                  // alignment: const Alignment(300, 300),
                  hoverColor: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                // textDirection: TextDirection.ltr,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Card(
                          color: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: const Color.fromARGB(255, 234, 229, 229),
                          margin: const EdgeInsetsDirectional.only(top: 30),
                          elevation: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(newCity.substring(0, 1).toUpperCase() +
                                  newCity.substring(1)),
                              Text(
                                "$temp°C",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 60,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                iconData,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 10,
                                width: 40,
                              ),
                              Text(
                                weather,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 30),
                      child: Text(
                        "Weather Forecast",
                        textAlign: TextAlign.left,
                        // textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 3),
                    // child: SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       for (int i = 1; i <= 8; i++)
                    //         HourlyForecast(
                    //           time:
                    //               "${DateTime.parse(data['list'][i]['dt_txt']).hour}:${DateTime.parse(data['list'][i]['dt_txt']).minute}",
                    //           icon: skYIcon(
                    //               data['list'][i]['weather'][0]['main'].toString()),
                    //           temp: (data['list'][0]['main']['temp'] - 273)
                    //               .toString()
                    //               .substring(0, 4),
                    //         ),
                    //     ],
                    //   ),
                    // ),

                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          ///Custom made time
                          /* String meredian = "AM";
                          int  hour =
                              DateTime.parse(data['list'][index + 1]['dt_txt'])
                                  .hour;
                          if (hour >= 12 && hour < 24) {
                            meredian = "PM";
                          }
                          if (hour > 12) {
                            hour -= 12;
                          } else if (hour == 0) {
                            hour = 12;
                          }
                          final String time = "${hour.abs()} $meredian";*/

                          ///Using Package intl now
                          ///read documentation at pub.cev
                          ///can be done like also
                          /// final time = DateFormat('j').format(DateTime.parse(data['list'][index + 1]['dt_txt']));

                          final time = DateFormat.j().format(DateTime.parse(
                              data['list'][index + 1]['dt_txt']));

                          //index+1 was not rrequired but did it because index starts from 0 and Oth value we are already showing in main card above
                          final IconData iconIs = skYIcon(data['list']
                                  [index + 1]['weather'][0]['main']
                              .toString());
                          final String temp =
                              (data['list'][index + 1]['main']['temp'] - 273)
                                  .toString()
                                  .substring(0, 4);
                          return HourlyForecast(
                              time: time.toString(), icon: iconIs, temp: temp);
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                    width: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Additional Information",
                        // textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Additional(
                            icon: Icons.water_drop_outlined,
                            title: "Humidity",
                            value: "$humid%",
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Additional(
                              icon: Icons.air_sharp,
                              title: "Wind Speed",
                              value: "$speed km/hr")
                        ],
                      ),
                      Column(
                        children: [
                          Additional(
                            icon: Icons.downloading_sharp,
                            title: "Pressure",
                            value: "$pressure hPa",
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Additional(
                            icon: Icons.wb_sunny_outlined,
                            title: "Max Temp",
                            value: "$maxTemp°C",
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
