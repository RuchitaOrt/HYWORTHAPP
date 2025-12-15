import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/widgets/CaptureLocation.dart';
import 'package:provider/provider.dart';

Future<void> askLocationConfirmation(
    BuildContext context, String formType) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t(context, "confirm_location")),
      content: Text(t(
          context,
          formType == "Basic"
              ? "select_location_method"
              : "select_substaion_location_method")),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            t(context, "add_manually"),
            style: CommonStyles.tsblueHeading.copyWith(fontSize: 12),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(t(context, "select_location"),
              style: CommonStyles.tsblueHeading.copyWith(fontSize: 12)),
        ),
      ],
    ),
  );

  if (result == true) {
    print("LocationPickerScreen");
    _pickLocation(context, formType);
    // captureLocation(context);
  }
}

void _pickLocation(BuildContext context, String formType) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => MapLocationPicker()),
  );

  if (result != null) {
    print("Lat: ${result['lat']}");
    print("Lng: ${result['lng']}");
    print("Address: ${result['address']}");
    final basicProvider =
        Provider.of<BasicFormProvider>(context, listen: false);
    if (formType == "Basic") {
    //  basicProvider.selectedLandTaluka!['name'] = result['taluka'];
     basicProvider.selectedLandTaluka={
  'id': '-1',
  'name': result['taluka'],
};
    //  basicProvider.selectedLandVillage!['name'] = result['village'];
     basicProvider.selectedLandVillage={
  'id': '-1',
  'name': result['village'],
};
      // basicProvider.selectedLandDistrict!['name'] = result['district'];
      basicProvider.selectedLandDistrict={
  'id': '-1',
  'name': result['district'],
};
 basicProvider.selectedLandState={
  'id': '-1',
  'name': result['states'],
};
      // basicProvider.landStateController.text = result['state'];
      basicProvider.landLatitudeController.text = result['lat'].toString();
      basicProvider.landLonitudeController.text = result['lng'].toString();
    } else {
      // basicProvider.selectedsubstationTaluka!['name']  = result['taluka'];
      basicProvider.selectedsubstationTaluka={
  'id': '-1',
  'name': result['taluka'],
};
      // basicProvider.selectedsubstationVillage!['name']  = result['village'];
       basicProvider.selectedsubstationVillage={
  'id': '-1',
  'name': result['village'],
};
      // basicProvider.selectedsubstationDistrict!['name'] = result['district'];
 basicProvider.selectedsubstationDistrict={
  'id': '-1',
  'name': result['district'],
};
      basicProvider.subStationLatitudeController.text =
          result['lat'].toString();
      basicProvider.subStationLongitudeController.text =
          result['lng'].toString();
    }

    // Save to DB or continue survey
  }
}

Future<void> captureLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check location service
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enable GPS")),
    );
    return;
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return;
  }

  // Capture current location
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  _fetchAddress(context, pos.latitude, pos.longitude);
}

Future<void> _fetchAddress(BuildContext context, double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;

    _showLocationPopup(
      context,
      lat,
      lng,
      place.locality ?? "",
      place.subAdministrativeArea ?? "",
      place.administrativeArea ?? "",
      place.country ?? "",
    );
  }
}

void _showLocationPopup(
  BuildContext context,
  double lat,
  double lng,
  String village,
  String taluka,
  String state,
  String country,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("Captured Location"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Latitude: $lat"),
          Text("Longitude: $lng"),
          Divider(),
          Text("Village: $village"),
          Text("Taluka: $taluka"),
          Text("State: $state"),
          Text("Country: $country"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            // ✅ Save to DB or continue survey
          },
          child: Text("Confirm"),
        ),
      ],
    ),
  );
}
