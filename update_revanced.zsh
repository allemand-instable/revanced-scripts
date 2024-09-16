# DOCS :
# *description :
#       download the latest versions of revanced cli and update the patches scripts which automate the process of patching and installing the patched app
# *flags :
#       ➤ -n : do not download new binaries from github
#       ➤ -y : choose youtube binary
#       ➤ -m : choose youtube music binary
#       ➤ -t : choose tiktok binary
#       ➤ -a : all binaries
#       ➤ -u : update revanced only
#       ➤ Nothing : show help

# ~ —————————————————————
# ~       FUNCTIONS
# ~ —————————————————————

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

map_folder_to_app_name(){
    # remove apk/ at the beginning
    local folder_name=$(tr -d 'apk/' <<< "$*")
    #
    case "${folder_name}" in
        "youtube")
            echo "com.google.android.youtube"
            ;;
        "youtube_music")
            echo "com.google.android.apps.youtube.music"
            ;;
        "tiktok")
            echo "com.zhiliaoapp.musically"
            ;;
        "reddit")
            echo "com.reddit.frontpage"
            ;;
        "instagram")
            echo "com.instagram.android"
            ;;
        *)
            echo "unknown"
            return 1
            ;;
    esac
}

function update_apk_names {
    #
    local apk_folders=("$@")

    for apk_current_folder in "${apk_folders[@]}"; do
        echo "——————— 📂 APK 📂 ———————"
        if [ "$(command -v exa)" ]; then
            exa --tree --level=2 --color=always --sort=ext --group-directories-first "${apk_current_folder}"
        else
            ls -p "${apk_current_folder}" | grep -v /
        fi
        echo "———————————————————————"
        echo "processor architecture : $(adb shell getprop ro.product.cpu.abi)"
        # user needs to know the architecture of his phone to download the right apk file
        echo "type 'download' for downloading the apk from apkmirror / 'cancel' to continue without downloading"
        while true; do
            if [[ "${SHELL}" == *"zsh"* ]]; then
                read 'choice?➤ your choice : '
            else
                read -p "➤ your choice : " choice
            fi
            
            if [ -f "${apk_current_folder}/${choice}" ]; then
                
                echo "choosing : ${apk_current_folder}/${choice}"
                
                # $ input
                current_folder=$(tr -d 'apk/' <<< "${apk_current_folder}")
                sed -i.bak "5 s/.*/apk_file=\"\.\/apk\/${current_folder}\/${choice}\"/" "${current_folder}.zsh"
                
                # $ output
                #
                if [[ "${SHELL}" == *"zsh"* ]]; then
                    read 'output_version?➤ output version : '
                else
                    read -p "➤ output version : " output_version
                fi
                #
                sed -i.bak "6 s/.*/output_file=\"\.\/output\/output_${current_folder}_${output_version}.apk\"/" "${current_folder}.zsh"

                break
                
            elif [[ "${choice}" == "download" ]]; then
            
                echo "getting to download page"
                download_version=$(get_highest_common_versions "$(map_folder_to_app_name "${apk_current_folder}")")
                if [[ "${os}" == "Darwin" ]]; then
                    # Do something under Mac OS X platform
                    echo "Mac OS X"
                    open "https://www.apkmirror.com/?post_type=app_release&searchtype=apk&s=youtube+${download_version}&arch%5B%5D=universal&arch%5B%5D=arm64-v8a&dpi%5B%5D=nodpi"
                else
                    # Do something under GNU/Linux platform
                    echo "GNU/Linux"
                    echo "please download youtube apk from : https://www.apkmirror.com/?post_type=app_release&searchtype=apk&s=youtube+${download_version}&arch%5B%5D=universal&arch%5B%5D=arm64-v8a&dpi%5B%5D=nodpi"
                fi

                
            elif [[ "${choice}" == "cancel" ]]; then
                break
            else
                echo "${apk_current_folder}/${choice} does not exist"
            fi
        done

    done
}

