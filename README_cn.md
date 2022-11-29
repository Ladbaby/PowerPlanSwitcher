# PowerPlanSwitcher 🔋
English version is [here](README.md)

通过快捷键、GUI点击等多种方式，轻松在不同的电源计划之间切换。

假如你是ROG 幻14的用户 (G401IV)，那么恭喜你，你可以顺带调整风扇曲线和热设计功耗 (TDP)。

视频介绍[在这里](https://www.bilibili.com/video/BV17N4y1c73i)
## 介绍
包含以下功能：
- 根据当前电源计划，实时更新的托盘图标：
    - 🍃: 节能
    - ☯️: 平衡 
    - 🚀: 高性能
    - ☢: 卓越性能
    - 🔋: 其它
- 点击托盘图标后显示在屏幕右下角的菜单：

    ![](https://raw.githubusercontent.com/Ladbaby/PowerPlanSwitcher/master/image/2022-08-07-20-17-49.png)
- 在插上电源或者拔掉电源 (使用电池)的时候，自动切换至提前设定好的模式 (默认的值均为“平衡”)
- 使用<kbd>Win</kbd>+<kbd>F4</kbd>来显示上述的菜单，继续按则依次遍历所有电源计划，松开快捷键以选中。使用体验类似于Windows下使用<kbd>alt</kbd>+<kbd>tab</kbd>来切换不同窗口
- 使用<kbd>Win</kbd>+<kbd>F5</kbd>来在三个电源计划之间即时切换 (默认为“节能”、“平衡”和“高性能”)。类似于华硕或ROG电脑上借助Armoury Crate使用<kbd>Fn</kbd>+<kbd>F5</kbd>切换的逻辑
- 在切换电源计划之后显示一个半透明提示窗

    ![](https://raw.githubusercontent.com/Ladbaby/PowerPlanSwitcher/master/image/Screenshot%20(21).png)

    > 注：osd部分的代码并非由我主要完成，我仅在别人的代码上做了修改，但是我找不到原作者的仓库了，十分抱歉。
- 通过`setting.ini`文件来对本应用进行设置，包括：
    - `[G14]`: 你的电脑是否是ROG 幻14
    - `[Shortcuts]`: 你是否希望启用<kbd>Win</kbd>+<kbd>F4</kbd>和<kbd>Win</kbd>+<kbd>F5</kbd>两个快捷键
    - `[DefaultThreeModes]`: <kbd>Win</kbd>+<kbd>F5</kbd>将会在这三个模式之间切换，切换的循环顺序为：

        2号->3号->2号->1号->2号 (此时已经开始下一个循环)
    - `[ACDCModes]`: 是否启用“在插电或拔电时切换电源计划”的功能，并且设定你希望分别切换到哪个计划

---

以下功能仅适用于ROG 幻14 (G401IV)机型：

当切换至“节能”、“平衡”或是“高性能”时：
- 风扇曲线将会同步改变

    此功能依赖于`.\vbs\tools\atrofac-cli.exe`，来自这个仓库[cronosun/atrofac](https://github.com/cronosun/atrofac)
- 热设计功耗 (TDP)也会改变

    依赖于`.\vbs\tools\ryzenadj-win64\ryzenadj.exe`，来自这个仓库[FlyGoat/RyzenAdj](https://github.com/FlyGoat/RyzenAdj)

这两个功能同样可以进行自定义，只要你修改`.\vbs`文件夹下，和电源计划同名的vbs脚本即可

## 安装与使用
- 安装

    没有什么特别的安装步骤，不需要配置环境什么的，只要把这个仓库里的文件都下载到电脑上即可
- 使用

    在正式开始使用之前，请确保你已经检查了`setting.ini`中的**所有设置项**，非幻14的机主请尤其注意

    检查完毕后，双击`PowerPlanSwitcher.exe`即可运行，你将会在任务栏或者是托盘区见到该程序的图标

    假如你希望本程序开机就启动，请右键`PowerPlanSwitcher.exe`选择创建快捷方式，然后把这个快捷方式剪切放到Startup文件夹下 (快捷键<kbd>Win</kbd>+<kbd>R</kbd>以调出“运行”窗口，输入命令`shell:startup`然后回车，即可进入Startup文件夹)


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Ladbaby/PowerPlanSwitcher&type=Date)](https://star-history.com/#Ladbaby/PowerPlanSwitcher&Date)

