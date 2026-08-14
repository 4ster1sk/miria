# Flutter pluginの実装クラスがR8でstripされるのを防ぐ（公式ルールと同等）
-if class * implements io.flutter.embedding.engine.plugins.FlutterPlugin
-keep,allowshrinking,allowobfuscation class <1>

# プラグインが@JavascriptInterfaceをリフレクションで参照する場合に必要
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
