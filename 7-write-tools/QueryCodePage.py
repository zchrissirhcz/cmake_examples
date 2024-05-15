# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Created:  2023-04-26 15:50:01
# Last update: 2023-06-26 19:41:21

import platform


def is_windows():
    return platform.system().lower() == "windows"


if is_windows():
    from winreg import (
        CloseKey,
        OpenKey,
        QueryValueEx,
        SetValueEx,
        HKEY_CURRENT_USER,
        HKEY_LOCAL_MACHINE,
        KEY_ALL_ACCESS,
        KEY_READ,
        REG_EXPAND_SZ,
        REG_SZ,
    )

if __name__ == "__main__":
    if is_windows():
        root = HKEY_LOCAL_MACHINE
        subkey = R"SYSTEM\CurrentControlSet\Control\Nls\CodePage"

        key = OpenKey(root, subkey, 0, KEY_READ)
        name = "ACP"

        try:
            codepage, _ = QueryValueEx(key, name)
            print(codepage)
        except WindowsError:
            print("Failed to get code page")
