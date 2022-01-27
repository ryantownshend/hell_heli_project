import os
import sys
import ctypes
from subprocess import call, DEVNULL
from os import listdir
from os.path import isfile, join

# arma_missions_folder = Path.home() / "Documents" / "Arma 3" / "mpmissions"
arma_missions_folder = "C:/Users/dent/Documents/Arma 3 - Other Profiles/A%2eDent/missions"
mission = "hell_heli_refactored"
maps_dir = "maps"


def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False


def mission_name(map_name):
    return f"{mission}.{map_name}"


def mission_actual(map_name):
    actual = f'{arma_missions_folder}/{mission_name(map_name)}'
    if not os.path.isdir(actual):
        os.mkdir(actual)
    return actual


def make_link(link, target):
    '''params:
    link is the destination path
    target is the actual file or folder to link to the destination

    testing this on a windows 7 box and the mklink /H command works best so far
    '''

    args = ['mklink', "/H", link, target]
    call(args, shell=True, stderr=DEVNULL, stdout=DEVNULL)


def list_maps(maps_dir):
    maps = [f.name for f in os.scandir(maps_dir) if f.is_dir()]
    return maps


def list_mission_files():
    onlyfiles = []
    for f in listdir(mission):
        if isfile(join(mission, f)):
            onlyfiles.append(f)
    return onlyfiles


def list_map_files(map_name):
    onlyfiles = []
    for f in listdir(join("maps", map_name)):
        if isfile(join("maps", map_name, f)):
            onlyfiles.append(f)
    return onlyfiles


def main():

    # if(not is_admin()):
    #     print("NOT ADMIN, come back when you are admin.")
    #     sys.exit(2)

    # print("IS ADMIN")

    # gather list of maps
    map_names = list_maps(maps_dir)

    # gather list of mission files
    mission_files = list_mission_files()

    # wire up each mission folder per map
    for map_name in map_names:
        print(f"Setting up map : {map_name}")
        mission_path = mission_actual(map_name)
        # print(mission_path)

        # symlink in the mission files
        for file in mission_files:
            link = join(mission_path, file)
            target = join(mission, file)
            make_link(link, target)

        # symlink in the map specific files
        map_files = list_map_files(map_name)
        for file in map_files:
            link = join(mission_path, file)
            target = join("maps", map_name, file)
            make_link(link, target)


if __name__ == '__main__':
    main()
