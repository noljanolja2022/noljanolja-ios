buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.10")
        classpath("org.jetbrains.kotlin:kotlin-serialization:1.8.10")
        classpath("com.google.devtools.ksp:com.google.devtools.ksp.gradle.plugin:1.8.10-1.0.9")
        classpath("com.rickclephas.kmp:kmp-nativecoroutines-gradle-plugin:1.0.0-ALPHA-5")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
