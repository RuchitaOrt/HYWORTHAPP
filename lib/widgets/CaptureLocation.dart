// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';

// class MapLocationPicker extends StatefulWidget {
//   @override
//   _MapLocationPickerState createState() => _MapLocationPickerState();
// }

// class _MapLocationPickerState extends State<MapLocationPicker> {
//   LatLng? _selectedLatLng;
//   String _address = "";
//   Marker? _marker;
//   GoogleMapController? _mapController;

//   final String kGoogleApiKey = "YOUR_API_KEY"; // Replace with your API key
//   final Mode _mode = Mode.overlay;

//   @override
//   void initState() {
//     super.initState();
//     _captureLocation();
//   }

//   Future<void> _captureLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//     if (permission == LocationPermission.deniedForever) return;

//     Position pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _selectedLatLng = LatLng(pos.latitude, pos.longitude);

//     await _fetchAddress(pos.latitude, pos.longitude);

//     setState(() {
//       _marker = Marker(
//         markerId: MarkerId("selected"),
//         position: _selectedLatLng!,
//         infoWindow: InfoWindow(title: "Your Location", snippet: _address),
//       );
//     });
//   }

//   Future<void> _fetchAddress(double lat, double lng) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       _address =
//           "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//     }
//   }

//   void _onMapTap(LatLng tappedPoint) async {
//     _selectedLatLng = tappedPoint;
//     await _fetchAddress(tappedPoint.latitude, tappedPoint.longitude);
//     setState(() {
//       _marker = Marker(
//         markerId: MarkerId("selected"),
//         position: tappedPoint,
//         infoWindow: InfoWindow(title: "Selected Location", snippet: _address),
//       );
//     });
//   }

//   Future<void> _handleSearch() async {
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       mode: _mode,
//       language: "en",
//       components: [Component(Component.country, "IN")],
//     );

//     if (p != null) {
//       GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
//       PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
//       double lat = detail.result.geometry!.location.lat;
//       double lng = detail.result.geometry!.location.lng;

//       _selectedLatLng = LatLng(lat, lng);
//       await _fetchAddress(lat, lng);

//       setState(() {
//         _marker = Marker(
//           markerId: MarkerId("selected"),
//           position: _selectedLatLng!,
//           infoWindow: InfoWindow(title: "Selected Location", snippet: _address),
//         );
//       });

//       _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedLatLng!, 16));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: GestureDetector(
//           onTap: _handleSearch,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Text(
//                   _address.isEmpty ? "Search for a place" : _address,
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _selectedLatLng == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   initialCameraPosition:
//                       CameraPosition(target: _selectedLatLng!, zoom: 16),
//                   onMapCreated: (controller) => _mapController = controller,
//                   markers: _marker != null ? {_marker!} : {},
//                   onTap: _onMapTap,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Address:",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(_address),
//                           SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context, {
//                                 "lat": _selectedLatLng!.latitude,
//                                 "lng": _selectedLatLng!.longitude,
//                                 "address": _address,
//                               });
//                             },
//                             child: Text("Confirm"),
//                           ),
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

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:provider/provider.dart';

class MapLocationPicker extends StatefulWidget {

  @override
  _MapLocationPickerState createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  LatLng? _selectedLatLng;
  String _address = "";
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _captureLocation();
  }

  Future<void> _captureLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _selectedLatLng = LatLng(pos.latitude, pos.longitude);

    await _fetchAddress(pos.latitude, pos.longitude);

    setState(() {
      _marker = Marker(
        markerId: MarkerId("selected"),
        position: _selectedLatLng!,
        infoWindow: InfoWindow(title: "Your Location", snippet: _address),
      );
    });
  }

  Future<void> _fetchAddress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      _address =
          "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  }

  void _onMapTap(LatLng tappedPoint) async {
    _selectedLatLng = tappedPoint;
    await _fetchAddress(tappedPoint.latitude, tappedPoint.longitude);
    setState(() {
      _marker = Marker(
        markerId: MarkerId("selected"),
        position: tappedPoint,
        infoWindow: InfoWindow(title: "Selected Location", snippet: _address),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Location")),
      body: _selectedLatLng == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _selectedLatLng!, zoom: 16),
                  onMapCreated: (controller) {},
                  markers: _marker != null ? {_marker!} : {},
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Address:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_address),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: ()  async {
                              final basicProvider = Provider.of<BasicFormProvider>(context, listen: false);

List<Placemark> placemarks = await placemarkFromCoordinates(
    _selectedLatLng!.latitude,
    _selectedLatLng!.longitude,
);

if (placemarks.isNotEmpty && mounted) {
  print("placemarl");
  final place = placemarks.first;

 

  _address =
      "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      print("_address");
print(_address);
  Navigator.pop(context, {
    "lat": _selectedLatLng!.latitude,
    "lng": _selectedLatLng!.longitude,
    "address": _address,
    "taluka":place.subLocality,
    "village":place.locality,
    "district":place.subAdministrativeArea,
    "state":place.administrativeArea
  });
}

//                             
                            },
                            child: Text("Confirm"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
