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

buildscript {
    // Extra properties using Kotlin DSL syntax
    extra.apply {
        // Get highest installed NDK version using Kotlin style
        val androidSdkPath = System.getenv("ANDROID_HOME") ?: System.getenv("ANDROID_SDK_ROOT") ?: ""
        val ndkDir = File("$androidSdkPath/ndk")
        set(
            "ndkVersion",
            if (ndkDir.exists() && ndkDir.isDirectory) {
                ndkDir.listFiles()
                    ?.filter { dir -> dir.name.matches(Regex("\\d+\\.\\d+\\.\\d+.*")) }
                    ?.maxByOrNull { dir -> dir.name }
                    ?.name ?: "27.0.12077973" 
            } else {
                "27.0.12077973" // fallback version
            }
        )
    }
    // ... rest of the buildscript
}
