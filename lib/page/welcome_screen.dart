import 'package:flutter/material.dart';
import 'body_screen.dart'; // pastikan BodyScreen ada di project

// Jika nanti mau pakai API, uncomment import ini dan tambahkan package di pubspec.yaml
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  bool _isLoading = false;

  // Dummy credentials (saat ini dipakai)
  // Ubah sesuai kebutuhan dev / staging
  final Map<String, String> _dummyCred = {
    'username': '1234',
    'password': '1234',
  };

  // Jika pakai secure storage nanti:
  // final _secureStorage = const FlutterSecureStorage();

  @override
  void dispose() {
    _usernameCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final inputUsername = _usernameCtl.text.trim();
    final inputPassword = _passwordCtl.text;

    // ---------- DUMMY AUTH (aktif) ----------
    await Future.delayed(const Duration(milliseconds: 700)); // simulate delay

    if (inputUsername == _dummyCred['username'] &&
        inputPassword == _dummyCred['password']) {
      setState(() => _isLoading = false);
      // Login sukses: lanjut ke BodyScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BodyScreen()),
      );
      return;
    }

    // Jika gagal
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username atau password salah (dummy).')),
    );

    // ---------- END DUMMY ----------
    //
    // ---------- CONTOH KODE API LOGIN (KOMENTAR) ----------
    //
    // Jika kamu ingin mengganti ke API Laravel Sanctum yang mengembalikan token:
    //
    // 1) Tambahkan dependency di pubspec.yaml:
    //    dio: ^5.0.0
    //    flutter_secure_storage: ^8.0.0
    //
    // 2) Uncomment import di atas dan method berikut lalu sesuaikan BASE_URL & endpoint.
    //
    // try {
    //   final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    //   final resp = await dio.post('/api/login', data: {
    //     'username': inputUsername,
    //     'password': inputPassword,
    //   });
    //
    //   // Asumsikan backend mengembalikan: { "token": "xxxx" }
    //   if (resp.statusCode == 200 && resp.data['token'] != null) {
    //     final token = resp.data['token'] as String;
    //
    //     // Simpan token dengan secure storage
    //     await _secureStorage.write(key: 'auth_token', value: token);
    //
    //     // Set header default untuk request berikutnya
    //     dio.options.headers['Authorization'] = 'Bearer $token';
    //
    //     // navigasi ke BodyScreen
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const BodyScreen()),
    //     );
    //     return;
    //   } else {
    //     throw Exception('Login gagal: ${resp.data}');
    //   }
    // } catch (err) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Login API error: $err')),
    //   );
    // } finally {
    //   setState(() => _isLoading = false);
    // }
    //
    // Catatan Laravel (backend):
    // - Buat endpoint POST /api/login yang memverifikasi credential.
    // - Jika valid, buat token: $token = $user->createToken('mobile')->plainTextToken;
    // - Kembalikan JSON { "token": $token, "user": $user }
    //
    // Setelah menerima token: tambahkan header Authorization: "Bearer <token>"
    // untuk request berikutnya (contoh: GET /api/documents).
    //
    // ------------------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topImageHeight = media.size.height * 0.42;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1) Gambar gedung yang di-clip melengkung
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: topImageHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/building_tg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // 2) Softline overlay (letakkan sedikit di bawah curve)
            Positioned(
              top: topImageHeight - 70,
              left: -20,
              right: -20,
              child: Opacity(
                opacity: 0.95,
                child: Image.asset(
                  'assets/images/softline.png',
                  fit: BoxFit.cover,
                  height: 160,
                ),
              ),
            ),

            // 3) Card / form yang berada di bagian bawah (mengambang)
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30,
                ),
                child: Container(
                  width: double.infinity,
                  // tinggi minimal agar mirip layout mobile
                  constraints: BoxConstraints(
                    minHeight: media.size.height * 0.45,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Masuk untuk mengakses dokumen Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF607D8B),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // FORM
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _usernameCtl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Masukkan username',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Username wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 14),

                            // Password
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordCtl,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: '••••••••',
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Password wajib diisi'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _doLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D9CDB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clipper untuk membuat potongan melengkung seperti screenshot.
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
