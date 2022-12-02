# [Phasmophobia](https://kineticgames.co.uk/)
[![Discord](https://img.shields.io/discord/785233414374686720?label=Discord&logo=discord)](https://discord.gg/WMeCsQhakH)
[![License](https://img.shields.io/github/license/Cryotheus/pyrition_2)](https://github.com/Cryotheus/pyrition_2/blob/main/LICENSE)  
As a Gamemode for [Garry's Mod](https://gmod.facepunch.com/).  
From the [Phasmophobia](https://store.steampowered.com/app/739630/Phasmophobia/) store page:
> Phasmophobia is a 4 player online co-op psychological horror where you and your team members of paranormal investigators will enter haunted locations filled with paranormal activity and gather as much evidence of the paranormal as you can. You will use your ghost hunting equipment to search for and record evidence of whatever ghost is haunting the location to sell onto a ghost removal team.

# Installation
## For Players
If I ever finish this Gamemode, I will post it on the workshop so you won't have to perform these steps.

1. Download this repository [here](https://github.com/Cryotheus/phasmophobia/archive/refs/heads/main.zip).
2. Extract the ZIP archive.
3. Place the extracted folder in your `GarrysMod/garrysmod/addons` directory
4. Repeat steps 1 - 3 for [Pyrition](https://github.com/Cryotheus/pyrition)

The newly placed `phasmophobia` folder should be next to folders named `base`, `sandbox`, and `terrortown`.

## For Servers
Perform the **For Players** steps using your server's directory instead.

1. Install a *Garry's Mod Dedicated Server* on the *x86-64* branch.
	* Use the `-beta x86-64` parameter in your `app_update` command eg. `app_update 4020 -beta x86-64 validate`
	* For Windows servers, if you want color in your console try using [`gmsv_concolormsg`](https://github.com/WilliamVenner/gmsv_concolormsg). For Linux, color is available through normal means using Lua scripts. I don't use Linux so find some other programmer to bother for a solution.
2. Make sure your server's launch Gamemode is set to `phasmophobia`
	* As a launch parameter: `+gamemode phasmophobia`
	* As a command for `autoexec.cfg`: `gamemode phasmophobia`
3. Make sure your server's launch map is set to `phas_lobby`.
	* As a launch parameter: `+map phas_lobby`
	* As a command for `autoexec.cfg`: `map phas_lobby` (side note, make sure you have the map command after the gamemode command)

### Voice Features
If you want to let your player base speak to the ghost over voice chat, follow the steps below.
1. Install [Goqui](https://github.com/Cryotheus/gmod-goqui) speech-to-text
2. Install [EightBit](https://github.com/Meachamp/gm_8bit) voice relay

Your server should now have voice features, and clients do not need to install any binary modules.  
If it does not work, make sure your network allows loopback networking.

# For Developers
The source code uses descriptive variable names and comments where necessary.
Details on the purpose and usage of entities are provided in the default `ENT`/`SWEP` fields.