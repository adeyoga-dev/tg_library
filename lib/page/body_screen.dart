import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:intl/intl.dart';
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

  String? userName;
  String? userNpk;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _protectScreen();
    _loadUser();
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

  Future<void> _loadUser() async {
    userName = await _secureStorage.read(key: 'user_name');
    userNpk = await _secureStorage.read(key: 'user_npk');
    setState(() {});
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
        queryParameters: {"keyword": keyword},
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

  String _buildStorageKey(String title) =>
      'doc_build_${title.replaceAll(' ', '_').toLowerCase()}';

  Future<void> _downloadAndOpen(
    String url,
    String title,
    String? serverBuildNumber,
  ) async {
    final token = await _secureStorage.read(key: 'auth_token');
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/${title.replaceAll(' ', '_')}.pdf";
    final file = File(filePath);
    final buildKey = _buildStorageKey(title);
    final savedBuildNumber = await _secureStorage.read(key: buildKey);
    final normalizedServerBuildNumber = serverBuildNumber?.trim();

    final isSameBuild = normalizedServerBuildNumber != null &&
        normalizedServerBuildNumber.isNotEmpty &&
        savedBuildNumber == normalizedServerBuildNumber;

    if (await file.exists() && isSameBuild) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(title: title, filePath: filePath),
        ),
      );
      return;
    }

    if (await file.exists() && !isSameBuild) {
      await file.delete();
    }

    try {
      await _dio.download(
        url,
        filePath,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (normalizedServerBuildNumber != null &&
          normalizedServerBuildNumber.isNotEmpty) {
        await _secureStorage.write(
          key: buildKey,
          value: normalizedServerBuildNumber,
        );
      }

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

  String formatDate(String dateString) {
    final dateUtc = DateTime.parse(dateString);
    final dateLocal = dateUtc.toLocal();
    final formatter = DateFormat("d MMM, HH:mm");
    final formatted = formatter.format(dateLocal);
    return formatted;
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

            /// SOFTLINE + PROFILE
            Stack(
              children: [
                Image.asset(
                  'assets/images/softline.png',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                        children: [
                          Text(
                            "Hallo, ${userName ?? ''}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userNpk ?? '',
                            style: const TextStyle(
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
              child: RefreshIndicator(
                onRefresh: _fetchDocuments,
                child: isLoading && documents.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(
                            height: 400,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      )
                    : documents.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(
                            height: 400,
                            child: Center(
                              child: Text(
                                "Data tidak ditemukan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];

                          return GestureDetector(
                            onTap: () => _downloadAndOpen(
                              doc['file_url'],
                              doc['name'],
                              doc['build_number']?.toString(),
                            ),
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
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              formatDate(doc['created_at']),
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            const Icon(
                                              Icons.person,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                doc['created_by'] ?? '-',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
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
            ),
          ],
        ),
      ),
    );
  }
}
