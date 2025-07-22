plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.app_mascotas"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.app_mascotas"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Dependencia para Kotlin Standard Library
    implementation(kotlin("stdlib-jdk8"))

    // Para AppCompatActivity y otras funcionalidades básicas de AndroidX
    implementation("androidx.appcompat:appcompat:1.6.1") // O la versión más reciente
    implementation("androidx.core:core-ktx:1.13.1") // O la versión más reciente

    // Si estás usando la librería de utilidades de Google Maps para heatmaps (que es lo que te permite hacer heatmaps en Android nativo)
    implementation("com.google.maps.android:android-maps-utils:3.0.0") // O la versión más reciente

    // Si tu HeatmapActivity usa Google Maps directamente (aparte del plugin de Flutter)
    implementation("com.google.android.gms:play-services-maps:18.2.0") // O la versión más reciente
}
