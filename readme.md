# Hell Heli Project

A refactor of Dr StrangePete's work with some bugfixes and orchestration.

We will be using [poetry](https://python-poetry.org) to manage the python scripts.

## mission orchestation

Assemble multiple missions, per map using the same codebase. 

### `hell_heli_refactored` folder

Edit this one, not the mission folders.

### `setup_missions`

Create the mission folders and appropriate symlinks.

```
poetry.exe run setup_missions
```


### `memetext`

Handle writing the map names on the images

- image should be 1024 x 512 png 
- Top text will be map name, fontsize 120
- Bottom Text will be "Hell-Heli Refactored" in fontsize 60


Generate the base image used by each map

```
poetry.exe run memetext --image images/wreck.png  --bottom "hell-heli refactored" --fontsize 60 --save wreck2.png
```

Generate the map specific image, later converted to .paa for the mission
```
poetry.exe run memetext --image images/wreck_overview.png --fontsize 120 --top "Weferlingen (Winter)" --save images/weferlingen_winter.png
```

Generate the .jpg used for workshop preview, but it in c:\images for simplicity
```
poetry.exe run memetext --image images/wreck_overview.png --fontsize 120 --top "Weferlingen (Winter)" --save /c:/images/weferlingen_winter.jpg

```




### imagetopaa

- <https://store.steampowered.com/app/233800/Arma_3_Tools/>
- <https://community.bistudio.com/wiki/ImageToPAA>
- <https://paa.gruppe-adler.de/>


```
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\ImageToPAA
```
ImageToPAA --help

```
$ ./ImageToPAA.exe --help
Arguments used:
'--help'
Usage:  pal2pace [options] <source> [<destination>]

Options:
        -size=<n>
```

### publishing to workshop

- <https://arma3.com/workshop101>
- <https://community.bistudio.com/wiki/Publisher>
- <https://community.bistudio.com/wiki/Arma_3:_Publisher>


- <https://partner.steamgames.com/doc/sdk/uploading>

