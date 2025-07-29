import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPicker({super.key, required this.onLocationSelected});

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  LatLng? _pickedPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    var permission = await Permission.location.status;
    if (permission.isDenied || permission.isRestricted) {
      permission = await Permission.location.request();
      if (!permission.isGranted) return;
    }

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      child: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 16,
                    ),
                    onMapCreated: (controller) => _controller = controller,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    onTap: (LatLng position) {
                      setState(() {
                        _pickedPosition = position;
                      });
                      widget.onLocationSelected(position);
                    },
                    markers: {
                      if (_pickedPosition != null)
                        Marker(
                          markerId: const MarkerId("picked"),
                          position: _pickedPosition!,
                          infoWindow: const InfoWindow(
                            title: "Ubicación seleccionada",
                          ),
                        ),
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
