import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? _controller;
  var homeAddress = const LatLng(-33.86, 151.20);
  double zoomValue = 12.0;
  LatLng target = const LatLng(-33.86, 151.20);

  @override
  void initState() {
    _controller?.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Google Maps App'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: homeAddress,
                zoom: zoomValue,
              ),
              onMapCreated: (controller) => _controller = controller,
              onCameraMove: (position) {
                setState(() {
                  zoomValue = position.zoom;
                  target = position.target;
                });
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          target =
                              LatLng(target.latitude + 0.05, target.longitude);
                          _controller?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: target, zoom: zoomValue),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_drop_up),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              target = LatLng(
                                  target.latitude, target.longitude - 0.05);
                              _controller?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                      target: target, zoom: zoomValue),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_left),
                          ),
                          IconButton(
                            onPressed: () {
                              target = LatLng(
                                  target.latitude, target.longitude + 0.05);
                              _controller?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                      target: target, zoom: zoomValue),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_right),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          target =
                              LatLng(target.latitude - 0.05, target.longitude);
                          _controller?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: target, zoom: zoomValue),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.white.withOpacity(0.5),
                  child: Slider(
                      max: 21,
                      min: 2,
                      value: zoomValue,
                      onChanged: (value) {
                        setState(() {
                          zoomValue = value;
                        });
                        _controller!.animateCamera(CameraUpdate.zoomTo(value));
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
