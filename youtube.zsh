cli_file="./bin/revanced-cli-4.6.0-all.jar"
patch_file="./bin/revanced-patches-4.13.3.jar"
integration_file="./apk/revanced-integrations-1.13.0.apk"

apk_file="./apk/youtube/com.google.android.youtube_19.16.39.apk"
output_file="./output/output_youtube_19.16.39.apk"


adb shell exit

connected_device=$(
    adb devices \
    | sed -n 2p \
    | sed 's/device//g' \
    | sed 's/\t//g' \
    | sed 's/ //g'
)

echo "$connected_device"

revanced_package=$(adb shell pm list packages | grep revanced.android.youtube)

if [[ -n "${revanced_package}" ]]; then
    echo "is already installed, removing it"
    adb uninstall app.revanced.android.youtube
else
    echo "youtube not installed"
fi

# TODO : ROOT SUPPORT
# if adb shell su -c exit | grep -q "inaccessible or not found"; then
#     echo "String found"
# else
#     echo "String not found"
# fi

flag=false
task="help"
OPTIND=1
while getopts 'pih' opt; do
    case $opt in
        p) task='patch'; flag=true ;;
        i) task='install'; flag=true ;;
        h) task='help'; flag=false ;;
        *) echo 'Error in command line parsing' >&2
            exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

# COMMANDS
# java -jar "${cli_file}" -h
if "$flag"; then
    # PATCH
    if [[ "$task" == "patch" ]]; then
        java -jar "${cli_file}" patch           \
        --patch-bundle "${patch_file}"          \
        --out "${output_file}"                  \
        --device-serial "${connected_device}"   \
        --merge "${integration_file}"           \
        "${apk_file}"
    # INSTALL
    elif [[ "$task" == "install" ]]; then
        java -jar "${cli_file}" utility install \
        -a "${output_file}"                     \
        "${connected_device}"   
    fi
else
    echo "
    ➤ -i : install
    ➤ -p : patch and install
    "
fi

# OLD METHOD
# java -jar "${cli_file}"  \
# --apk "${apk_file}" \
# -c                  \
# -d ${connected_device} \
# -o "${output_file}" \
# -m ${integration_file} \
# -b "${patch_file}"