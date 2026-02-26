import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'welcome_screen.dart';
import 'pdf_viewer_screen.dart';

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://one-portal.tgidn.co.id',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  List<dynamic> documents = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _protectScreen();
    _fetchDocuments();
  }

  @override
  void dispose() {
    _unprotectScreen();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _protectScreen() async {
    await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageWithBlur();
  }

  Future<void> _unprotectScreen() async {
    await ScreenProtector.preventScreenshotOff();
  }

  Future<void> _logout() async {
    await _secureStorage.deleteAll();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _fetchDocuments() async {
    setState(() => isLoading = true);

    final token = await _secureStorage.read(key: 'auth_token');
    final keyword = _searchController.text.trim();

    try {
      final response = await _dio.get(
        '/app-hris/api/v1/document-centers/list',
        queryParameters: {"keyword": keyword.isEmpty ? "" : keyword},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        setState(() {
          documents = response.data;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> _downloadAndOpen(String url, String title) async {
    final token = await _secureStorage.read(key: 'auth_token');

    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/${title.replaceAll(' ', '_')}.pdf";

    try {
      await _dio.download(
        url,
        filePath,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(title: title, filePath: filePath),
        ),
      );
    } catch (e) {
      debugPrint("Download error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/images/logo_tg_120.png', width: 36),
                  const Spacer(),
                  const Text(
                    'Document Center',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: const Color(0xFFF1F3F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _fetchDocuments,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];

                        return GestureDetector(
                          onTap: () =>
                              _downloadAndOpen(doc['file_url'], doc['name']),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3F5566),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/icon_book.png',
                                  width: 40,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        doc['dept'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
