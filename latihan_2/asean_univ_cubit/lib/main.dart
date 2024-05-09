import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Mengimpor Flutter Bloc untuk penggunaan Cubit dan BlocBuilder.
import 'package:http/http.dart' as http; // Mengimpor package http untuk melakukan HTTP request.

class UniversityCubit extends Cubit<List<dynamic>> { // Membuat class UniversityCubit yang merupakan turunan dari Cubit dengan tipe data List<dynamic>.
  UniversityCubit() : super([]); // Constructor untuk UniversityCubit yang menginisialisasi state awal dengan list kosong.

  Future<void> fetchUniversities(String? country) async { // Method untuk mengambil data universitas dari API berdasarkan negara.
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$country')); // Melakukan HTTP GET request ke API universities.hipolabs.com dengan parameter negara.
    if (response.statusCode == 200) { // Jika response status code adalah 200 (OK),
      final universities = jsonDecode(response.body); // Mendekode response body dari JSON menjadi List<dynamic>.
      emit(universities); // Memperbarui state UniversityCubit dengan data universitas yang telah diambil.
    } else { // Jika response status code bukan 200,
      throw Exception('Failed to load universities'); // Melemparkan Exception bahwa gagal mengambil data universitas.
    }
  }
}

void main() { // Method utama yang akan dijalankan pertama kali saat aplikasi dijalankan.
  runApp( // Menjalankan aplikasi Flutter.
    BlocProvider( // Memberikan BlocProvider ke aplikasi untuk menyediakan UniversityCubit ke dalam widget tree.
      create: (context) => UniversityCubit(), // Membuat instance dari UniversityCubit.
      child: MaterialApp( // Widget utama aplikasi dengan MaterialApp.
        title: 'ASEAN Universities', // Judul aplikasi.
        theme: ThemeData( // Tema aplikasi.
          primarySwatch: Colors.blue, // Warna primer tema adalah biru.
        ),
        home: UniversityListScreen(), // Halaman utama aplikasi adalah UniversityListScreen.
      ),
    ),
  );
}

class UniversityListScreen extends StatelessWidget { // Widget untuk menampilkan daftar universitas.
String selectedCountry = 'Indonesia'; // Tambahkan variabel selectedCountry
  @override
  Widget build(BuildContext context) { // Method untuk membangun UI widget.
    final universityCubit = BlocProvider.of<UniversityCubit>(context); // Mengakses UniversityCubit dari BlocProvider.

    return Scaffold( // Widget Scaffold sebagai kerangka utama halaman.
      appBar: AppBar( // Widget AppBar sebagai header halaman.
        title: Text('ASEAN Universities'), // Judul AppBar.
      ),
      body: Column( // Widget Column untuk menyusun widget secara vertikal.
        children: [
          DropdownButton<String>( // Widget DropdownButton untuk menampilkan dropdown pilihan negara.
            value: selectedCountry,
            onChanged: (value) {
              selectedCountry = value!; // Update nilai selectedCountry
              universityCubit.fetchUniversities(value);
            },
            items: [ // Daftar item dropdown berdasarkan negara-negara ASEAN.
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
            ].map<DropdownMenuItem<String>>((String value) { // Mengubah daftar negara menjadi widget DropdownMenuItem.
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value), // Menampilkan teks negara sebagai child DropdownMenuItem.
              );
            }).toList(),
          ),
          Expanded( // Widget Expanded untuk mengisi ruang kosong agar widget di dalamnya dapat memperluas sesuai kebutuhan.
            child: BlocBuilder<UniversityCubit, List<dynamic>>( // Widget BlocBuilder untuk membangun UI berdasarkan state UniversityCubit.
              builder: (context, universities) { // Callback builder dengan parameter context dan universities.
                return ListView.builder( // Widget ListView.builder untuk menampilkan daftar universitas.
                  itemCount: universities.length, // Jumlah item dalam daftar universitas.
                  itemBuilder: (context, index) { // Callback untuk membangun setiap item dalam daftar.
                    return ListTile( // Widget ListTile untuk menampilkan informasi universitas dalam satu baris.
                      title: Text(universities[index]['name']), // Menampilkan nama universitas.
                      subtitle: Text(universities[index]['web_pages'][0]), // Menampilkan URL situs web universitas.
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}