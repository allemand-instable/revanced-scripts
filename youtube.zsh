cli_file="./bin/revanced-cli-2.22.0-all.jar"
patch_file="./bin/revanced-patches-2.186.0.jar"
integration_file="./apk/revanced-integrations-0.114.0.apk"

apk_file="./apk/youtube/com.google.android.youtube_18.23.35-1538252224_minAPI26(arm64-v8a,armeabi-v7a,x86,x86_64)(nodpi)_apkmirror.com.apk"
output_file="./output/output_youtube_18.23.35.apk"


adb shell exit

connected_device=$(
    adb devices \
    | sed -n 2p \
    | tr -d 'device' \
    | tr -d '\t'
)

echo "$connected_device"

revanced_package=$(adb shell pm list packages | grep revanced.android.youtube)

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.youtube
else
    echo "youtube not installed"
fi



java    -jar "${cli_file}"  \
--apk "${apk_file}" \
-c                  \
-d ${connected_device} \
-o "${output_file}" \
-m ${integration_file} \
-b "${patch_file}"