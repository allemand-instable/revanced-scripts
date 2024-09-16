# Use jq to find the indices of the elements with the specified package name

changing_name_apps=('com.google.android.youtube' 'com.google.android.apps.youtube.music')

function revanced_name(){
    if [[ -z $1 ]]; then
        echo "Please provide an Android app package name"
        return 1
    elif [[ $# -gt 1 ]]; then
        echo "Please provide only one Android app package name"
        return 1
    fi

    local android_app="${1}"
    case $android_app in
        'com.google.android.youtube')
            echo 'app.revanced.android.youtube'
        ;;
        'com.google.android.apps.youtube.music')
            echo 'app.revanced.android.apps.youtube.music'
        ;;
        *)
            return 1
        ;;
    esac
}

function get_highest_common_versions(){    
    if [[ -z $1 ]]; then
        echo "Please provide an Android app package name"
        return 1
    elif [[ $# -gt 1 ]]; then
        echo "Please provide only one Android app package name"
        return 1
    fi

    local android_app="${1}"

    local jq_query="to_entries | map(
        select(
            .value.compatiblePackages != null 
            and (.value.compatiblePackages[].name == \"${android_app}\") 
            and (.value.compatiblePackages[].versions != null)
        )
    ) | .[].key"

    local compatible_packages_index=$(jq -r "$jq_query" bin/patches.json)
    local idx_list=(${(f)compatible_packages_index})

    # Retrieve the names based on the indices
    local highest_versions=()

    for idx in $idx_list; do
        local jq_query=".[${idx}] | .name"
        local name=$(jq -r "${jq_query}" bin/patches.json)
        local jq_query=".[${idx}] | .compatiblePackages[].versions[]"
        local sorted_versions=$(jq -r "${jq_query}" bin/patches.json | sort -V)
        local highest_ver=$(echo $sorted_versions | tail -n 1)
        highest_versions+=("$highest_ver")
    done

    local highest_common_ver=$(echo $highest_versions | tr ' ' '\n' | sort -V | head -n 1)

    echo "${highest_common_ver}"
}


function get_common_versions(){    
    if [[ -z $1 ]]; then
        echo "Please provide an Android app package name"
        return 1
    elif [[ $# -gt 1 ]]; then
        echo "Please provide only one Android app package name"
        return 1
    fi

    local android_app="${1}"

    local jq_query="to_entries | map(
        select(
            .value.compatiblePackages != null 
            and (.value.compatiblePackages[].name == \"${android_app}\") 
            and (.value.compatiblePackages[].versions != null)
        )
    ) | .[].key"

    local compatible_packages_index=$(jq -r "$jq_query" bin/patches.json)
    local idx_list=(${(f)compatible_packages_index})

    # Retrieve the names based on the indices
    local highest_versions=()
    local lowest_versions=()

    for idx in $idx_list; do
        # echo "— $idx —"
        local jq_query=".[${idx}] | .name"
        # echo "$jq_query"
        local name=$(jq -r "${jq_query}" bin/patches.json)
        # echo "Name at index $idx: $name"
        local jq_query=".[${idx}] | .compatiblePackages[].versions[]"
        local sorted_versions=$(jq -r "${jq_query}" bin/patches.json | sort -V)

        local highest_ver=$(echo $sorted_versions | tail -n 1)
        local lowest_ver=$(echo $sorted_versions | head -n 1)
        # echo "Highest version: $highest_ver"
        # echo "Lowest version: $lowest_ver"


        highest_versions+=("$highest_ver")
        lowest_versions+=("$lowest_ver")
    done

    local highest_common_ver=$(echo $highest_versions | tr ' ' '\n' | sort -V | head -n 1)
    local lowest_common_ver=$(echo $lowest_versions | tr ' ' '\n' | sort -V | tail -n 1)

    # using adb, get the version of the app installed on the device
    


    echo "——— $android_app ———"
    echo "Highest (common) versions: $highest_common_ver"
    echo "Lowest (common) versions: $lowest_common_ver"
    
    # if a device is connected via adb 
    connected_device=$(
        adb devices \
        | sed -n 2p \
        | tr -d 'device' \
        | tr -d '\t'
    )

    if [[ -z $connected_device ]]; then
        echo "No device connected"
    else
        if [[ "${changing_name_apps[@]}" =~ "$android_app" ]]; then
            local revanced_app=$(revanced_name $android_app)
            local installed_version=$(adb shell dumpsys package $revanced_app | grep versionName | sed 's/.*=//')
        else 
            local installed_version=$(adb shell dumpsys package $android_app | grep versionName | sed 's/.*=//')
        fi
        echo "installed version: $installed_version"
    fi
    echo "——————————————————"
}


android_apps=('com.google.android.youtube' 'com.reddit.frontpage' 'com.zhiliaoapp.musically' 'com.spotify.music' 'com.google.android.apps.youtube.music')
for app in $android_apps; do
    get_common_versions $app
done
