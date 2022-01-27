import os

folder = "C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools"


def check_for_tools():
    if not os.path.isdir(folder):
        print("Arma 3 Tools not installed or installed somewhere unexpected")
        return False
    else:
        return True


def get_tools():
    return folder


def tool_image_to_paa():
    return os.path.join(get_tools(), "ImageToPAA", "ImageToPAA.exe")


def tool_publisher():
    return os.path.join(get_tools(), "Publisher", "Publisher.exe")


def tool_addon_builder():
    return os.path.join(get_tools(), "AddonBuilder", "AddonBuilder.exe")
