youtube_apk="./apk/com.google.android.youtube_18.03.36.apk"

adb shell exit

connected_device=$(
    adb devices \
    | sed -n 2p \
    | tr -d 'device' \
    | tr -d '\t'
)

adb devices
echo liste des packages google
adb shell pm list packages -u | egrep "google"
echo pm uninstall --user 0 com.google.android.youtube
echo adb install -d "${youtube_apk}"
# adb shell
adb install -d "${youtube_apk}"