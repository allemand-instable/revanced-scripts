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

cli_script_version_var="$( sed -n "1p" youtube.zsh | tr '-' '\n' | sed -n '3p')"
patches_script_version_var="$( sed -n "2p" youtube.zsh | tr '-' '\n' | sed -n '3p' | tr 'jar' '\n' | sed -n '1p' | sed 's/.$//')"
integrations_script_version_var="$( sed -n "3p" youtube.zsh | tr '-' '\n' | sed -n '3p' | tr 'apk' '\n' | sed -n '1p' | sed 's/.$//')"



echo "CLI           : [github] ${cli_version_var} — ${cli_script_version_var} [script]"
echo "Patches       : [github] ${patches_version_var} — ${patches_script_version_var} [script]"
echo "Integrations  : [github] ${integrations_version_var} — ${integrations_script_version_var} [script]"

echo "\n——————————————————\n"

if [[ "$cli_version_var" == "$cli_script_version_var" ]]; then
    echo "cli ok"
fi
if [[ "$patches_version_var" == "$patches_script_version_var" ]]; then
    echo "patches ok"
    else
    echo "patches outdated"
fi
if [[ "$integrations_version_var" == "$integrations_script_version_var" ]]; then
    echo "integrations ok"
    else
    echo "integrations outdated"
fi