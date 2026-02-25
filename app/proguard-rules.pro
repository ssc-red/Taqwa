# Add project specific ProGuard rules here.
# You can find more information about how to configure ProGuard/R8 at https://developer.android.com/studio/build/shrink-code

# ============ Application Classes ============
-keep class com.example.taqwa.** { *; }
-keep public class com.example.taqwa.MainActivity
-keep public class com.example.taqwa.TaqwaWidget
-keep public class com.example.taqwa.PrayerTime { *; }

# ============ BroadcastReceiver ============
-keep public class * extends android.content.BroadcastReceiver

# ============ Glance Widget ============
-keep public class * extends androidx.glance.appwidget.GlanceAppWidget
-keep public class * extends androidx.glance.appwidget.GlanceAppWidgetReceiver
-keepclassmembers class * extends androidx.glance.appwidget.GlanceAppWidget {
    *** provideGlance(...);
}

# ============ WorkManager ============
-keep public class * extends androidx.work.ListenableWorker
-keepclassmembers class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

# ============ Jetpack Compose ============
-keep class androidx.compose.** { *; }
-keepclassmembers class androidx.compose.** { *; }
-dontwarn androidx.compose.**

# ============ Kotlin Metadata ============
-keep class kotlin.Metadata { *; }
-keepclassmembers class ** {
    @kotlin.jvm.JvmStatic public static *** Companion;
}
-dontwarn kotlin.reflect.jvm.internal.**

# ============ JSON Parsing (org.json) ============
-keep class org.json.** { *; }
-keepclassmembers class org.json.** { *; }

# ============ Google Play Services ============
-keep class com.google.android.gms.** { *; }
-keepclassmembers class com.google.android.gms.** { *; }

# ============ Data Classes & Constructors ============
-keepclassmembers class * {
    public <init>(...);
}

# ============ Android Resources ============
-keep class **.R$* {
    public static <fields>;
}

# ============ Keep Enum Classes ============
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ============ Keep Native Methods ============
-keepclasseswithmembernames class * {
    native <methods>;
}

# ============ Keep Method Names for Reflection ============
-keepclassmembers class * {
    *** get*();
    *** set*(...);
}

# ============ Ignore Warnings ============
-dontwarn androidx.**
-dontwarn com.google.android.gms.**
-dontwarn kotlin.**
-dontwarn org.json.**

# ============ Optimization Settings ============
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose

# ============ Keep Line Numbers for Crash Reports ============
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
