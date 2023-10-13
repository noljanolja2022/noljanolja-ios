plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    kotlin("plugin.serialization")
    id("com.google.devtools.ksp")
    id("com.rickclephas.kmp.nativecoroutines")
}

// CocoaPods requires the podspec to have a version.
version = "1.0"

kotlin {
    ios()
    iosSimulatorArm64()

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation("io.rsocket.kotlin:rsocket-ktor-client:0.15.4")
                implementation("io.ktor:ktor-client-core:2.2.3")
                implementation("io.ktor:ktor-client-websockets:2.2.3")
                implementation("io.ktor:ktor-client-auth:2.2.3")
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.4")
            }
        }
        val commonTest by getting {}
        val iosMain by getting {
            dependencies {
                implementation("io.ktor:ktor-client-darwin:2.2.3")
            }
        }
        val iosTest by getting {}

        sourceSets["iosSimulatorArm64Main"].dependsOn(iosMain)
        sourceSets["iosSimulatorArm64Test"].dependsOn(iosTest)
    }

    sourceSets.all {
        languageSettings.apply {
            optIn("kotlin.RequiresOptIn")
            optIn("kotlin.experimental.ExperimentalObjCName")
            optIn("io.rsocket.kotlin.ExperimentalMetadataApi")
        }
    }

    cocoapods {
        summary = "Shared Module"
        homepage = "../shared"
        version = "1.0"
        ios.deploymentTarget = "14.0"
        framework {
            baseName = "shared"
        }

        // Maps custom Xcode configuration to NativeBuildType
        xcodeConfigurationToNativeBuildType["Development"] = org.jetbrains.kotlin.gradle.plugin.mpp.NativeBuildType.DEBUG
        xcodeConfigurationToNativeBuildType["AppStore"] = org.jetbrains.kotlin.gradle.plugin.mpp.NativeBuildType.RELEASE
    }
}
