import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = '';
  String temperature = '';
  String description = '';
  bool isLoading = false;

  Future<void> fetchWeather() async {
    setState(() => isLoading = true);
    final apiKey = 'fb0cc3072984970ab9e68b9da49c3cc7';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          temperature = data['main']['temp'].toString();
          description = data['weather'][0]['description'];
          isLoading = false;
        });
      } else {
        setState(() {
          temperature = '';
          description = 'City not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        description = 'Error fetching data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Weather App'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter city name'),
              onChanged: (value) {
                city = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 30),
            if (isLoading)
              CircularProgressIndicator()
            else ...[
              if (temperature.isNotEmpty)
                Text('Temperature: $temperature°C',
                    style: TextStyle(fontSize: 24)),
              if (description.isNotEmpty)
                Text('Condition: $description',
                    style: TextStyle(fontSize: 20)),
            ],
          ],
        ),
      ),
    );
  }
}
