# Miria Dev Container

Flutter **Linux** 実行（X11）と **Android APK/AAB ビルド**、ホスト側実機/エミュレータとの **ADB 連携** 用の開発コンテナです。Web / コンテナ内エミュレータは対象外です。Android ビルド用に NDK / CMake をイメージに含めています（エミュレータ・system-images は含みません）。

## 必要なホスト環境

- Docker（Docker Desktop または Engine）
- Cursor / VS Code + Dev Containers 拡張
- （Linux GUI）X サーバ、または WSLg
- （Android 実行）ホスト側の Android Platform-Tools（`adb`）

## 起動

1. リポジトリを開く
2. **Dev Containers: Reopen in Container**
3. 初回はイメージビルドに時間がかかります（Flutter + Android SDK）

コンテナ内では `.fvmrc` の Flutter（現状 `3.32.5`）が FVM 経由で使えます。

## よく使うコマンド

```bash
fvm flutter pub get
fvm flutter test
fvm flutter run -d linux
fvm flutter build linux
fvm flutter build apk --debug
fvm flutter build apk --release          # 署名設定が必要
fvm flutter build appbundle --release    # 署名設定が必要
```

`flutter` / `dart` は `fvm global` のシンボリックリンク経由でも PATH に通っています。

## Linux GUI（X11）

### Linux ホスト

1. ホストで X を許可（例: `xhost +local:`）
2. コンテナ再作成前に、必要なら `devcontainer.json` の `mounts` に追加:

```json
"source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind"
```

3. ホストの `DISPLAY`（例: `:0`）がコンテナに渡ることを確認: `echo $DISPLAY`
4. `fvm flutter run -d linux`

### Windows（VcXsrv 等）

1. VcXsrv / X410 などを起動（初回は Disable access control、または正しい cookie）
2. コンテナの環境変数を設定（例: Cursor の Dev Container 環境、またはホストで）:

```text
DISPLAY=host.docker.internal:0.0
```

3. Windows ファイアウォールで X サーバへの接続を許可
4. `fvm flutter run -d linux`

切り分け: `echo $DISPLAY` → `xdpyinfo`（失敗時は X サーバ未到達）

### WSLg（Windows 11 + WSL2）

WSL 側で GUI が動く環境なら、その `DISPLAY` と X11 ソケット共有を Docker から使えるようにします。環境ごとに差が大きいため、手動で `DISPLAY` を合わせてください。

## Android: ホスト ADB 連携

コンテナ内の `adb` は **ホストの adb サーバ**（`host.docker.internal:5037`）に接続します。USB デバイスをコンテナに直接渡す必要はありません。

### 推奨手順（全 OS）

1. ホストに [Platform-Tools](https://developer.android.com/tools/releases/platform-tools) を入れる（Android Studio 付属でも可）
2. ホストで:

```bash
adb kill-server
adb -a -P 5037 nodaemon server
```

（別ターミナルで常駐）

3. 実機の USB デバッグを ON、またはホストでエミュレータを起動
4. コンテナ内:

```bash
adb devices
fvm flutter devices
fvm flutter run
```

### 代替（ワイヤレス / tcpip）

ホストで `adb tcpip 5555` のあと、コンテナから:

```bash
adb connect host.docker.internal:5555
```

### Windows での注意

- USB を Docker に直パススルーしない（ホスト adb 共有を使う）
- ホットリロード用 VM Service がホスト側ポートで開く場合、接続に失敗することがある。必要なら `--host-vmservice-port` やポートフォワードで切り分ける

## リリース署名

キーストアはイメージに含めません。CI と同じく次を用意してください。

- `android/release.keystore`（または mount）
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

## スコープ外

- Web / Chrome
- コンテナ内 Android エミュレータ（KVM）
- iOS ビルド
- Codespaces 上のホスト GUI / ホスト ADB（リモート環境では想定外）

## トラブルシュート

| 症状 | 確認 |
|------|------|
| `flutter doctor` で Android が NG | `echo $ANDROID_HOME`、`sdkmanager --list_installed` |
| `adb devices` が空 | ホストで `adb -a -P 5037 nodaemon server` が動いているか、ファイアウォール |
| Linux GUI が出ない | `DISPLAY`、`xdpyinfo`、X サーバ起動、Docker の host gateway |
| `pub get` で GitHub clone が 401/Username | `pubspec` の git 依存が非公開・削除されていないか。必要ならホストの credentials を mount / `GIT_ASKPASS` を設定 |
