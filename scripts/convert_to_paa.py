import os
import sys
from subprocess import call, DEVNULL
from .arma_tools import check_for_tools, get_tools

folder = "C:/Program Files (x86)/Steam/steamapps/common/Arma 3 Tools/ImageToPAA"
command = "ImageToPAA.exe"


def convert():
    args = [os.path.join(get_tools(), "ImageToPAA", command), "--help"]
    call(args, shell=True)
    # call(args, shell=True, stderr=DEVNULL, stdout=DEVNULL)


def main():
    if not check_for_tools():
        sys.exit(2)
    convert()


if __name__ == '__main__':
    main()
