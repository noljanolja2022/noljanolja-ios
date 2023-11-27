buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
        classpath("org.jetbrains.kotlin:kotlin-serialization:1.9.0")
        classpath("com.google.devtools.ksp:com.google.devtools.ksp.gradle.plugin:1.9.0-1.0.13")
        classpath("com.rickclephas.kmp:kmp-nativecoroutines-gradle-plugin:1.0.0-ALPHA-21")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
