plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.aitunanetra"
    compileSdk = 36  // Updated to SDK 36 for plugin compatibility
    ndkVersion = "27.0.12077973"  // Updated to NDK 27 for plugin compatibility

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.aitunanetra.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36  // Match compileSdk
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // Signing with debug key - works for testing/sharing
            // For production, generate a proper keystore
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
