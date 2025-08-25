import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF26B), // #EEF26B
              Color(0xFFEAF207), // #EAF207
              Color(0xFFEBFF52), // #EBFF52
            ],
            stops: [0.25, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        // Foto Profil Dummy
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white, // Background untuk foto
                          child: ClipOval(
                            child: Image.asset(
                              'assets/ProfileDummy.png', // Path ke foto profil Anda
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 140,
                                  color: Colors.grey,
                                ); // Fallback icon
                              },
                            ),
                          ),
                        ),
                        // Tombol Edit Foto Profil
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Aksi untuk mengubah foto profil (saat ini tidak berfungsi)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tombol ubah foto ditekan')),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D0D0D), // Warna tombol edit diubah ke #0D0D0D
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0D0D),
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // TextField Email
                    TextField(
                      controller: TextEditingController(text: 'loremipsum@email.com'), // Dummy email
                      readOnly: true, // Biarkan read-only untuk saat ini
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF0D0D0D)), // Warna ikon diubah ke #0D0D0D
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        labelStyle: const TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.black54,
                        ),
                        suffixIcon: IconButton( // Ikon edit di sebelah kanan
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tombol edit email ditekan')),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TextField Password
                    TextField(
                      controller: TextEditingController(text: '********'), // Dummy password
                      readOnly: true, // Biarkan read-only untuk saat ini
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF0D0D0D)), // Warna ikon diubah ke #0D0D0D
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        labelStyle: const TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.black54,
                        ),
                        suffixIcon: IconButton( // Ikon edit di sebelah kanan
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tombol edit password ditekan')),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk Cancel (saat ini tidak berfungsi)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tombol Cancel ditekan')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Warna latar belakang putih
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                  color: Color(0xFF0D0D0D),
                                  width: 2.0), // Border hitam tebal 2
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF0D0D0D), // Warna teks hitam
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk Save! (saat ini tidak berfungsi)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tombol Save! ditekan')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D0D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text(
                            'Save!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Tombol Kembali di pojok kiri atas sebagai IconButton sederhana
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0D0D0D), size: 30), // Ikon lebih besar dan warna hitam
                onPressed: () {
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (Dashboard)
                },
                tooltip: 'Kembali',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
