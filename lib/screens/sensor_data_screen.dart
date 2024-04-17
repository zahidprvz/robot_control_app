import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_control_app/theme_model/theme_model.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;
import '../components/sensor_value_card.dart';

class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  List<double> _accelerometerValues = [0, 0, 0];
  final TextEditingController _ipAddressController = TextEditingController();
  String _ipAddress = '';
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    // Default IP address
    _ipAddressController.text = '192.168.0.100';
    _ipAddress = _ipAddressController.text;

    // Listen to accelerometer data
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
      });
      // Send accelerometer data to ESP8266
      sendDataToESP8266(event.x, event.y, event.z);
    });
  }

  // Function to send accelerometer data to ESP8266
  void sendDataToESP8266(double x, double y, double z) async {
    var url = 'http://$_ipAddress/data'; // Endpoint on ESP8266 to receive data
    var response = await http.post(Uri.parse(url), body: {
      'x': x.toString(),
      'y': y.toString(),
      'z': z.toString(),
    });
    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0, // Remove the elevation
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      SensorValueCard(
                          title: 'X', value: _accelerometerValues[0]),
                      const SizedBox(width: 8),
                      SensorValueCard(
                          title: 'Y', value: _accelerometerValues[1]),
                      const SizedBox(width: 8),
                      SensorValueCard(
                          title: 'Z', value: _accelerometerValues[2]),
                      const SizedBox(width: 8),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info, color: Colors.white),
                        onPressed: () => Navigator.pushNamed(context, '/about'),
                      ),
                      Switch(
                        value: _darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _darkModeEnabled = value;
                            _updateTheme();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the ESP8266 IP Address:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ipAddressController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Enter IP Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _ipAddress = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipAddressController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    if (_darkModeEnabled) {
      themeModel.setThemeData(ThemeData.dark());
    } else {
      themeModel.setThemeData(ThemeData.light());
    }
  }
}
