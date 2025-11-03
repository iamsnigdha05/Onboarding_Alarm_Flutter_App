import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class LocationService {
  Future<String?> getCurrentAddress() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Location services disabled');


    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) throw Exception('Permission denied');


    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) return 'Lat:${pos.latitude}, Lon:${pos.longitude}';
    final pm = placemarks.first;
    return '${pm.locality ?? ''}, ${pm.country ?? ''}';
  }
}