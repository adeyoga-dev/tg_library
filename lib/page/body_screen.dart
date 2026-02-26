import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

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
    _protectScreen();
  }

  @override
  void dispose() {
    _unprotectScreen();
    super.dispose();
  }

  Future<void> _protectScreen() async {
    await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageWithBlur();
  }

  Future<void> _unprotectScreen() async {
    await ScreenProtector.preventScreenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/images/logo_tg_120.png', width: 36),
                  const Spacer(),
                  const Text(
                    'Document Center',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.menu, color: Color(0xFF2C3E50)),
                ],
              ),
            ),

            /// ================= SOFTLINE + PROFILE =================
            Stack(
              children: [
                // Softline background
                Image.asset(
                  'assets/images/softline.png',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Profile overlay (nutupin softline)
                Positioned(
                  left: 16,
                  top: 25,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFEFF6FB),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hallo, Ricid',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '25202232',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF607D8B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= SEARCH =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: const Color(0xFFF1F3F5),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= LIST =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final item = docs[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F5566),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/icon_book.png', width: 40),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
                                    item['date']!,
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
                                    item['author']!,
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
      ),
    );
  }
}
