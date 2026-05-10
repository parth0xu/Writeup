# MyFirstGame Writeup

## Challenge

We were given a Windows executable:

```text
MyFirstGame.exe
```

Flag format:

```text
BtSCTF{}
```

## Initial Analysis

Running `file` showed that the binary was a Windows PE executable:

```text
PE32+ executable (GUI) x86-64, for MS Windows
```

Searching strings showed Godot-related paths and metadata, including:

```text
Godot Engine v4.6.2.stable.official
res://node_2d.gdc
res://node_2d.tscn
```

This told us the game was a Godot 4 export with its project data embedded inside the executable.

## Extracting The Godot Project

Godot exports can embed a `.pck` archive inside the executable. I searched for the Godot pack magic:

```text
GDPC
```

The valid embedded PCK started at:

```text
0x63b6e00
```

I carved it out with:

```bash
dd if=MyFirstGame.exe of=game.pck bs=1 skip=$((0x63b6e00))
```
download this :- GDRE_tools-v2.5.0-beta.5-linux.zip and i saved it as gdre.zip and unzip it 

Then I used GDRE Tools to recover the project:

```bash
gdre_tools.x86_64 --headless \
  --recover=MyFirstGame.exe \
  --output=recovered_game \
  --skip-checksum-check
```

GDRE detected:

```text
Engine Version: 4.6.2
Bytecode Revision: 4.5.0-stable
```

It successfully decompiled the GDScript:

```text
res://node_2d.gdc -> node_2d.gd
```

## Script Logic

The important variables were:

```gdscript
var result = []
var c_bin = ""
var offset = [85, 76, 102, 386, 687, 475, 37, 245, 400, 379, 622, 332, 451, 235, 358, 67, 96, 358, 150]
var magic_numbers = []
var button_order = []
var randomadd = []
var randommult = []
var randomadd2 = []
```

Movement appends bits:

```gdscript
up/down    -> "1"
left/right -> "0"
```

When the player reaches the end tile, the current binary string is converted to an integer:

```gdscript
result.append(c_bin.bin_to_int())
```

Before the hidden magic stage, the label is computed as:

```gdscript
char(result[i] - offset[i])
```

## Solving The Tile Maps

The recovered scene contained 19 `TileMapLayer` nodes. Each layer had:

```text
source_id = 1 -> wall
source_id = 2 -> end
source_id = 3 -> spawn
```

I decoded each `tile_map_data` entry, found the spawn and end cells, and used BFS to recover the path. Each move was converted back into the game's bit encoding.

The resulting values were:

```text
[152, 155, 180, 457, 769, 540, 121, 330, 476, 444, 706, 405, 530, 313, 441, 100, 129, 391, 183]
```

Subtracting the offsets gave:

```text
CONGRATULATIONS!!!!
```

This text is important because it seeds the next RNG:

```gdscript
gen2.seed = int_hash($Label.text)
```

where:

```gdscript
func int_hash(text):
    return text.md5_text().substr(0, 16).hex_to_int()
```

## Hidden Button Order

Once level 20 is reached, the game generates a hidden button order:

```gdscript
for i in range(19):
    button_order.append(gen2.randi() % 600)
```

Using the label `CONGRATULATIONS!!!!`, the button order becomes:

```text
[378, 220, 413, 193, 583, 195, 471, 46, 93, 155, 257, 21, 132, 543, 103, 443, 483, 580, 514]
```

Each hidden function appends a magic number. Mapping the button IDs to their magic values gives:

```text
[37, -31, 41, 96, 72, -64, 16, 30, 180, -85, 132, 110, 92, -58, 54, 67, 62, 228, 36]
```

## Color RNG Seed

The game also checks shuffled colors:

```gdscript
var hashh = str(arg).md5_text()
if hashh == "7a30a264369be8faf4c7860a8a5c511b":
    seedi = str(arg).hash()
    egg.seed = seedi
```

Bruteforcing all permutations of the six colors found the matching order:

```text
blue, yellow, green, red, magenta, cyan
```

This initializes the `egg` RNG used for the final decoding.

## Final Decoding

After collecting all 19 magic numbers, the game switches to `magic = 1` and computes:

```gdscript
r += magic_numbers[i]
char(((r - randomadd2[i]) / randommult[i]) - randomadd[i])
```

Using Godot's own RNG and hash behavior, this decodes to:

```text
h0w_d1d_y0u_f1nd_m3
```

## Flag

```text
BtSCTF{h0w_d1d_y0u_f1nd_m3}
```
