# DOCS :
# *description :
#       download the latest versions of revanced cli and update the patches scripts which automate the process of patching and installing the patched app
# *flags :
#       ➤ -n : do not download new binaries from github

os=$(uname)

# ⭐ active le flag si l'argument -n est présent
flag=false
OPTIND=1
while getopts 'n' opt; do
    case $opt in
        n) flag=true ;;
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

if "$flag"; then
    # ne pas download si -n
else
    cd bin
    # deletes the previous files
    rm -r *.jar
    rm -r *.json
    
    # ❗ download the file (browser_download_url corresponds to the jar file) in bin
    curl -s https://api.github.com/repos/revanced/revanced-cli/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    
    curl -s https://api.github.com/repos/revanced/revanced-patches/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    
    cd ../
    cd apk
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

    patches_version_var=$(curl -s https://api.github.com/repos/revanced/revanced-patches/releases/latest \
        | grep "tag_name" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d \, \
        | tr -d v \
        | tr -d " " \
    )

    cli_version_var=$(curl -s https://api.github.com/repos/revanced/revanced-cli/releases/latest \
        | grep "tag_name" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d \, \
        | tr -d v \
        | tr -d " " \
    )

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
    cd ../
    sed -i.bak "1 s/.*/cli_file=\"\.\/bin\/revanced-cli-${cli_version_var}-all.jar\"/" youtube.zsh
    sed -i.bak "2 s/.*/patch_file=\"\.\/bin\/revanced-patches-${patches_version_var}.jar\"/" youtube.zsh
    sed -i.bak "3 s/.*/integration_file=\"\.\/apk\/revanced-integrations-${integrations_version_var}.apk\"/" youtube.zsh
fi


# ❗ updating the apk

if [ "$(command -v exa)" ]; then
    exa --color=always --sort=ext --group-directories-first --icons
fi



apk_folders=("apk/youtube" "apk/youtube_music")

for apk_current_folder in "${apk_folders[@]}"; do
    echo "——————— 📂 APK 📂 ———————"
    if [ "$(command -v exa)" ]; then
        exa --tree --level=2 --color=always --sort=ext --group-directories-first "${apk_current_folder}"
    else
        ls -p "${apk_current_folder}" | grep -v /
    fi
    echo "———————————————————————"
    echo "type 'download' for downloading the apk from apkmirror"
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
            if [[ "${os}" == "Darwin" ]]; then
                # Do something under Mac OS X platform
                echo "Mac OS X"
                open "https://www.apkmirror.com/?post_type=app_release&searchtype=apk&s=youtube&arch%5B%5D=universal&arch%5B%5D=arm64-v8a&dpi%5B%5D=nodpi"
            else
                # Do something under GNU/Linux platform
                echo "GNU/Linux"
                echo "please download youtube apk from : https://www.apkmirror.com/?post_type=app_release&searchtype=apk&s=youtube&arch%5B%5D=universal&arch%5B%5D=arm64-v8a&dpi%5B%5D=nodpi"
            fi

            
        elif [[ "${choice}" == "cancel" ]]; then
            break
        else
            echo "${apk_current_folder}/${choice} does not exist"
        fi
    done

done