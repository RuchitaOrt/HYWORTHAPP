// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:hyworth_land_survey/Utils/commoncolors.dart';

// const String googleApiKey = "YOUR_GOOGLE_API_KEY"; // Replace with your API Key

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLatLng;
//   String _currentAddress = "";
//   Marker? _marker;

//   final places = GoogleMapsPlaces(apiKey: googleApiKey);
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   final BorderSide enableBorder = BorderSide(
//     color: CommonColors.background,
//     width: 1.0,
//   );

//   final BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));
//   final BorderSide focusedBorder = BorderSide(
//     color: CommonColors.blue,
//     width: 1.0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // Get current GPS location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _currentLatLng = LatLng(position.latitude, position.longitude);
//     _marker = Marker(
//       markerId: MarkerId("selected"),
//       position: _currentLatLng!,
//       infoWindow: InfoWindow(title: "Your Location"),
//     );

//     await _getAddressFromLatLng(_currentLatLng!);
//     setState(() {});
//   }

//   // Convert LatLng to human-readable address
//   Future<void> _getAddressFromLatLng(LatLng latLng) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//     Placemark place = placemarks.first;

//     setState(() {
//       _currentAddress =
//           "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
//       _marker = Marker(
//         markerId: MarkerId("selected"),
//         position: latLng,
//         infoWindow:
//             InfoWindow(title: "Selected Location", snippet: _currentAddress),
//       );
//     });
//   }

//   // Handle map tap
//   void _onMapTap(LatLng tappedPoint) {
//     _currentLatLng = tappedPoint;
//     _getAddressFromLatLng(tappedPoint);
//   }

//   // Get autocomplete suggestions from Google Places
//   Future<List<Prediction>> _getSuggestions(String input) async {
//     if (input.isEmpty) return [];
//     final response = await places.autocomplete(input);
//     if (response.isOkay) {
//       return response.predictions;
//     } else {
//       return [];
//     }
//   }

//   // When a suggestion is selected
//   Future<void> _selectPrediction(Prediction prediction) async {
//     final detail = await places.getDetailsByPlaceId(prediction.placeId!);
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;

//     _currentLatLng = LatLng(lat, lng);
//     _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 16));
//     await _getAddressFromLatLng(_currentLatLng!);
//     _searchController.text = detail.result.name;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pick Location")),
//       body: _currentLatLng == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 // Google Map
//                 GoogleMap(
//                   initialCameraPosition:
//                       CameraPosition(target: _currentLatLng!, zoom: 16),
//                   onMapCreated: (controller) => _mapController = controller,
//                   markers: _marker != null ? {_marker!} : {},
//                   onTap: _onMapTap,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                 ),

//                 // Search bar
//               // Search bar
// Positioned(
//   top: 10,
//   left: 15,
//   right: 15,
//   child: Material(
//     elevation: 5,
//     borderRadius: BorderRadius.circular(8),
//     child: Container(
//       height: 50, // fixed height
//       child: TypeAheadField<Prediction>(
//         controller: _searchController,
//         focusNode: _focusNode,
//         suggestionsCallback: (pattern) async => await _getSuggestions(pattern),
//         itemBuilder: (context, Prediction suggestion) {
//           return ListTile(title: Text(suggestion.description ?? ''));
//         },
//         onSelected: (Prediction suggestion) async {
//           await _selectPrediction(suggestion);
//         },
//         builder: (context, controller, focusNode) {
//           return TextField(
//             controller: controller,
//             focusNode: focusNode,
//             decoration: InputDecoration(
//               hintText: "Search location",
//               filled: true,
//               fillColor: CommonColors.white,
//               prefixIcon: Icon(Icons.search),
//                border: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
//         focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
//         enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
//         disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
//         errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
//         focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      
//             ),
//           );
//         },
//       ),
//     ),
//   ),
// ),


//                 // Confirm location card
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Selected Address:",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 5),
//                           Text(_currentAddress),
//                           SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context, {
//                                 "lat": _currentLatLng!.latitude,
//                                 "lng": _currentLatLng!.longitude,
//                                 "address": _currentAddress,
//                               });
//                             },
//                             child: Text("Confirm Location"),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_typeahead/flutter_typeahead.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:google_maps_webservice/places.dart';
// // import 'package:hyworth_land_survey/Utils/commoncolors.dart';

// // const String googleApiKey = "AIzaSyBI08oetbPYPu-g8L2T7NkDrQ4kquAs0ak"; // Replace with your API key

// // class LocationPickerScreen extends StatefulWidget {
// //   @override
// //   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// // }

// // class _LocationPickerScreenState extends State<LocationPickerScreen> {
// //   GoogleMapController? _mapController;
// //   LatLng? _currentLatLng;
// //   String _currentAddress = "";
// //   Marker? _marker;
// //  final TextEditingController _controller = TextEditingController();

// //   final places = GoogleMapsPlaces(apiKey: googleApiKey);
// //   final TextEditingController _searchController = TextEditingController();
// // final FocusNode _focusNode = FocusNode();
// //   final BorderSide enableBorder = BorderSide(
// //     color: CommonColors.background,
// //     // color: CraftColors.neutral20Color,
// //     width: 1.0,
// //   );
// //   final BorderRadius borderRadius = const BorderRadius.all(
    
// //     Radius.circular(8),
// //   );
// //   final BorderSide focusedBorder = const BorderSide(
// //      color: CommonColors.blue,
// //     width: 1.0,
// //   );

// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //   }

// //   // Get current GPS location
// //   Future<void> _getCurrentLocation() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;

// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       return Future.error('Location services are disabled.');
// //     }

// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('Location permissions are denied');
// //       }
// //     }

// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _currentLatLng = LatLng(position.latitude, position.longitude);
// //     _marker = Marker(
// //       markerId: MarkerId("selected"),
// //       position: _currentLatLng!,
// //       infoWindow: InfoWindow(title: "Your Location"),
// //     );

// //     await _getAddressFromLatLng(_currentLatLng!);
// //     setState(() {});
// //   }

// //   // Convert LatLng to human-readable address
// //   Future<void> _getAddressFromLatLng(LatLng latLng) async {
// //     List<Placemark> placemarks =
// //         await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
// //     Placemark place = placemarks.first;

// //     setState(() {
// //       _currentAddress =
// //           "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
// //       _marker = Marker(
// //         markerId: MarkerId("selected"),
// //         position: latLng,
// //         infoWindow: InfoWindow(title: "Selected Location", snippet: _currentAddress),
// //       );
// //     });
// //   }

// //   void _onMapTap(LatLng tappedPoint) {
// //     _currentLatLng = tappedPoint;
// //     _getAddressFromLatLng(tappedPoint);
// //   }

// //   // Get autocomplete suggestions from Google Places
// //   Future<List<Prediction>> _getSuggestions(String input) async {
// //     if (input.isEmpty) return [];
// //     final response = await places.autocomplete(input);
// //     if (response.isOkay) {
// //       return response.predictions;
// //     } else {
// //       return [];
// //     }
// //   }

// //   // When a suggestion is selected
// //   Future<void> _selectPrediction(Prediction prediction) async {
// //     final detail = await places.getDetailsByPlaceId(prediction.placeId!);
// //     final lat = detail.result.geometry!.location.lat;
// //     final lng = detail.result.geometry!.location.lng;

// //     _currentLatLng = LatLng(lat, lng);
// //     _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLatLng!));
// //     await _getAddressFromLatLng(_currentLatLng!);
// //     _searchController.text = detail.result.name;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Pick Location")),
// //       body: _currentLatLng == null
// //           ? Center(child: CircularProgressIndicator())
// //           : Stack(
// //               children: [
// //                 // Google Map
// //                 GoogleMap(
// //                   initialCameraPosition: CameraPosition(
// //                     target: _currentLatLng!,
// //                     zoom: 16,
// //                   ),
// //                   onMapCreated: (controller) => _mapController = controller,
// //                   markers: _marker != null ? {_marker!} : {},
// //                   onTap: _onMapTap,
// //                   myLocationEnabled: true,
// //                   myLocationButtonEnabled: true,
// //                 ),

// //                 // Search bar
// //                 SafeArea(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
// //                     child: TypeAheadField<String>(
// //   controller: _controller,
// //   suggestionsCallback: (pattern) async {
// //     return (await _getSuggestions(pattern)).map((p) => p.description!).toList();
// //   },
// //   itemBuilder: (context, suggestion) {
// //     return ListTile(title: Text(suggestion));
// //   },
// //   onSelected: (suggestion) async {
// //     final prediction = (await _getSuggestions(suggestion))
// //         .firstWhere((p) => p.description == suggestion);
// //     await _selectPrediction(prediction);
// //   },
// //   builder: (context, controller, focusNode) {
// //     return TextField(
// //       controller: controller,
// //       focusNode: focusNode,
// //       decoration: InputDecoration(
// //         hintText: "Search location",
       
// //         filled: true,
// //         border: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
// //         focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
// //         enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
// //         disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
// //         errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
// //         focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
       
// //         fillColor: CommonColors.white,
// //         prefixIcon: Icon(Icons.search),
// //       ),
// //     );
// //   },
// // )

// //                   ),
// //                 ),

// //                 // Confirm location card
// //                 Positioned(
// //                   bottom: 20,
// //                   left: 20,
// //                   right: 20,
// //                   child: Card(
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(12.0),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Text(
// //                             "Selected Address:",
// //                             style: TextStyle(fontWeight: FontWeight.bold),
// //                           ),
// //                           SizedBox(height: 5),
// //                           Text(_currentAddress),
// //                           SizedBox(height: 10),
// //                           ElevatedButton(
// //                             onPressed: () {
// //                               Navigator.pop(context, {
// //                                 "lat": _currentLatLng!.latitude,
// //                                 "lng": _currentLatLng!.longitude,
// //                                 "address": _currentAddress,
// //                               });
// //                             },
// //                             child: Text("Confirm Location"),
// //                           )
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:geocoding/geocoding.dart';

// // class LocationPickerScreen extends StatefulWidget {
// //   @override
// //   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// // }

// // class _LocationPickerScreenState extends State<LocationPickerScreen> {
// //   GoogleMapController? _mapController;
// //   LatLng? _currentLatLng;
// //   String _currentAddress = "";
// //   Marker? _marker;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //   }

// //   Future<void> _getCurrentLocation() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;

// //     // Check location service
// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       return Future.error('Location services are disabled.');
// //     }

// //     // Check permission
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('Location permissions are denied');
// //       }
// //     }

// //     // Get current position
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _currentLatLng = LatLng(position.latitude, position.longitude);
// //     _marker = Marker(
// //       markerId: MarkerId("selected"),
// //       position: _currentLatLng!,
// //       infoWindow: InfoWindow(title: "Your Location"),
// //     );

// //     _getAddressFromLatLng(_currentLatLng!);

// //     setState(() {});
// //   }

// //   Future<void> _getAddressFromLatLng(LatLng latLng) async {
// //     List<Placemark> placemarks =
// //         await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
// //     Placemark place = placemarks.first;

// //     setState(() {
// //       _currentAddress =
// //           "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
// //       _marker = Marker(
// //         markerId: MarkerId("selected"),
// //         position: latLng,
// //         infoWindow: InfoWindow(title: "Selected Location", snippet: _currentAddress),
// //       );
// //     });
// //   }

// //   void _onMapTap(LatLng tappedPoint) {
// //     _currentLatLng = tappedPoint;
// //     _getAddressFromLatLng(tappedPoint);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Pick Location")),
// //       body: _currentLatLng == null
// //           ? Center(child: CircularProgressIndicator())
// //           : Stack(
// //               children: [
// //                 GoogleMap(
// //                   initialCameraPosition: CameraPosition(
// //                     target: _currentLatLng!,
// //                     zoom: 16,
// //                   ),
// //                   onMapCreated: (controller) => _mapController = controller,
// //                   markers: _marker != null ? {_marker!} : {},
// //                   onTap: _onMapTap,
// //                   myLocationEnabled: true,
// //                   myLocationButtonEnabled: true,
// //                 ),
// //                 Positioned(
// //                   bottom: 20,
// //                   left: 20,
// //                   right: 20,
// //                   child: Card(
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(12.0),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Text(
// //                             "Selected Address:",
// //                             style: TextStyle(fontWeight: FontWeight.bold),
// //                           ),
// //                           SizedBox(height: 5),
// //                           Text(_currentAddress),
// //                           SizedBox(height: 10),
// //                           ElevatedButton(
// //                             onPressed: () {
// //                               // Return selected lat/lng + address
// //                               Navigator.pop(context, {
// //                                 "lat": _currentLatLng!.latitude,
// //                                 "lng": _currentLatLng!.longitude,
// //                                 "address": _currentAddress
// //                               });
// //                             },
// //                             child: Text("Confirm Location"),
// //                           )
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //     );
// //   }
// // }
