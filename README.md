# pre requesite

⚠️ some code might tobe adapted if you are using bash instead of zsh ⚠️
However I tried to make it as generic as possible (especially when there are prompts)

install java

```bash
sudo apt install default-jre
```

```bash
brew install openjdk
```

# using the script

## cloning the repository

```bash
git clone https://github.com/allemand-instable/revanced-scripts
```

## downloading the latest version of revanced / apk

```bash
zsh update_revanced.zsh
```

when prompted, copy and paste the name of the apk file you want to use for the patch :

```
———————————————————————
processor architecture : arm64-v8a
type 'download' for downloading the apk from apkmirror / 'cancel' to continue without downloading
➤ your choice : cancel
——————— 📂 APK 📂 ———————
apk/youtube_music
├── com.google.android.apps.youtube.music_6.04.52-60452240.apk
├── com.google.android.apps.youtube.music_6.11.52-61152240_minAPI21(arm64-v8a)(nodpi)_apkmirror.com.apk
├── com.google.android.apps.youtube.music_6.12.54-61254240_minAPI21(arm64-v8a)(nodpi)_apkmirror.com.apk
├── com.google.android.apps.youtube.music_6.13.52-61352240_minAPI21(arm64-v8a)(nodpi)_apkmirror.com.apk
└── YouTube Music_6.13.52_Apkpure.apk
———————————————————————
processor architecture : arm64-v8a
type 'download' for downloading the apk from apkmirror / 'cancel' to continue without downloading
```

first type `download` if you don't have any apk :

-   download the apk from apkmirror
-   move it to `apk/youtube_music` or `apk/youtube` or `apk/instagram`

what you should answer if you want to use youtube music `6.04.52` :

```
➤ your choice : com.google.android.apps.youtube.music_6.04.52-60452240.apk
choosing : apk/youtube_music/com.google.android.apps.youtube.music_6.04.52-60452240.apk
➤ output version : 6.04.52
```

## patching the apk

either use

```bash
zsh complete_install.zsh
```

or individually

```bash
zsh microg.zsh
zsh youtube.zsh
zsh youtube_music.zsh
zsh instagram.zsh
```

## changing the apk used by the script without downloading revanced binaries

```bash
zsh update_revanced.zsh -n
```

## check if there is a newer version of revanced

```bash
zsh check.zsh
```
