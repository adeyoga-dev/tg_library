import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo (Pastikan path sesuai dengan pubspec.yaml)
              Image.asset('assets/images/logo_tg.png', height: 120),
              const SizedBox(height: 40),

              // 2. Judul Utama
              const Text(
                'Selamat Datang di\nTG Docs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50), // Warna biru gelap
                ),
              ),
              const SizedBox(height: 20),

              // 3. Subtitle
              const Text(
                'Perpustakaan dokumen karyawan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF546E7A),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Deskripsi Kecil
              const Text(
                'Akses pedoman perjanjian, dan informasi penting Anda dengan mudah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 60),

              // 5. Tombol Mulai
              SizedBox(
                width: double.infinity, // Agar tombol selebar layar
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi saat tombol ditekan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BodyScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF6C5CE7,
                    ), // Warna ungu tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final List<Map<String, String>> docs = [
      {
        'title': 'Perjanjian Kerja Bersama',
        'date': '12 Feb, 09:37',
        'author': 'Ricki Kumbara',
      },
      {
        'title': 'Keselamatan dan Kesehatan Kerja',
        'date': '6 Feb, 16:41',
        'author': 'Ricki Kumbara',
      },
      {
        'title': 'Code of Conduct',
        'date': '16 Jan, 12:03',
        'author': 'Ricki Kumbara',
      },
      {
        'title': 'Instruksi Kerja',
        'date': '03 Feb, 10:45',
        'author': 'Ricki Kumbara',
      },
      {
        'title': 'Struktur Organisasi',
        'date': '6 Feb, 16:41',
        'author': 'Ricki Kumbara',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo_tg.png',
          ), // Logo kecil di pojok
        ),
        title: const Text(
          'TG Docs',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          return Container(
            // margin: const EdgeInsets.bottom(12),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(
                0xFF4A5568,
              ), // Warna background gelap sesuai gambar
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Icon Buku (Ganti dengan Image.asset kamu)
                Image.asset(
                  'assets/images/icon_book.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 15),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docs[index]['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            docs[index]['date']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            docs[index]['author']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
