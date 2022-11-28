# PowerPlanSwitcher 🔋
中文版在[这里](README_cn.md)

Switching between different power plans with ease, including shortcuts and decent GUI.

If you are a user of ROG G14 (G401IV to be exact), then congratulations! You're able to additionally modified fan curves and TDPs at the same time!

Video introduction in Chinese is [here](https://www.bilibili.com/video/BV17N4y1c73i)
## Introduction
The following features are supported:
- Live-updated tray icon according to current power plan:
    - 🍃: Power Saver
    - ☯️: Balanced
    - 🚀: High Performance
    - ☢: Ultimate Performance
    - 🔋: Others
- Menu of power plans to choose from after clicking on the tray icon, displayed at bottom right area.

    ![](image/2022-08-07-20-17-49.png)
- Automatically switch to specific power plans when on battery or plugged in (both default to "Balanced").
- <kbd>Win</kbd>+<kbd>F4</kbd> to switch between different power plans in the menu, similar to the experience of switching different windows using <kbd>alt</kbd>+<kbd>tab</kbd>.
- <kbd>Win</kbd>+<kbd>F5</kbd> to switch between 3 predefined power plans instantly (default to "Power saver", "Balanced" and "High performance"). Similar to <kbd>Fn</kbd>+<kbd>F5</kbd> on Asus/ROG computers, which use Armoury Crate by default.
- OSD after switching to different plans

    ![](image/Screenshot%20(21).png)

    > osd is not mainly implemented by me. I make some modifications based on others' code, but forget the repo's name. Sorry for the original author.
- Editable configurations in `setting.ini`, in which you can modify:
    - `[G14]`: whether your computer is ROG G14 or not
    - `[Shortcuts]`: whether to enable <kbd>Win</kbd>+<kbd>F4</kbd> or <kbd>Win</kbd>+<kbd>F5</kbd>
    - `[DefaultThreeModes]`: three power plans that <kbd>Win</kbd>+<kbd>F5</kbd> will switch between. 

        The switching process loops in the following order: $2\rightarrow3\rightarrow2\rightarrow1\rightarrow2(\text{next iteration starts})$
    - `[ACDCModes]`: whether to enable "automatically change power plans" when on battery or plugged in, as well as what plans to switch to.

---

The following features are ONLY available for ROG G14 (G401IV) devices:

When switching to "Power Saver", "Balanced", "High Performance" or "Ultimate Performance":
- Fan curves will be changed

    relies on `.\vbs\tools\atrofac-cli.exe`, thanks to [cronosun/atrofac](https://github.com/cronosun/atrofac)
- TDPs will also be changed

    relies on `.\vbs\tools\ryzenadj-win64\ryzenadj.exe`, thanks to [FlyGoat/RyzenAdj](https://github.com/FlyGoat/RyzenAdj)

They can also be modified, as long as you change the corresponding vbs scripts under `.\vbs` folder

## Installation and Usage
- Installation

    No installation process is needed, simply download all the files
- Usage

    Before you start the program, make sure you've **checked all configurations** in `setting.ini`, especially if you're not a G14 user.

    Then double click on `PowerPlanSwitcher.exe`, you'll see the icon on task bar/tray.

    If you wish it to launch at startup, create a shortcut for `PowerPlanSwitcher.exe`, then put it in "Startup" folder (<kbd>Win</kbd>+<kbd>R</kbd>, enter `shell:startup` to enter the "Startup" folder)


## Stargazers over time

[![Stargazers over time](https://starchart.cc/Ladbaby/PowerPlanSwitcher.svg)](https://starchart.cc/Ladbaby/PowerPlanSwitcher)