function update_revanced(){
    echo "updating revanced..."
    cd bin
    # pwd
    # deletes the previous files
    rm -r *.jar
    rm -r *.json
    
    # ❗ download the file (browser_download_url corresponds to the jar file) in bin

    echo "downloading latest cli version..."
    curl -s https://api.github.com/repos/revanced/revanced-cli/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    
    echo "downloading latest patch version..."
    curl -s https://api.github.com/repos/revanced/revanced-patches/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    
    cd ../
    cd apk
    echo "downloading latest integrations version..."
    curl -s https://api.github.com/repos/revanced/revanced-integrations/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -

    # ❗ fetching the latest versions on github
    # % Step by Step Explanation
    # curl ➤
    # {
    #     "url": "https://api.github.com/repos/revanced/revanced-patches/releases/105483987",
    #     "html_url": "https://github.com/revanced/revanced-patches/releases/tag/v2.175.0",
    #     "author": {
    #         "login": "revanced-bot",
    #     [...]
    # }
    # grep ➤ "tag_name": "v2.175.0"
    # 🤔 cut : extract the second and third fields of each line using ":" as the delimiter. keeps only the version number.
    # cut ➤ "v2.21.2"
    # 🤔 tr : delete the double quotes, v, spaces
    # tr ➤ 2.21.2

    echo "fetching latest patch version..."
    patches_version_var=$(curl -s https://api.github.com/repos/revanced/revanced-patches/releases/latest \
        | grep "tag_name" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d \, \
        | tr -d v \
        | tr -d " " \
    )

    echo "fetching latest cli version..."
    cli_version_var=$(curl -s https://api.github.com/repos/revanced/revanced-cli/releases/latest \
        | grep "tag_name" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d \, \
        | tr -d v \
        | tr -d " " \
    )

    echo "fetching latest integrations version..."
    integrations_version_var=$(curl -s https://api.github.com/repos/revanced/revanced-integrations/releases/latest \
        | grep "tag_name" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d \, \
        | tr -d v \
        | tr -d " " \
    )

    echo "newest version [cli] : ${cli_version_var}"
    echo "newest version [patches] : ${patches_version_var}"

    # ❗ modify the automation shell scripts to patch youtube apps
    echo "updating the scripts..."
    cd ../
    echo "➤ youtube.zsh"
    sed -i.bak "1 s/.*/cli_file=\"\.\/bin\/revanced-cli-${cli_version_var}-all.jar\"/" youtube.zsh
    sed -i.bak "2 s/.*/patch_file=\"\.\/bin\/revanced-patches-${patches_version_var}.jar\"/" youtube.zsh
    sed -i.bak "3 s/.*/integration_file=\"\.\/apk\/revanced-integrations-${integrations_version_var}.apk\"/" youtube.zsh
    # ➤ youtube music
    # cd ../
    echo "➤ youtube_music.zsh"
    sed -i.bak "1 s/.*/cli_file=\"\.\/bin\/revanced-cli-${cli_version_var}-all.jar\"/" "youtube_music.zsh"
    sed -i.bak "2 s/.*/patch_file=\"\.\/bin\/revanced-patches-${patches_version_var}.jar\"/" youtube_music.zsh
    sed -i.bak "3 s/.*/integration_file=\"\.\/apk\/revanced-integrations-${integrations_version_var}.apk\"/" "youtube_music.zsh"
    # ➤ tiktok
    # TODO : TIKTOK NOT IMPLEMENTED YET
    # cd ../
    # echo "➤ tiktok.zsh"
    # sed -i.bak "1 s/.*/cli_file=\"\.\/bin\/revanced-cli-${cli_version_var}-all.jar\"/" "tiktok.zsh"
    # sed -i.bak "2 s/.*/patch_file=\"\.\/bin\/revanced-patches-${patches_version_var}.jar\"/" tiktok.zsh
    # sed -i.bak "3 s/.*/integration_file=\"\.\/apk\/revanced-integrations-${integrations_version_var}.apk\"/" "tiktok.zsh"
}


# if [ "$(command -v exa)" ]; then
#     exa --color=always --sort=ext --group-directories-first --icons
# fi

# pwd
apk_folders=("apk/youtube" "apk/youtube_music" "apk/tiktok" "apk/reddit" "apk/instagram")


# ~ —————————————————————
# ~       SCRIPT
# ~ —————————————————————

# ⭐ active le flag si un argument - est présent
flag=false
update_revanced_flag=false
pipeline=()
OPTIND=1
# * 1 | define a pipeline given the argument letters
while getopts 'nymtauh' opt; do
    case $opt in
        n) update_revanced_flag=false; flag=true ;;
        y) pipeline+='apk/youtube'; flag=true ;;
        m) pipeline+='apk/youtube_music'; flag=true ;;
        t) pipeline+='apk/tiktok'; flag=true ;;
        a) pipeline+=('apk/youtube' 'apk/youtube_music' 'apk/tiktok'); flag=true ;;
        u) update_revanced_flag=true; flag=true ;;
        h) pipeline+='help'; flag=false ;;
        *) echo 'Error in command line parsing' >&2
            exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

# 🤔 equivalent en python ————————————
# *flag = False
# *for arg in sys.argv[1:]:
# *    if arg == '-n':
# *        flag = True
# *    else:
# *        break
# £———————————————————————————————————

# * 2 | if there was arguments (letters), either update revanced binaries, or if other letters, then update apk files according to the one in the pipeline (list)
if "$flag"; then
    # Execution de l'update
    
    # if [[ "${pipeline[*]}" =~ "revanced" ]]; then
    if "$update_revanced_flag"; then
        update_revanced
    fi

    if [[ "${#pipeline[@]}" -gt 0 ]]; then
        echo "asked Pipeline :"
        echo "$pipeline" | tr " " "\n"
        update_apk_names "${pipeline[@]}"
    fi
else
    echo "available options:"
    echo "
    ➤ -u : update revanced binaries
    ➤ -t : update tiktok
    ➤ -y : update youtube
    ➤ -m : update youtube music
    ➤ -a : all apk (not revanced)
    ➤ -h : show help
    "
fi