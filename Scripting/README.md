# Scripting
This directory contains some of my works related to scripting for general IT purposes. As of currently, the script I made was from my hobby--to mod Skyrim.

## 1. Mod Archive Management
### Background
So, I often get burnouts from my job as a part-time teacher. The students in my school are too disruptive thanks to their parents' education model in the family. So, I decided to calm and relax myself by playing Skyrim, my most favorite game of all time. But, playing a 2011 game with its original graphics and gameplay seems too ancient. Therefore, I downloaded some mods and modlist from Nexusmods for me to enjoy Skyrim with.

### The Problem
I downloaded many modlists including NOLVUS V5, NOLVUS V6, LoreRim, Gate to Sovngarde, and DOMAIN; some of which have same mods one to another. This means, I downloaded identical mods for each of the modlist. This is, of course, a waste of storage. As you can see in the image, the mods I have downloaded have reached thousands and this is only from 2 modlists. Also, for every new modlist I'm downloading, some of the mods from other already downloaded modlists are also required by the other modlist.
In short, below are what I pondered:
1. _how to know whether mods in modlist X is required by soon-to-be-installed modlist Y so that I don't download the mods that I already have somewhere in my storage (other modlist directory)?_
2. _how to manage mod files to preserve storage space? I downloaded duplicate mods for some modlists, which then unnecessarily consumed my storage space._

### The Method
1. Make a list of mods filename for each modlist directory.
```console
$ ls > modlist1.txt
```
2. Create a centralized directory for all of the mods from all modlists that I have downloaded.
3. Move each of the mods filename to the centralized mod directory.
4. Write a Python script to copy or move files from a specified txt file to a destination directory.

### The algorithm for the script
1. Check whether the mod filenames in the `.txt` modlist file exist in the specified directory.
2. Return the number of (1) identical filenames and (2) unique filenames.
3. Ask the user whether to commence the file migration.
4. If getting a yes from the user, then do file move operation to the specified directory; else, exit.

### Conclusion and TL;DR
This is a simple file check/comparison from a txt to any specified directory and then do file move operation.
