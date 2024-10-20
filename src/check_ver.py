import json
from pprint import pprint
from typing import List, Dict, TypedDict, Optional, Self
import argparse
from .version import Version, version_max, version_sort

# ~ cli arguments setup
# Create a parser
parser = argparse.ArgumentParser()
# Add the -v option
parser.add_argument('-v', '--verbose', action='store_true', help='increase output verbosity')
parser.add_argument("-a", "--app", action="store", help="apk id name of the desired app to be patched")
# Parse the arguments
args = parser.parse_args()


# ~ read JSON
f_path='bin/patches.json'
with open(f_path, 'r') as f:
    patches : List = json.load(f)


# ~ desired app
if args.app :
    desired_app_id = args.app
else :
    desired_app_id = "com.google.android.youtube"
def is_desired_patch(patch : Dict):
    if patch["compatiblePackages"] is not None :
        return any([item["name"] == desired_app_id for item in patch["compatiblePackages"]])
    else :
        return False


# ~ version with most patches
vcount_dict : Dict[str, int] = {}
yt_patches = filter(is_desired_patch, patches)
for patch in yt_patches :
    for compat_pkg in patch["compatiblePackages"] :
        if compat_pkg["name"] == desired_app_id:
            if compat_pkg["versions"] is not None :
                for version in compat_pkg["versions"] :
                    if version in vcount_dict :
                        vcount_dict[version] += 1
                    else :
                        vcount_dict[version] = 1
# * list of versions with most patches :
vmax_list : List[str] = [ ver for ver,nb in vcount_dict.items() if nb == max(vcount_dict.values())]
# * highest version in that list :
max_patch_ver = version_max(vmax_list)


# ~ Return for CLI
# Use the -v option
if args.verbose:
    print("nombre de packages applicables pour com.google.android.youtube par version : ")
    pprint(
        vcount_dict
    )
    print(f"latest version : \n{max_patch_ver}")
else :
    print(max_patch_ver)