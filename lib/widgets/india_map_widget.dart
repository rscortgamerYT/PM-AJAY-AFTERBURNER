import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Data Models
class MapMarker {
  final String id;
  final LatLng position;
  final Color color;
  final IconData icon;
  final int? count;
  final String title;
  
  const MapMarker({
    required this.id,
    required this.position,
    required this.color,
    required this.icon,
    this.count,
    required this.title,
  });
}

class GeofencePolygon {
  final List<LatLng> points;
  final Color color;
  final String label;
  
  const GeofencePolygon({
    required this.points,
    required this.color,
    required this.label,
  });
}

// Main Widget
class IndiaMapWidget extends StatefulWidget {
  final List<MapMarker> markers;
  final Function(String)? onMarkerTap;
  final List<GeofencePolygon>? geofences;
  
  const IndiaMapWidget({
    Key? key,
    required this.markers,
    this.onMarkerTap,
    this.geofences,
  }) : super(key: key);

  @override
  State<IndiaMapWidget> createState() => _IndiaMapWidgetState();
}

class _IndiaMapWidgetState extends State<IndiaMapWidget> {
  final MapController _mapController = MapController();
  
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(20.5937, 78.9629), // Center of India
        initialZoom: 5.0,
        minZoom: 4.0,
        maxZoom: 18.0,
      ),
      children: [
        // Base Map Layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'gov.pmajay.pmajay_app',
        ),
        
        // Geofence Polygons Layer
        if (widget.geofences != null && widget.geofences!.isNotEmpty)
          PolygonLayer(
            polygons: widget.geofences!.map((geofence) {
              return Polygon(
                points: geofence.points,
                color: geofence.color.withOpacity(0.2),
                borderColor: geofence.color,
                borderStrokeWidth: 2.0,
                isFilled: true,
                label: geofence.label,
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        
        // Markers Layer
        MarkerLayer(
          markers: widget.markers.map((markerData) {
            return Marker(
              point: markerData.position,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => widget.onMarkerTap?.call(markerData.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: markerData.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: markerData.count != null
                        ? Text(
                            '${markerData.count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        : Icon(
                            markerData.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
