# AItunanetra

**Flutter-Based Mobile App specialized for Low-vision Blind Students in detecting objects using You-Only-Look-Once (YOLO) Method.**

## Overview

AItunanetra is an assistive mobile application designed to empower low-vision and blind students by providing real-time object detection capabilities. Built using Flutter, the app integrates the powerful YOLO (You-Only-Look-Once) machine learning model to help users identify objects in their surroundings, enhancing their independence and safety.

## Key Features

- **Real-Time Object Detection**: Utilizes YOLO for fast and accurate identification of objects through the device’s camera.
- **Accessible Design**: User interface and interactions are tailored for users with low vision or blindness, ensuring ease of use.
- **Multi-Language Support**: Built with Dart (Flutter) for cross-platform compatibility; integrates C++, CMake, Swift, C, and HTML for performance and native features.
- **Voice Feedback**: Optionally provides spoken descriptions of detected objects to aid non-visual interaction.
- **Customizable Detection**: Allows users to select specific objects of interest for focused navigation.

## Technology Stack

- **Flutter (Dart)**: Main framework for cross-platform mobile development.
- **YOLO (C++/C/CMake)**: High-performance object detection engine.
- **Swift**: iOS-specific integrations and optimizations.
- **HTML**: UI components and documentation.
- **Other**: Additional dependencies and configuration files.

## Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/HHHAAAANNNNN/AItunanetra.git
   ```

2. **Install Flutter:**  
   [Flutter installation guide](https://flutter.dev/docs/get-started/install)

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Build and run the app:**
   ```bash
   flutter run
   ```

   > **Note:** For YOLO integration, native builds and platform-specific setup may be required. See [YOLO Integration Setup](#yolo-integration-setup) for details.

## YOLO Integration Setup

The app relies on the YOLO model implemented in C++/C. To enable object detection:

- Ensure you have a compatible C++ toolchain installed.
- On iOS, Swift bindings are provided for native performance.
- For Android, CMake is used to compile native code.
- Model weights and configuration files should be placed in the designated assets folder.

Refer to the `/yolo` directory and platform-specific README files for detailed setup instructions.

## Usage

- Launch the app on your device.
- Point your camera toward objects to detect.
- The app will display and/or speak out the names of detected objects.
- Adjust settings for user preferences, such as detection categories and voice feedback.

## Contributing

We welcome contributions from the community!  
To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit your changes.
4. Submit a pull request.

Please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.

## Acknowledgements

- [YOLO: Real-Time Object Detection](https://pjreddie.com/darknet/yolo/)
- [Flutter](https://flutter.dev/)
- [OpenCV](https://opencv.org/)

---

**Empowering independence for low-vision and blind students through AI-powered object detection.**
