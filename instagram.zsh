cli_file="bin/revanced-cli-2.21.4-all.jar"
patch_file="bin/revanced-patches-2.178.0.jar"
integration_file="apk/revanced-integrations-0.111.0.apk"

apk_file="apk/instagram/com.instagram.android_275.0.0.27.98-367507870_minAPI28(arm64-v8a)(nodpi)_apkmirror.com.apk"
output_file="./output/output_instagram_275.0.0.27.98.apk"

original_package_name="com.instagram.android"
revanced_package_name="app.revanced.android.instagram"

adb shell exit

connected_device=$(
    adb devices \
    | sed -n 2p \
    | tr -d 'device' \
    | tr -d '\t'
)

echo "$connected_device"

revanced_package=$(adb shell pm list packages | grep ${revanced_package_name})

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall "${revanced_package_name}"
else
    echo "instagram not installed"
fi



java    -jar "${cli_file}"  \
--apk "${apk_file}" \
-c                  \
-d ${connected_device} \
-o "${output_file}" \
-m ${integration_file} \
-b "${patch_file}" \
--include "change-package-name"