import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart'; // 1. Import this

// 2. Change to StatefulWidget
class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final List<Map<String, String>> docs = [
    {
      'title': 'Perjanjian Kerja Bersama',
      'date': '12 Feb, 09:37',
      'author': 'Ricid Kumbara',
    },
    {
      'title': 'Keselamatan dan Kesehatan Kerja',
      'date': '6 Feb, 16:41',
      'author': 'Ricid Kumbara',
    },
    {
      'title': 'Code of Conduct',
      'date': '16 Jan, 12:03',
      'author': 'Ricid Kumbara',
    },
    {
      'title': 'Instruksi Kerja',
      'date': '03 Feb, 10:45',
      'author': 'Ricid Kumbara',
    },
    {
      'title': 'Struktur Organisasi',
      'date': '6 Feb, 16:41',
      'author': 'Ricid Kumbara',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 3. Turn ON protection when screen loads
    _protectScreen();
  }

  @override
  void dispose() {
    // 4. Turn OFF protection when screen closes
    _unprotectScreen();
    super.dispose();
  }

  Future<void> _protectScreen() async {
    // Prevents screenshot (renders screen black on iOS)
    await ScreenProtector.preventScreenshotOn();
    // Blurs the app in the App Switcher (multitasking view)
    await ScreenProtector.protectDataLeakageWithBlur();
  }

  Future<void> _unprotectScreen() async {
    // Re-enable screenshots for the rest of the app
    await ScreenProtector.preventScreenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Row(
          children: [
            // Note: Ensure this asset path exists in your project
            Image.asset('assets/images/logo_tg_120.png', height: 28, width: 28),
            const SizedBox(width: 8),
            const Text(
              'TG Docs',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF2C3E50)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari dokumen...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF1F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A5568),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Note: Ensure this asset path exists
                      Image.asset(
                        'assets/images/icon_book.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 15),
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
          ),
        ],
      ),
    );
  }
}
