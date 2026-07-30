import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/theme/app_colors.dart';


class MapSearchPage extends StatefulWidget {

  const MapSearchPage({super.key});


  @override
  State<MapSearchPage> createState() =>
      _MapSearchPageState();

}



class _MapSearchPageState extends State<MapSearchPage> {


final MapController mapController =
MapController();


final TextEditingController searchController =
TextEditingController();



LatLng? currentLocation;

LatLng? searchedLocation;



final DatabaseReference _database =
FirebaseDatabase.instance
.ref("live_locations");



StreamSubscription<DatabaseEvent>?
_locationSubscription;



final List<Marker> liveBusMarkers = [];




final FirebaseFirestore firestore =
FirebaseFirestore.instance;




@override
void initState() {

super.initState();


getCurrentLocation();


listenForLiveBuses();

}




@override
void dispose() {


searchController.dispose();


_locationSubscription?.cancel();


super.dispose();

}




Future<void> getCurrentLocation() async {


bool enabled =
await Geolocator.isLocationServiceEnabled();


if(!enabled){

return;

}



LocationPermission permission =
await Geolocator.checkPermission();



if(permission ==
LocationPermission.denied){


permission =
await Geolocator.requestPermission();


}



if(permission ==
LocationPermission.denied ||
permission ==
LocationPermission.deniedForever){


return;

}




Position position =
await Geolocator.getCurrentPosition();




setState(() {


currentLocation =
LatLng(
position.latitude,
position.longitude
);


});



mapController.move(
currentLocation!,
16
);

}




Future<void> searchLocation(
String query
) async {


if(query.trim().isEmpty){

return;

}



final url = Uri.parse(

"https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1",

);




final response =
await http.get(

url,

headers: {

"User-Agent":
"CeyGo/1.0"

},

);




if(response.statusCode == 200){


final data =
jsonDecode(response.body);



if(data.isNotEmpty){


final lat =
double.parse(
data[0]["lat"]
);



final lon =
double.parse(
data[0]["lon"]
);




setState(() {


searchedLocation =
LatLng(
lat,
lon
);


});



mapController.move(
searchedLocation!,
16
);


}

}

}




  Future<Map<String,dynamic>?> getRouteData(
      String routeId
      ) async {


    // Temporary mapping

    Map<String,String> routeMapping = {

      "route_001":
      "Zl21qkgaUAFZvDkgWCZA",

    };


    String? documentId =
    routeMapping[routeId];


    if(documentId == null){

      return null;

    }



    final snapshot =
    await firestore
        .collection("routes")
        .doc(documentId)
        .get();



    if(snapshot.exists){

      return snapshot.data();

    }



    return null;

  }



void listenForLiveBuses(){



_locationSubscription =
_database.onValue.listen(
(event){



final data =
event.snapshot.value;



if(data == null){

return;

}




final buses =
Map<dynamic,dynamic>.from(
data as Map
);




final List<Marker> markers =
[];





buses.forEach(
(busId,value){



final bus =
Map<dynamic,dynamic>.from(
value as Map
);




if(bus["latitude"] != null &&
bus["longitude"] != null){





final latitude =
(bus["latitude"] as num)
.toDouble();



final longitude =
(bus["longitude"] as num)
.toDouble();





final heading =
(bus["heading"] ?? 0)
.toDouble();






markers.add(


Marker(

point:
LatLng(
latitude,
longitude
),



width:80,

height:80,




child:
GestureDetector(



onTap: () async {



final route =
await getRouteData(
bus["routeId"]
);



showBusInformation(

busId.toString(),

bus,

route,

);


},




child:

Column(

mainAxisSize:
MainAxisSize.min,



children: [



Container(

padding:
const EdgeInsets.symmetric(
horizontal:4
),


color:
Colors.white,



child:
Text(

busId.toString(),

style:
const TextStyle(

fontSize:12,

fontWeight:
FontWeight.bold,

),

),

),






Transform.rotate(


angle:
heading *
3.14159 /
180,



child:

Image.asset(

"assets/images/bus_marker.png",


width:40,


height:40,


),


),



],


),


),


),


);

}


});




setState((){


liveBusMarkers

..clear()

..addAll(markers);


});



});



}


void showBusInformation(
String busId,
Map<dynamic, dynamic> bus,
Map<String, dynamic>? route,
) {


showModalBottomSheet(

context: context,

isScrollControlled: true,

backgroundColor: Colors.transparent,


builder: (context){


return DraggableScrollableSheet(


initialChildSize: 0.40,

minChildSize: 0.25,

maxChildSize: 0.70,



builder:
(context, scrollController){



return Container(


decoration:
const BoxDecoration(


color:
Colors.white,



borderRadius:
BorderRadius.only(


topLeft:
Radius.circular(30),


topRight:
Radius.circular(30),


),


),




child:
SingleChildScrollView(


controller:
scrollController,



child:
Padding(


padding:
const EdgeInsets.all(20),



child:
Column(



crossAxisAlignment:
CrossAxisAlignment.start,



children: [



Center(


child:
Container(


width:45,

height:5,


decoration:
BoxDecoration(


color:
Colors.grey.shade400,


borderRadius:
BorderRadius.circular(20),


),


),


),




const SizedBox(height:20),





Row(


children: [



Image.asset(

"assets/images/bus_marker.png",

width:45,

height:45,

),




const SizedBox(width:15),




Text(

busId,


style:
const TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),


),


],


),




const SizedBox(height:25),






_infoRow(

"Route",

"${route?["start"] ?? "Unknown"} → ${route?["destination"] ?? "Unknown"}",

),




_infoRow(

"Route Number",

route?["routeNumber"] ?? "Unknown",

),





_infoRow(

"Distance",

"${route?["distance"] ?? 0} km",

),





_infoRow(

"Speed",

"${bus["speed"] ?? 0} km/h",

),




_infoRow(

"Direction",

"${bus["heading"] ?? 0}°",

),





const SizedBox(height:20),




const Text(

"Stops",

style:
TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),





const SizedBox(height:10),





if(route?["stops"] != null)

...(route!["stops"] as List)
.map((stop){


return ListTile(



contentPadding:
EdgeInsets.zero,



leading:
const Icon(

Icons.location_on,

color:
AppColors.primary,

),




title:
Text(

stop["name"] ?? "",

),




trailing:
Text(

stop["eta"] ?? "",

style:
const TextStyle(

fontWeight:
FontWeight.bold,

),

),



);



}),




const SizedBox(height:20),





_infoRow(

"Last Update",

DateTime
.fromMillisecondsSinceEpoch(

bus["updatedAt"] ?? 0,

).toString(),

),




],


),


),


),


);

},

);


},


);


}





