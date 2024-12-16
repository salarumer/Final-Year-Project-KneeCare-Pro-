import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../cost.dart';



class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Location locationController = Location();
  final String googleMapsApiKeyy = googleMapsApiKey; // Replace with your Google API Key

  static const LatLng googlePlex = LatLng(33.769837, 72.3619178);
  LatLng? currentPosition;
  Set<Polyline> polylines = {}; // Store the route polyline
  GoogleMapController? mapController; // Add this for camera controls

  // Physiotherapy centers' locations
  static const LatLng mehboobHussain = LatLng(33.768843, 72.362964);
  static const LatLng ayeshaNaveed = LatLng(33.783832, 72.362018);
  static const LatLng noorUlAin = LatLng(33.783730, 72.358144);
  static const LatLng sobiaEjaz = LatLng(33.785423, 72.357050);
  static const LatLng alinaAbbas = LatLng(33.790654, 72.360004);
  static const LatLng muzahirAbbas = LatLng(33.804385, 72.361037);
  static const LatLng kashafAmmar = LatLng(33.812580, 72.353982);

  // Hospitals
  static const LatLng CMHospital = LatLng(33.762137, 72.363537);
  static const LatLng Asfandyaarhospital = LatLng(33.78178914960794, 72.35962495153261);
  static const LatLng mutahirhospital = LatLng(33.804407, 72.361456);
  static const LatLng orthopedichospital = LatLng(33.7648444277625, 72.36103981682629);

  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      await _startLocationTracking();
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel(); // Cancel subscription on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: googlePlex,
                  zoom: 13,
                ),
                markers: _buildMarkers(),
                polylines: polylines,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
      );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  Future<void> _startLocationTracking() async {
    _locationSubscription = locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _updateCameraPosition(); // Update camera to current location
        });
      }
    });
  }

  void _updateCameraPosition() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentPosition!),
      );
    }
  }

  // Build markers for the map
  Set<Marker> _buildMarkers() {
    return {
      // Current location marker (blue)
      Marker(
        markerId: const MarkerId('currentLocation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: currentPosition!,
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
      // Existing physiotherapy centers
      _buildPhysioCenterMarker(mehboobHussain, 'Dr Mehboob Hussain'),
      _buildPhysioCenterMarker(ayeshaNaveed, 'Dr Ayesha Naveed Butt'),
      _buildPhysioCenterMarker(noorUlAin, 'Dr Noor ul Ain'),
      _buildPhysioCenterMarker(sobiaEjaz, 'Dr Sobia Ejaz'),
      _buildPhysioCenterMarker(alinaAbbas, 'Dr Alina Abbas'),
      _buildPhysioCenterMarker(muzahirAbbas, 'Dr Syed Muzahir Abbas'),
      _buildPhysioCenterMarker(kashafAmmar, 'Dr Kashaf Ammar'),
      // Hospital markers (green)
      _buildHospitalMarker(CMHospital, 'H - CM Hospital'),
      _buildHospitalMarker(Asfandyaarhospital, 'H - Asfandyaar Hospital'),
      _buildHospitalMarker(mutahirhospital, 'H - Mutahir Hospital'),
      _buildHospitalMarker(orthopedichospital, 'H - Orthopedic Hospital'),
    };
  }

  // Helper method to build physiotherapy center markers
  Marker _buildPhysioCenterMarker(LatLng position, String title) {
    return Marker(
      markerId: MarkerId(title),
      position: position,
      infoWindow: InfoWindow(title: title),
      onTap: () => _createRoute(position),
    );
  }

  // Helper method to build hospital markers
  Marker _buildHospitalMarker(LatLng position, String title) {
    return Marker(
      markerId: MarkerId(title),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: title),
      onTap: () => _createRoute(position),
    );
  }

  // Fetch route from current location to the selected destination
  Future<void> _createRoute(LatLng destination) async {
    if (currentPosition == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currentPosition!.latitude},${currentPosition!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapsApiKeyy';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0]['overview_polyline']['points'];
        _drawPolyline(route);
      } else {
        print("Failed to load directions. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  // Decode polyline and draw it on the map
  void _drawPolyline(String encodedPolyline) {
    List<LatLng> polylineCoordinates = _decodePolyline(encodedPolyline);

    setState(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          width: 5,
          color: Colors.blue,
          points: polylineCoordinates,
        ),
      );
    });
  }

  // Decode encoded polyline from Google Directions API
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }
}
