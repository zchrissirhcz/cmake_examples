# NDK开发 - 常用 adb 命令

## 添加udev规则，用来挂载android机，ubuntu上调试android真机必备
1) lsusb
PC上，分别在插入和不插入手机usb线的情况下，执行lsusb，获得手机真机的xx和xx。例如：
```bash
⚡ lsusb                                                           
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub    
Bus 001 Device 002: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub    
```
其中ID后的xxxx:yyyy分别是idVendor和idProduct，在udev规则文件中需要他俩。

2) 添加udev规则
根据上一步查找的idVendor和idProduct，添入新建的规则文件中：
vim /etc/udev/rules.d/51-android.rules
```
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", ATTRS{idProduct}=="ff48", MODE="0666"
```

3) 赋予权限
```bash
chmod a+r /etc/udev/rules.d/51-android.rules
```

4) 等待； 或者重启 host
可尝试 `sudo systemctl restart udev`， 或重新插拔设备。 若确实长时间没反应（1分钟以上）， 可考虑重启主机。

通常很快就能查询到设备 (`adb devices`).

5）手机上的设定

- 需要开启USB调试（设置->...->开启“开发者选项”，并且开启”USB调试“和”USB安装“

- 需要选择**MTP连接**(新版Android叫做“传输文件”)方式，否则可能遇到报错：

```
adb: insufficient permissions for device: user in plugdev group; are your udev rules wrong?
```

参考: https://stackoverflow.com/questions/28704636/insufficient-permissions-for-device-in-android-studio-workspace-running-in-opens

## 列出所有设备
```bash
adb devices  
```

## 连接到android设备上并执行shell脚本
```
adb connect 127.0.0.1  #连接虚拟机
adb connect #连接为一个的那个真机
adb shell #连接到adb shell上，接下来就可以执行各种bash命令了
adb disconnect #退出连接
```

## 模拟器emulator的设定
Android Studio 自带模拟器root时：adbd cannot run as root in production builds

需要检查模拟器的target版本，括号里为 (Google Play) 的版本无法root，只用为 (Google APIs) 的才可以，重新下载正确的版本即可

## 关CPU
小米8搭载的是QCOM845，可以用：
```bash
echo "1" > /sys/devices/system/cpu/cpu2/online  # 开
echo "1" > /sys/devices/system/cpu/cpu2/online  # 关
cat /sys/devices/system/cpu/cpu2/online  # 查看
```

## 是否要root手机？
root后，可以自行创建/data/pixel这样的目录，存放可执行文件等。比较自由。但系统也会因此不安全。
不root，只能把可执行文件或者.so文件，push到`/data/local/tmp`目录。其实基本上够用了。

## D1 RISC-V 开发板
很多开发板如 RISC-V 或 NPU 会提供 adb 的支持， 也就是通过板子上 OTG 口连接的 USB 线， 同时提供电源和数据传输功能（adb 命令）。

直接在同一个 udev 文件中添加规则即可。