# Hell Heli Project

A refactor of Dr StrangePete's work with some bugfixes and orchestration.

We will be using [poetry](https://python-poetry.org) to manage the python scripts.

## mission orchestation

Assemble multiple missions, per map using the same codebase.

### `hell_heli_refactored` folder

Edit this one, not the mission folders.

### `setup_missions`

Create the mission folders and appropriate symlinks.

```shell
poetry.exe run setup_missions
```

### `memetext`

Handle writing the map names on the images

- image should be 1024 x 512 png
- Top text will be map name, fontsize 120
- Bottom Text will be "Hell-Heli Refactored" in fontsize 60

Generate the base image used by each map

```shell
poetry.exe run produce_images --name Reshmaan
```

older scripts

```shell
poetry.exe run memetext --image images/wreck.png  --bottom "hell-heli refactored" --fontsize 60 --save wreck2.png
```

Generate the map specific image, later converted to .paa for the mission

```shell
poetry.exe run memetext --image images/wreck_overview.png --fontsize 120 --top "Weferlingen (Winter)" --save images/weferlingen_winter.png
```

Generate the .jpg used for workshop preview, but it in c:\images for simplicity

```shell
poetry.exe run memetext --image images/wreck_overview.png --fontsize 120 --top "Weferlingen (Winter)" --save /c:/images/weferlingen_winter.jpg

```

### imagetopaa

- <https://store.steampowered.com/app/233800/Arma_3_Tools/>
- <https://community.bistudio.com/wiki/ImageToPAA>
- <https://paa.gruppe-adler.de/>

```shell
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\ImageToPAA
```

ImageToPAA --help

```shell
$ ./ImageToPAA.exe --help
Arguments used:
'--help'
Usage:  pal2pace [options] <source> [<destination>]

Options:
        -size=<n>
```

vt7 example
```shell
./ImageToPAA.exe c:/images/vt7.jpg /c:/images/vt7.paa
```

### publishing to workshop

- <https://arma3.com/workshop101>
- <https://community.bistudio.com/wiki/Publisher>
- <https://community.bistudio.com/wiki/Arma_3:_Publisher>
- <https://partner.steamgames.com/doc/sdk/uploading>
