import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:screen_protector/screen_protector.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String filePath;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int totalPages = 0;
  int currentPage = 0;
  bool isReady = false;

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
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2C3E50),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF2C3E50)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            /// ================= PDF VIEW =================
            Expanded(
              child: Stack(
                children: [
                  PDFView(
                    filePath: widget.filePath,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageSnap: true,
                    onRender: (pages) {
                      setState(() {
                        totalPages = pages ?? 0;
                        isReady = true;
                      });
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        currentPage = page ?? 0;
                      });
                    },
                  ),
                  if (!isReady)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),

            /// ================= PAGE INDICATOR =================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "${currentPage + 1} of $totalPages",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            /// ================= WARNING FOOTER =================
            Container(
              width: double.infinity,
              color: const Color(0xFF3F5566),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.warning_rounded, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Dilarang melakukan screenshot atau memfoto dokumen ini",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
