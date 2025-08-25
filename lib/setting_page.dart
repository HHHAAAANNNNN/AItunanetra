import 'package:flutter/material.dart';
import 'dart:math'; // Untuk fungsi random

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _toggleSetting1 = true;
  bool _toggleSetting2 = false;
  double _fontSizeOption = 1.0; // 1.0 = Normal, 0.8 = Kecil, 1.2 = Besar
  double _brightnessValue = 50.0; // 0-100
  double _textToVoiceSpeed = 1.0; // 0.8 = Lambat, 1.0 = Normal, 1.2 = Cepat

  // Controllers untuk TextField
  final TextEditingController _toggleTextController1 = TextEditingController(text: 'Lorem ipsum dolor sit amet.');
  final TextEditingController _toggleTextController2 = TextEditingController(text: 'Lorem ipsum dolor sit amet.');

  // Warna default
  Color _bgColor1 = const Color(0xFFEEF26B);
  Color _bgColor2 = const Color(0xFFEAF207);
  Color _bgColor3 = const Color(0xFFEBFF52);
  Color _textColor = const Color(0xFF0D0D0D);

  @override
  void dispose() {
    _toggleTextController1.dispose();
    _toggleTextController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgColor1, _bgColor2, _bgColor3],
            stops: const [0.25, 0.75, 1.0],
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
                    Icon(
                      Icons.settings,
                      size: 100,
                      color: _textColor, // Ikon setting menggunakan warna teks dinamis
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'App Setting',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _textColor, // Warna teks dinamis
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Toggle Settings
                    _buildToggleSetting(
                      _toggleTextController1,
                      _toggleSetting1,
                          (bool? value) {
                        setState(() {
                          _toggleSetting1 = value!;
                        });
                      },
                      _textColor, // Meneruskan warna teks
                    ),
                    const SizedBox(height: 10),
                    _buildToggleSetting(
                      _toggleTextController2,
                      _toggleSetting2,
                          (bool? value) {
                        setState(() {
                          _toggleSetting2 = value!;
                        });
                      },
                      _textColor, // Meneruskan warna teks
                    ),
                    const SizedBox(height: 10),

                    // Font Size Setting
                    Row(
                      children: [
                        Image.asset('assets/text_fields.png', width: 24, height: 24, color: _textColor), // Ikon untuk ukuran font
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: _fontSizeOption,
                            min: 0.8,
                            max: 1.2,
                            divisions: 2, // 3 opsi: 0.8, 1.0, 1.2
                            label: _fontSizeOption == 0.8
                                ? 'Kecil'
                                : (_fontSizeOption == 1.0 ? 'Normal' : 'Besar'),
                            onChanged: (double value) {
                              setState(() {
                                _fontSizeOption = value;
                              });
                            },
                            activeColor: _textColor,
                            inactiveColor: _textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Brightness Setting
                    Row(
                      children: [
                        Image.asset('assets/sun.png', width: 24, height: 24, color: _textColor), // Ikon untuk kecerahan
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: _brightnessValue,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: _brightnessValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _brightnessValue = value;
                              });
                            },
                            activeColor: _textColor,
                            inactiveColor: _textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Text-to-Voice Speed Setting
                    Row(
                      children: [
                        Icon(Icons.volume_up, size: 24, color: _textColor), // Ikon suara (dipindahkan ke kiri)
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: _textToVoiceSpeed,
                            min: 0.8,
                            max: 1.2,
                            divisions: 2, // 3 opsi: 0.8, 1.0, 1.2
                            label: _textToVoiceSpeed == 0.8
                                ? 'Lambat'
                                : (_textToVoiceSpeed == 1.0 ? 'Normal' : 'Cepat'),
                            onChanged: (double value) {
                              setState(() {
                                _textToVoiceSpeed = value;
                              });
                            },
                            activeColor: _textColor,
                            inactiveColor: _textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Ubah ke center untuk menempatkan fitur di tengah
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column( // Kolom untuk ikon Randomize dan Reset
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shuffle, color: Color(0xFF0D0D0D), size: 30), // Ikon Randomize
                              onPressed: () {
                                setState(() {
                                  _randomizeColors();
                                });
                              },
                              tooltip: 'Randomize Colors',
                            ),
                            const SizedBox(height: 5),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Color(0xFF0D0D0D), size: 30), // Ikon Reset
                              onPressed: () {
                                setState(() {
                                  _resetColors();
                                });
                              },
                              tooltip: 'Reset Colors',
                            ),
                          ],
                        ),
                        const SizedBox(width: 15), // Jarak antara ikon dan preview box

                        // Preview Warna Utama (sekarang sebagai satu box)
                        Container(
                          width: 80, // Lebar yang lebih besar untuk preview
                          height: 80, // Tinggi yang lebih besar
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_bgColor1, _bgColor2], // Menggunakan 2 warna untuk gradien preview
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _textColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'Aa', // Contoh teks di tengah
                              style: TextStyle(fontSize: 24, color: _textColor, fontFamily: 'Helvetica'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15), // Jarak antara preview box dan kode warna

                        // Kolom untuk Kode Warna
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '#${_textColor.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: TextStyle(color: _textColor, fontFamily: 'Helvetica', fontSize: 20),
                            ),
                            Text(
                              '#${_bgColor1.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: TextStyle(color: _textColor, fontFamily: 'Helvetica', fontSize: 20),
                            ),
                            Text(
                              '#${_bgColor2.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: TextStyle(color: _textColor, fontFamily: 'Helvetica', fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cancel and Save Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk Cancel (saat ini tidak berfungsi)
                            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFF0D0D0D), width: 2.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF0D0D0D),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk Save! (saat ini tidak berfungsi)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pengaturan disimpan!')),
                            );
                            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D0D0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: Text(
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
            // Tombol Kembali di pojok kiri atas
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: _textColor, size: 30),
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

  // Helper method untuk membuat pengaturan toggle dengan TextField
  Widget _buildToggleSetting(TextEditingController controller, bool value, ValueChanged<bool?> onChanged, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true, // TextField hanya untuk tampilan dummy
            style: TextStyle( // Gaya teks di dalam TextField
              fontSize: 16,
              color: textColor,
              fontFamily: 'Helvetica',
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 2.0, color: textColor), // Warna border focused
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 2.0, color: textColor), // Warna border enabled
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              // labelStyle tidak diperlukan karena tidak ada labelText
            ),
          ),
        ),
        const SizedBox(width: 10), // Jarak antara TextField dan Checkbox
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: textColor,
          checkColor: _bgColor3, // Warna ceklis
        ),
      ],
    );
  }

  Widget _buildColorPreviewBox(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _textColor, width: 1),
      ),
    );
  }

  // Fungsi untuk merandom warna
  void _randomizeColors() {
    Random random = Random();
    setState(() {
      _bgColor1 = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
      _bgColor2 = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
      _bgColor3 = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
      _textColor = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
    });
  }

  // Fungsi untuk mereset warna ke default
  void _resetColors() {
    setState(() {
      _bgColor1 = const Color(0xFFEEF26B);
      _bgColor2 = const Color(0xFFEAF207);
      _bgColor3 = const Color(0xFFEBFF52);
      _textColor = const Color(0xFF0D0D0D);
    });
  }
}
