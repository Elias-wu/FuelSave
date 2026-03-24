import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelSave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = 'Press the button to find cheapest station';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FuelSave'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_result),
            ElevatedButton(
              onPressed: _findCheapest,
              child: const Text('Find Cheapest Station'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAccessToken() async {
    const String clientId = 'YOUR_CLIENT_ID'; // Replace with your client ID
    const String clientSecret = 'YOUR_CLIENT_SECRET'; // Replace with your client secret
    const String tokenUrl = 'https://api.fuel-finder.service.gov.uk/oauth/token'; // Adjust if different

    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  Future<void> _findCheapest() async {
    // Request location permission
    var status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() {
        _result = 'Location permission denied';
      });
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    try {
      // Get access token
      final token = await getAccessToken();

      // Get fuel prices data
      final response = await http.get(
        Uri.parse('https://api.fuel-finder.service.gov.uk/prices?lat=${position.latitude}&lng=${position.longitude}&radius=5000'), // Adjust endpoint and params as per API docs
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        setState(() {
          _result = 'Failed to fetch data: ${response.statusCode}';
        });
        return;
      }

      // Parse JSON
      final data = json.decode(response.body) as List; // Assume list of stations

      double minPrice = double.infinity;
      String cheapestStation = '';

      for (var station in data) {
        try {
          double lat = station['latitude'];
          double lng = station['longitude'];
          double price = station['price']; // Assume single price or find min fuel type
          String name = station['name'];

          double distance = Geolocator.distanceBetween(position.latitude, position.longitude, lat, lng);

          if (distance < 5000 && price < minPrice) {
            minPrice = price;
            cheapestStation = '$name at $lat, $lng, price £$price';
          }
        } catch (e) {
          // Skip invalid entries
        }
      }

      setState(() {
        _result = cheapestStation.isEmpty ? 'No station found within 5km' : cheapestStation;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }
}