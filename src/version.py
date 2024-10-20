from typing import List, Dict, TypedDict, Optional, Self
from numpy import argmax, argmin, array

class Version:
    def __init__(self, v) -> None:
        self.version : str = v
        self.list : List[int] = [int(nb) for nb in self.version.split(".")]
        self.array = array(self.list)
        self.dim : int = len(self.list)
        
    def __le__(self, other : Self) -> bool :
        if self.dim != other.dim :
            print("dimension of versioning is different, will compare from left to right")
            d = min(self.dim, other.dim)
            l = self.array[:d]
            r = other.array[:d]
        else :
            l = self.array
            r = other.array
        less = l < r
        eq = l == r
        # il suffit de regarder le premier nombre où la version n'est pas égale et regarder si elle est plus grande ou plus petite
        first_false=argmin(eq)
        return less[first_false]
    def __ge__(self, other : Self) -> bool :
        if self.dim != other.dim :
            print("dimension of versioning is different, will compare from left to right")
            d = min(self.dim, other.dim)
            l = self.array[:d]
            r = other.array[:d]
        else :
            l = self.array
            r = other.array
        greater = l > r
        eq = l == r
        # il suffit de regarder le premier nombre où la version n'est pas égale et regarder si elle est plus grande ou plus petite
        first_false=argmin(eq)
        return greater[first_false]
    def __lt__(self, other : Self) -> bool :
        if self.dim != other.dim :
            print("dimension of versioning is different, will compare from left to right")
            d = min(self.dim, other.dim)
            l = self.array[:d]
            r = other.array[:d]
        else :
            l = self.array
            r = other.array
        less = l < r
        eq = l == r
        # il suffit de regarder le premier nombre où la version n'est pas égale et regarder si elle est plus grande ou plus petite
        first_false=argmin(eq)
        return less[first_false]
    def __gt__(self, other : Self) -> bool :
        if self.dim != other.dim :
            print("dimension of versioning is different, will compare from left to right")
            d = min(self.dim, other.dim)
            l = self.array[:d]
            r = other.array[:d]
        else :
            l = self.array
            r = other.array
        greater = l > r
        eq = l == r
        # il suffit de regarder le premier nombre où la version n'est pas égale et regarder si elle est plus grande ou plus petite
        first_false=argmin(eq)
        return greater[first_false]

def version_sort(versions : List[str]) -> List[str]:
    L = [ Version(v) for v in versions ]
    return [ver.version for ver in sorted(L, reverse=True)]
    
def version_max(versions : List[str]) -> str:
    L = [ Version(v) for v in versions ]
    m = max(L)
    return m.version
