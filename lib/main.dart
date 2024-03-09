import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: GeolocationApp(),
    );
  }
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  // adding dependancies
  Position? _currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;

    String _currentAddress = "";

    Future<Position> _getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if(!servicePermission) {
        print("Service disabled");
        
      }
      permission = await Geolocator.checkPermission();
      if(permission==LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
      return await Geolocator.getCurrentPosition();
    }
  @override
  Widget build(BuildContext context) {
    
    

    _getAddressFromCooridnates() async {
      try{
        List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.locality}, ${place.country}";
        });
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"),
        centerTitle: true,
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Location Coordinates", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          SizedBox(height: 6,),
          Text("Latitude = ${_currentLocation?.latitude} ; Longitude = ${_currentLocation?.longitude}"),

          SizedBox(height: 30.0,),
          Text("Location Address", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          SizedBox(height: 6,),
          Text("${_currentAddress}"),

          SizedBox(height: 50,),
          ElevatedButton(onPressed: () async {
            _currentLocation = await _getCurrentLocation();
            await _getAddressFromCooridnates();
            print("${_currentLocation}");
            print("${_currentAddress}");

          }, child: Text("get Location"))
        ],
      )),
    );
  }
}