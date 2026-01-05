<div align="center">

# 🌟 AITUNANETRA

### AI-Powered Assistive Mobile Application for Low-Vision Students

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](https://github.com/HHHAAAANNNNN/AItunanetra)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**An innovative mobile application designed to empower low-vision students through AI-driven object recognition and voice-guided navigation.**

[Features](#-key-features) • [Screenshots](#-application-screenshots) • [Installation](#-installation) • [Usage](#-how-to-use) • [Research](#-research--evaluation)

</div>

---

## 📖 About AITUNANETRA

AITUNANETRA is a mobile application specifically developed to assist low-vision students in understanding objects and navigating their surrounding environment within educational contexts. Built using Flutter and powered by AI, this application was created through a user-centered design approach with direct involvement of students from **SLB-A YPAB Gebang Putih Surabaya**, ensuring the solution is tailored to their unique needs and challenges.

### 🎯 Key Features

- 🎤 **Voice-Guided Interface** - Comprehensive audio instructions in Indonesian language
- 🖐️ **Dual-Control System** - Support for both gesture-based and button-based interactions
- 🔦 **Integrated Controls** - Built-in flashlight and microphone controls optimized for low-vision users
- ♿ **TalkBack Compatible** - Full accessibility support with proper text labels for screen readers
- 🚀 **Streamlined Navigation** - No unnecessary authentication steps, direct access to features
- 📚 **On-Demand Tutorial** - Access user guides from any screen within the application
- 📸 **AI Object Recognition** - Camera-based object detection and description
- 🎨 **High Contrast UI** - Optimized visual design for users with low vision

---

## 📱 Application Screenshots

### Main Interface & Mockup
<div align="center">
<img src="screenshots/1. Main Mockup.png" alt="Main Mockup" width="300"/>

*Complete UI/UX design mockup showcasing the application's visual structure*
</div>

### Interactive Tutorial Screens

<div align="center">
<img src="screenshots/2. Panduan pertama.png" alt="Tutorial Screen 1" width="250"/>
<img src="screenshots/3. Panduan kedua.png" alt="Tutorial Screen 2" width="250"/>
<img src="screenshots/4. Panduan ketiga.png" alt="Tutorial Screen 3" width="250"/>

*Step-by-step tutorial screens guiding users through the application features*
</div>

<div align="center">
<img src="screenshots/5. Panduan keempat.png" alt="Tutorial Screen 4" width="300"/>

*Final tutorial screen with voice-guided instructions*
</div>

### Main Dashboard
<div align="center">
<img src="screenshots/6. Main Dashboard.png" alt="Main Dashboard" width="300"/>

*Main dashboard with intuitive controls for camera, flashlight, and microphone*
</div>

### Settings Interface

<div align="center">
<img src="screenshots/7. Setting Pertama.png" alt="Settings Screen 1" width="250"/>
<img src="screenshots/8. Setting Kedua.png" alt="Settings Screen 2" width="250"/>

*Accessible settings screens for customizing application preferences*
</div>

---

## 🔬 Research & Evaluation

### Development Methodology

The application was developed using the **Design Thinking methodology** with three iterative testing cycles involving five low-vision students. This approach enabled continuous refinement based on real user feedback:

| Iteration | Key Improvements |
|-----------|-----------------|
| **First** | Identified pain points: confusing guides, unnecessary login pages, hidden buttons, gesture conflicts with TalkBack |
| **Second** | Resolved navigation issues, improved screen reader labels, added easy guide access |
| **Final** | Achieved independent operation with minimal assistance required |

### QUIM Evaluation Results

The final prototype was evaluated using the **QUIM (Quality in Use Integrated Measure)** instrument across 10 usability factors, achieving an overall score of **79.2/100** (categorized as "Good"):

| Factor | Score | Category |
|--------|-------|----------|
| **Learnability** | 92/100 | ⭐ Excellent |
| **Efficiency** | 90/100 | ⭐ Excellent |
| **Accessibility** | 86/100 | ⭐ Excellent |
| **Usefulness** | 86/100 | ⭐ Excellent |
| **Satisfaction** | 84/100 | ✅ Very Good |
| **Universality** | 76/100 | ✅ Good |
| **Effectiveness** | 74/100 | ✅ Good |
| **Productivity** | 72/100 | ✅ Good |
| **Trust** | 68/100 | ⚠️ Moderate |
| **Security** | 64/100 | ⚠️ Moderate |

**Key Findings:**
- ✅ Students quickly understood how to use the application after minimal instruction
- ✅ Effective assistance in completing educational tasks
- ✅ Excellent TalkBack and screen reader compatibility
- ✅ Positive user experience during classroom activities
- ⚠️ Further explanation needed for camera/microphone permissions to address privacy concerns

---

## 🛠️ Technology Stack

- **Framework:** Flutter 3.8.1+
- **Language:** Dart 3.8.1+
- **Key Dependencies:**
  - `camera` ^0.10.5 - Camera functionality for object recognition
  - `flutter_tts` ^4.2.0 - Text-to-speech for voice guidance
  - `audioplayers` ^5.2.1 - Audio playback capabilities
  - `permission_handler` ^11.0.1 - Managing device permissions
  - `shared_preferences` ^2.2.2 - Local data storage

---

## 📥 Installation

### Prerequisites

Before you begin, ensure you have the following installed on your computer:

| Tool | Version | Purpose |
|------|---------|---------|
| **Flutter SDK** | 3.8.1+ | Mobile app framework |
| **Dart SDK** | 3.8.1+ | Programming language |
| **Android Studio** | Latest | Android development (or Xcode for iOS) |
| **Git** | Latest | Version control |

**Quick verification:**
```bash
flutter doctor
```

### 🚀 Quick Start

1️⃣ **Clone the Repository**
```bash
git clone https://github.com/HHHAAAANNNNN/AItunanetra.git
cd AItunanetra
```

2️⃣ **Install Dependencies**
```bash
flutter pub get
```

3️⃣ **Connect Your Device**

**For Android:**
- Enable **Developer Options** (Settings → About Phone → Tap Build Number 7 times)
- Enable **USB Debugging** (Settings → Developer Options)
- Connect via USB cable

**For iOS:**
- Connect iPhone/iPad via USB cable
- Trust the computer when prompted
- Configure signing in Xcode (`ios/Runner.xcworkspace`)

4️⃣ **Verify Device Connection**
```bash
flutter devices
```

5️⃣ **Run the Application**
```bash
# Run in debug mode
flutter run

# Or build release version
flutter run --release
```

### 📦 Building for Distribution

**Android APK:**
```bash
flutter build apk --release
```
*Output: `build/app/outputs/flutter-apk/app-release.apk`*

**iOS IPA:**
```bash
flutter build ios --release
```

---

## 📱 How to Use

### First Launch

1. **Grant Permissions** - Allow camera, microphone, and storage access when prompted
2. **Complete Tutorial** - Follow the voice-guided tutorial on first launch
3. **Enable TalkBack** (Optional) - For full accessibility support

### Main Features

#### 📸 Object Recognition
- Point camera at any object
- Tap the camera button or use voice command
- Listen to AI-generated description in Indonesian

#### 🔦 Flashlight Control
- Toggle flashlight for better visibility in dark environments
- Accessible via large, high-contrast button

#### 🎤 Voice Commands
- Activate microphone for voice-based interaction
- Receive audio feedback for all actions

#### ⚙️ Settings
- Customize voice speed and volume
- Adjust interface preferences
- Access user guide anytime

### Accessibility Tips

- **For TalkBack Users:** All buttons have descriptive labels
- **For Low Vision:** High contrast mode enabled by default
- **For Beginners:** Tutorial available from settings at any time

---

## 🔧 System Requirements

| Platform | Minimum Version | Storage | Camera |
|----------|----------------|---------|--------|
| **Android** | Android 5.0 (API 21) | 100MB | Rear camera required |
| **iOS** | iOS 12.0 | 100MB | Rear camera required |

**Recommended:**
- Speaker or headphones for audio feedback
- Good lighting conditions for optimal object recognition

---

## 🤝 Contributing

Contributions are welcome! This project was developed with a focus on accessibility and user-centered design. If you have suggestions for improvements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Areas for Contribution
- 🌐 Additional language support
- 🎨 UI/UX improvements
- 🔍 Enhanced object recognition
- 📖 Documentation improvements
- ♿ Additional accessibility features

---

## 🎓 Research Context

This application was developed as part of a research project focusing on assistive technology for education. The development followed a rigorous **Design Thinking methodology** with direct involvement of low-vision students from **SLB-A YPAB Gebang Putih Surabaya**.

### Research Highlights

✅ **Three iterative testing cycles** with five low-vision students  
✅ **QUIM evaluation score of 79.2/100** (categorized as "Good")  
✅ **92/100 in Learnability** - Demonstrates effective user-centered design  
✅ **90/100 in Efficiency** - Proven to help students complete educational tasks  
✅ **86/100 in Accessibility** - Excellent screen reader compatibility  

### Future Development Directions

- 🔒 Enhanced security explanations to address privacy concerns
- 📊 Simplified user flows for faster access to core features
- 🎓 Expansion of educational scenarios
- 👥 Testing with totally blind users
- 🤝 Integration of participatory design with teachers and parents

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Contact & Support

- **Repository:** [github.com/HHHAAAANNNNN/AItunanetra](https://github.com/HHHAAAANNNNN/AItunanetra)
- **Issues:** [Report a bug or request a feature](https://github.com/HHHAAAANNNNN/AItunanetra/issues)

---

## 🙏 Acknowledgments

Special thanks to:
- Students and staff at **SLB-A YPAB Gebang Putih Surabaya** for their invaluable participation in user testing
- The Flutter community for excellent tools and resources
- All contributors who have helped make this application more accessible

---

<div align="center">

**Made with ❤️ for accessibility and inclusive education**

⭐ Star this repository if you find it helpful!

</div>

