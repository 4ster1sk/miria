# Flutter ProGuard Rules
# https://developer.android.com/studio/build/shrink-code

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep annotation and reflection classes used by Flutter plugins
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep classes that might be accessed via reflection by Flutter plugins
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Google Play Services (if any plugins use it)
-keep public class com.google.android.gms.** { public *; }
-keep public class com.google.common.** { public *; }

# Suppress warnings for libraries we can't control
-dontwarn android.**
-dontwarn com.google.android.gms.**
