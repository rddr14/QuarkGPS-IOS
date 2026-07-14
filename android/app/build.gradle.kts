plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
}

android {
    namespace = "com.quarkgps"
    compileSdk = 34

    flavorDimensions += "brand"

    defaultConfig {
        applicationId = "com.quarkgps"
        minSdk = 28
        targetSdk = 36
        versionCode = 12
        versionName = "12.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    productFlavors {
        create("quark") {
            dimension = "brand"
            applicationId = "com.quarkgps"
            resValue("string", "app_name", "QuarkGPS")
            resValue("string", "string_site", "https://rastrear.quarkgps.com")
        }

        create("aura") {
            dimension = "brand"
            applicationId = "com.aurarastreamento"
            resValue("string", "app_name", "Aura Monitoramento")
            resValue("string", "string_site", "https://auramonitoramento.com.br")
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    buildFeatures {
        compose = true
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}


dependencies {

    implementation(libs.androidx.core.ktx.v1120)
    implementation(libs.androidx.appcompat.v170alpha03)
    implementation(libs.material)
    implementation(libs.androidx.constraintlayout)

    // Dependência para WebView
    implementation(libs.androidx.webkit)

    // Dependências para Localização (Google Play Services Location)
    implementation(libs.play.services.location)

    // Dependências do Jetpack Compose
    implementation(platform(libs.androidx.compose.bom.v20240200))
    implementation(libs.ui)
    implementation(libs.ui.graphics)
    implementation(libs.material3)


    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit.v115)
    androidTestImplementation(libs.androidx.espresso.core.v351)

}