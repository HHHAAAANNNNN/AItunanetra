# AITUNANETRA - Mobile Application for Low-Vision Students

## Research Overview & Results

AITUNANETRA is a mobile application developed specifically to assist low-vision students in understanding objects and their surrounding environment within educational contexts. The application was created through a user-centered design approach with direct involvement of students from SLB-A YPAB Gebang Putih Surabaya, resulting in a solution tailored to their unique needs and challenges.

### Development Methodology

The application was developed using the **Design Thinking methodology** with three iterative testing cycles involving five low-vision students. This approach enabled continuous refinement based on real user feedback, addressing critical usability issues at each stage:

- **First iteration** identified major pain points including confusing initial guides, unnecessary login pages, hidden exit buttons, and gesture controls incompatible with TalkBack
- **Second iteration** resolved navigation issues, improved button labeling for screen readers, and added easy access to user guides
- **Final iteration** produced a version that students could operate independently with minimal assistance

### Key Features

- **Voice-guided interface** with comprehensive audio instructions in Indonesian
- **Dual-control system** for both gesture-based and button-based interactions
- **Integrated flashlight and microphone controls** optimized for low-vision users
- **TalkBack-compatible design** with proper text labels for all interactive elements
- **Streamlined navigation** without unnecessary authentication steps
- **On-demand tutorial access** from any screen within the application

### Research Results & Evaluation

The final prototype was evaluated using the **QUIM (Quality in Use Integrated Measure)** instrument across 10 usability factors. The application achieved an overall score of **79.2** (categorized as "Good"), with particularly strong performance in:

- **Learnability (92/100)** - Students quickly understood how to use the application after minimal instruction
- **Efficiency (90/100)** - The application effectively helped students complete assigned tasks
- **Accessibility (86/100)** - Excellent compatibility with TalkBack and other screen readers
- **Satisfaction (84/100)** - Positive user experience during educational activities
- **Usefulness (86/100)** - Practical value in classroom learning contexts

Areas identified for improvement include:
- **Security (64/100)** and **Trust (68/100)** - Students expressed concerns about camera/microphone usage permissions and data privacy
- **Effectiveness (74/100)**, **Productivity (72/100)** and **Universality (76/100)** - Further adaptation needed for diverse learning scenarios

### Conclusion & Future Development

AITUNANETRA demonstrates that Design Thinking methodology is highly effective for developing assistive applications for visually impaired users, particularly when incorporating multiple iterations with direct user involvement. The research confirms that applications for this demographic require specialized design considerations beyond standard accessibility guidelines.

**Recommended improvements for future development:**
- Enhanced security explanations to address user concerns about permissions
- Simplified user flows to minimize navigation steps to core features
- Expansion of educational scenarios supported by the application
- Testing with totally blind users to ensure compatibility across the full spectrum of visual impairments
- Integration of participatory design approaches involving teachers and parents as co-designers

This research makes a meaningful contribution to assistive technology for education by demonstrating how context-specific applications can be developed through iterative user testing with the actual beneficiaries of the technology, resulting in solutions that genuinely address their unique challenges in educational settings.

---

## Setup Instructions

Follow these step-by-step instructions to set up and deploy AITUNANETRA on your mobile phone.

### Prerequisites

Before you begin, ensure you have the following installed on your computer:

1. **Flutter SDK** (version 3.8.1 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Verify installation: `flutter doctor`

2. **Android Studio** (for Android deployment) or **Xcode** (for iOS deployment)
   - Android Studio: [developer.android.com](https://developer.android.com/studio)
   - Xcode: Available on Mac App Store (macOS only)

3. **Git** - To clone the repository
   - Download from [git-scm.com](https://git-scm.com/)

4. **A mobile device** (Android or iOS) with USB debugging enabled

### Step 1: Clone the Repository

Open your terminal or command prompt and run:

```bash
git clone https://github.com/HHHAAAANNNNN/AItunanetra.git
cd AItunanetra
```

### Step 2: Install Dependencies

Install all required Flutter packages:

```bash
flutter pub get
```

This will download and install all dependencies listed in `pubspec.yaml`, including:
- Camera functionality
- Permission handler
- Audio players
- Text-to-speech capabilities
- And other required packages

### Step 3: Prepare Your Mobile Device

#### For Android:

1. **Enable Developer Options** on your Android device:
   - Go to **Settings** > **About Phone**
   - Tap **Build Number** 7 times to enable Developer Options
   - Go back to **Settings** > **Developer Options**
   - Enable **USB Debugging**

2. **Connect your device** to your computer via USB cable

3. **Verify connection**:
   ```bash
   flutter devices
   ```
   You should see your device listed

#### For iOS (macOS only):

1. **Connect your iPhone/iPad** to your Mac via USB cable

2. **Trust the computer** when prompted on your iOS device

3. **Configure signing** in Xcode:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select your device as the target
   - Go to **Signing & Capabilities**
   - Select your development team

4. **Verify connection**:
   ```bash
   flutter devices
   ```
   You should see your device listed

### Step 4: Build and Install the Application

#### For Android:

Run the following command to build and install the app on your connected Android device:

```bash
flutter run --release
```

Or to create an installable APK file:

```bash
flutter build apk --release
```

The APK file will be located at: `build/app/outputs/flutter-apk/app-release.apk`

Transfer this APK to your Android device and install it manually.

#### For iOS:

Run the following command to build and install the app on your connected iOS device:

```bash
flutter run --release
```

Or to create an IPA file for distribution:

```bash
flutter build ios --release
```

### Step 5: Grant Required Permissions

When you first launch AITUNANETRA on your mobile device, you will be prompted to grant permissions:

1. **Camera Permission** - Required for object recognition functionality
2. **Microphone Permission** - Required for voice commands and audio input
3. **Storage Permission** (Android only) - May be required for saving application data

**Important**: Tap **Allow** for all permissions to ensure the application functions properly.

### Step 6: Using the Application

Once installed and permissions are granted:

1. **Launch AITUNANETRA** from your device's app drawer
2. The application will start with voice-guided instructions in Indonesian
3. **TalkBack users**: Enable TalkBack for full accessibility support
4. Use either **gesture controls** or **button controls** based on your preference
5. Access the **tutorial** from any screen if you need guidance
6. Use the **flashlight** and **microphone controls** as needed

### Troubleshooting

#### Common Issues:

**Device not detected:**
- Ensure USB debugging is enabled (Android)
- Try a different USB cable
- Run `flutter doctor` to check for issues

**Build errors:**
- Clean the build: `flutter clean`
- Get dependencies again: `flutter pub get`
- Try rebuilding: `flutter run`

**Permission issues:**
- Manually grant permissions in device Settings > Apps > AITUNANETRA > Permissions

**App crashes on startup:**
- Ensure your device meets minimum requirements
- Check that all permissions are granted
- Reinstall the application

#### Getting Help:

For additional support or to report issues, please visit the project repository or contact the development team.

### System Requirements

- **Android**: Android 5.0 (API level 21) or higher
- **iOS**: iOS 12.0 or higher
- **Storage**: Minimum 100MB free space
- **Camera**: Device must have a functional rear camera
- **Audio**: Speaker or headphones for audio feedback
