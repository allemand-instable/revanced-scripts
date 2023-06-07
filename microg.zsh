cd apk/microg

rm microg.apk

micro_g_version_var=$(curl -s https://api.github.com/repos/inotia00/VancedMicroG/releases/latest \
    | grep "tag_name" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | tr -d \, \
    | tr -d v \
    | tr -d " " \
)

curl -s https://api.github.com/repos/inotia00/VancedMicroG/releases/latest \
| grep "browser_download_url" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -


microg_package=$(adb shell pm list packages | grep com.mgoogle.android.gms)

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.youtube
else
    echo "not"
fi

adb shell exit
adb devices
adb install "microg.apk"