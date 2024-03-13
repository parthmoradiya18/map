import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/global.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Permission.location.request();
  }

  Placemark? placeMark;
  TextStyle textStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black.withOpacity(0.7),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          titleSpacing: 20,
          title: const Text("Live Location & Google Map"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                openAppSettings();
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: (placeMark != null)
            ? Column(
                children: [
                  const SizedBox(height: 30),
                  Text("Latitude : ${Global.lat}", style: textStyle),
                  const SizedBox(height: 10),
                  Text("Longitude : ${Global.long}", style: textStyle),
                  const SizedBox(height: 50),
                  Text(placeMark.toString(), style: textStyle),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        Global.mapLocation =
                            "https://www.google.co.in/search?q=$Global.lat,$Global.long";
                      });
                      Navigator.of(context).pushNamed("google_map_page");
                    },
                    splashColor: Global.appColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: Global.appColor),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.70,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Spacer(),
                            Icon(
                              Icons.location_on_sharp,
                              size: 35,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Go to Map",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Global.appColor,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            : Center(
                child: Column(
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.map,
                      size: 150,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tap Location Button \nto Get Live Location",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Global.appColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on),
        onPressed: () async {
          var status = Permission.location.status;
          if (await status.isDenied) {
            Permission.location.request();
          }
          Geolocator.getPositionStream().listen((Position position) async {
            setState(() {
              Global.lat = position.latitude;
              Global.long = position.longitude;
            });

            List placeMarkList =
                await placemarkFromCoordinates(Global.lat, Global.long);

            setState(() {
              placeMark = placeMarkList[0];
            });
          });
        },
      ),
    );
  }
}
