cli_file="./bin/revanced-cli-4.0.2-all.jar"
patch_file="./bin/revanced-patches-2.195.0.jar"
integration_file="./apk/revanced-integrations-0.120.0.apk"

apk_file="./apk/youtube_music/com.google.android.apps.youtube.music_6.23.54-62354240_minAPI24(arm64-v8a)(nodpi)_apkmirror.com.apk"
output_file="./output/output_youtube_music_6.23.54.apk"
# output_file="./output/output_youtube_music_6.04.52.apk"


adb shell exit

# get the adb device id number of the connected device
connected_device=$(
    adb devices \
    | sed -n 2p \
    | tr -d 'device' \
    | tr -d '\t'
)

echo "$connected_device"

revanced_package=$(adb shell pm list packages | grep revanced | grep youtube.music)
if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.apps.youtube.music
else
    echo "youtube music not installed, no need to uninstall it"
fi

java    -jar "${cli_file}"  \
--apk "${apk_file}" \
-c                  \
-d ${connected_device} \
-o "${output_file}" \
-m ${integration_file} \
-b "${patch_file}"