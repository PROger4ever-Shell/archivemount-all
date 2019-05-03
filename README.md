# archivemount-all
This script helps to mount a batch of archives using built-in GNU-utilities, bash shell and archivemount utility.
It recreates directory structure (path) in mount-dir for every found archive.
## Simple usage
```
./archivemount.bash "/media/MyVolume/My Archives/" ~/archivemount/
```
## Advanced usage
Parameters for find-utility can be specified by the 3rd argument, parameters for archivemount-utility can be specified by the 4th argument (otherwise they are default):
```
./archivemount.bash "/media/MyVolume/My Archives/" ~/archivemount/ "-name *.tar -o -name *.tar.gz" "-o ro"
```
The script can be modified to do anything else with a batch of files.
# Disclaimer
The script isn't tested enough and being distributed AS-IS. Be careful ;-)
