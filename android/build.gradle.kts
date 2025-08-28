plugins {
    id("com.android.application") apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false

    // Google Services (Firebase)
    id("com.google.gms.google-services") version "4.4.2" apply false

    // Firebase Crashlytics (tùy chọn)
    id("com.google.firebase.crashlytics") version "3.0.2" apply false

    // Firebase Performance (tùy chọn)
    id("com.google.firebase.firebase-perf") version "1.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