Widget _infoRow(

String title,

String value,

){



return Padding(


padding:
const EdgeInsets.symmetric(
vertical:8
),




child:
Row(


mainAxisAlignment:
MainAxisAlignment.spaceBetween,



children: [



Text(


title,


style:
const TextStyle(

color:
Colors.grey,

fontSize:16,

),



),





Flexible(

child:
Text(


value,


textAlign:
TextAlign.right,



style:
const TextStyle(

fontSize:16,

fontWeight:
FontWeight.w600,

),



),

),



],


),



);


}







@override
Widget build(BuildContext context) {


return Scaffold(



body:
Stack(



children: [



FlutterMap(



mapController:
mapController,



options:
MapOptions(


initialCenter:
const LatLng(

6.9934,

81.0550,

),



initialZoom:
13,


),




children: [



TileLayer(



urlTemplate:

"https://tile.openstreetmap.org/{z}/{x}/{y}.png",




userAgentPackageName:

"com.ceygo.transportation",



),






MarkerLayer(



markers:

[



if(currentLocation != null)


Marker(



point:
currentLocation!,



width:50,

height:50,



child:
const Icon(

Icons.pin_drop,

color:
AppColors.primary,

size:35,

),



),





if(searchedLocation != null)



Marker(



point:
searchedLocation!,



width:50,

height:50,



child:
const Icon(

Icons.location_pin,

color:
Colors.red,

size:45,

),



),




]

..addAll(liveBusMarkers),




),



],



),






SafeArea(



child:
Padding(



padding:
const EdgeInsets.all(20),




child:
TextField(



controller:
searchController,



onSubmitted:
searchLocation,



decoration:
InputDecoration(



hintText:
"Search destination",




prefixIcon:
IconButton(



icon:
const Icon(

Icons.search,

color:
AppColors.primary,

),



onPressed: (){



searchLocation(

searchController.text

);



},



),



filled:true,


fillColor:
Colors.white,




border:
OutlineInputBorder(



borderRadius:
BorderRadius.circular(20),



borderSide:
BorderSide.none,



),




),



),



),



),




Positioned(



bottom:30,


right:20,



child:
FloatingActionButton(



backgroundColor:
AppColors.primary,



onPressed:
getCurrentLocation,



child:
const Icon(

Icons.my_location,

color:
Colors.white,

),



),



),



],



),



);


}}