import 'dart:convert'; // Paket ini digunakan untuk melakukan encoding dan decoding objek JSON.
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk mengakses ChangeNotifier
import 'package:http/http.dart' as http; // Paket ini menyediakan kelas-kelas untuk melakukan HTTP requests dan memproses responsnya.
import 'package:provider/provider.dart'; // Untuk menggunakan Provider

// Kelas untuk menyediakan data universitas
class UniversityProvider extends ChangeNotifier {
  List<dynamic> universities = [];

  // Fungsi untuk mengambil data universitas dari API berdasarkan negara
  Future<void> fetchUniversities(String country) async {
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$country'));
    if (response.statusCode == 200) {
      universities = jsonDecode(response.body);
      notifyListeners(); // Memberitahu listener (widget) bahwa data telah berubah
    } else {
      throw Exception('Failed to load universities');
    }
  }
}

// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UniversityProvider(), // Membuat instance dari UniversityProvider
      child: MaterialApp(
        title: 'ASEAN Universities',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UniversityListScreen(),
      ),
    ),
  );
}

// Kelas MyApp sebagai root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASEAN Universities',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UniversityListScreen(),
    );
  }
}

// Kelas untuk menampilkan daftar universitas
class UniversityListScreen extends StatefulWidget {
  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

// State dari UniversityListScreen
class _UniversityListScreenState extends State<UniversityListScreen> {
  String selectedCountry = 'Indonesia'; // Negara default yang dipilih

  @override
  Widget build(BuildContext context) {
    final universityProvider = Provider.of<UniversityProvider>(context); // Mendapatkan instance dari UniversityProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('ASEAN Universities'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedCountry,
            onChanged: (value) {
              setState(() {
                selectedCountry = value!; // Mengubah negara yang dipilih
              });
              universityProvider.fetchUniversities(value!); // Mengambil data universitas berdasarkan negara yang dipilih
            },
            items: [
              'Indonesia',
              'Malaysia',
              'Singapore',
              'Thailand',
              'Vietnam',
              'Philippines',
              'Brunei',
              'Myanmar',
              'Cambodia',
              'Laos',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: universityProvider.universities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(universityProvider.universities[index]['name']),
                  subtitle: Text(universityProvider.universities[index]['web_pages'][0]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

