---
description: Migrate a Flutter Android app to support 16KB page sizes and modern Gradle declarative plugin syntax
---

# Flutter 16KB Page Size Migration

This workflow migrates a Flutter Android project to support 16KB memory page sizes (required for Android 15+ on Google Play) and updates the Gradle build files to use the modern declarative `plugins {}` block.

## Prerequisites

- Flutter SDK 3.16+ installed
- Gradle Wrapper already updated to 8.13+ (`android/gradle/wrapper/gradle-wrapper.properties`)

---

## Step 1: Migrate `android/settings.gradle` to Declarative Plugins

Replace the entire file contents with:

```groovy
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.9.1" apply false
    id "org.jetbrains.kotlin.android" version "2.1.20" apply false
    // Add these if using Firebase:
    id "com.google.gms.google-services" version "4.4.2" apply false
    id "com.google.firebase.crashlytics" version "3.0.1" apply false
}

include ':app'
```

> **IMPORTANT**: Crashlytics plugin v3 requires Google Services v4.4.1+. If using Firebase Crashlytics, ensure google-services is at least `4.4.2`.

---

## Step 2: Update `android/build.gradle`

Remove the entire `buildscript {}` block (classpath dependencies, ext.kotlin_version, etc.) since plugins are now declared in `settings.gradle`.

Add a `resolutionStrategy` to force kotlin-stdlib versions to match the Kotlin compiler:

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        resolutionStrategy {
            force 'org.jetbrains.kotlin:kotlin-stdlib:2.1.20'
            force 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.1.20'
            force 'org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.20'
        }
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

---

## Step 3: Update `android/app/build.gradle`

Replace the old imperative `apply plugin` lines and the `localProperties` / `flutterRoot` boilerplate at the top with a declarative `plugins {}` block:

```groovy
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    // Add these if using Firebase:
    id "com.google.gms.google-services"
    id "com.google.firebase.crashlytics"
}
```

Also make these changes inside the `android {}` block:
- Set `compileSdkVersion 36` (or higher, as required by dependencies)
- Set `ndkVersion "27.0.12077973"` (NDK r27+ required for 16KB alignment)

Remove from `dependencies {}`:
- `implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"` (no longer needed)

Remove from end of file:
- `apply plugin: 'com.google.firebase.crashlytics'` (now in plugins block)

---

## Step 4: Update `android/gradle.properties`

Increase JVM heap to avoid OOM during builds:

```properties
org.gradle.jvmargs=-Xmx4G
android.useAndroidX=true
android.enableJetifier=true
```

> **NOTE**: Keep `android.enableJetifier=true` if any transitive dependency still uses the old `com.android.support` libraries.

---

## Step 5: Update `pubspec.yaml`

1. **Widen the Dart SDK constraint** to support newer Flutter versions:
   ```yaml
   environment:
     sdk: '>=3.5.0 <4.0.0'
   ```

2. **Update `intl`** to match flutter_localizations pinned version:
   ```yaml
   intl: ^0.20.2
   ```

3. **Update `skeletonizer`** (if used) to v2+ for Flutter 3.38+ Canvas API compatibility:
   ```yaml
   skeletonizer: ^2.1.3
   ```

4. Run `flutter pub get` to resolve dependencies.

---

## Step 6: Build & Verify

```bash
// turbo
flutter clean
```

```bash
flutter build apk --release
```

If you see warnings about incompatible Kotlin metadata from third-party libraries (e.g. `android-maps-utils`), these are **warnings only** and the build should still succeed.

---

## Common Issues & Fixes

| Error | Fix |
|---|---|
| `app_plugin_loader Gradle plugin imperatively` | Migrate `settings.gradle` to declarative `plugins {}` block (Step 1) |
| `Crashlytics plugin 3 requires Google-Services 4.4.1+` | Bump `com.google.gms.google-services` to `4.4.2` in settings.gradle |
| `kotlin-stdlib metadata 2.3.0, expected 2.1.0` | Add `resolutionStrategy` forcing kotlin-stdlib to match compiler version (Step 2) |
| `Java heap space` during JetifyTransform | Increase `org.gradle.jvmargs` to `-Xmx4G` in gradle.properties |
| `Duplicate class android.support.v4...` | Re-enable `android.enableJetifier=true` in gradle.properties |
| `requires Android Gradle plugin X.Y.Z or higher` | Bump AGP version in settings.gradle plugins block |
| `SkeletonizerCanvas missing Canvas.clipRSuperellipse` | Upgrade `skeletonizer` to `^2.1.3` |
| `intl version solving failed` | Update `intl` to `^0.20.2` |
| `SDK version >=X <Y, version solving failed` | Widen sdk constraint in pubspec.yaml |
