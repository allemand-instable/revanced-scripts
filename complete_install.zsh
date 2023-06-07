adb shell exit

microg_package=$(adb shell pm list packages | grep com.mgoogle.android.gms)

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.youtube
else
    echo "not installed"
fi


revanced_package=$(adb shell pm list packages | grep revanced.android.youtube)

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.youtube
else
    echo "not installed"
fi

revanced_music_package=$(adb shell pm list packages | grep revanced | grep youtube.music)
if [[ -n "${revanced_music_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.apps.youtube.music
else
    echo "not installed"
fi


source microg.zsh
source youtube.zsh
source youtube_music.zsh