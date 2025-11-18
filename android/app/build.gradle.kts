plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // O plugin do Flutter deve ser aplicado após Android e Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.ucif.ucif"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "br.com.ucif.ucif"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Java 11 + desugaring (necessário para vários plugins)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // Usar a assinatura debug até configurar uma keystore
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Kotlin padrão
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // Desugaring obrigatório
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
