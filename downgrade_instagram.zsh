youtube_apk="apk/instagram/com.instagram.android_275.0.0.27.98-367507870_minAPI28(arm64-v8a)(nodpi)_apkmirror.com.apk"

adb shell exit

connected_device=$(
    adb devices \
    | sed -n 2p \
    | tr -d 'device' \
    | tr -d '\t'
)

adb devices
echo liste des packages google
adb shell pm list packages -u | egrep "instagram"
echo pm uninstall --user 0 com.instagram.android
echo adb install -d "${youtube_apk}"
# adb shell
adb install -d "${youtube_apk}"
