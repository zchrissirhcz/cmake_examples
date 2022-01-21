cmake_minimum_required(VERSION 3.8)

project(MyWinFormApp LANGUAGES CSharp)

# Include CMake utilities for CSharp, for WinForm and WPF application support.
include(CSharpUtilities)

# Define the executable, including any .cs files. 
# The .resx and other Properties files are optional here, but including them makes them visible in the VS solution for easy editing. 
add_executable(MyWinFormApp
    App.config
    Form1.cs
    Form1.Designer.cs
    Program.cs
    Properties/AssemblyInfo.cs
    Properties/Resources.Designer.cs
    Properties/Resources.resx
    Properties/Settings.Designer.cs
    Properties/Settings.settings
)

# Set the .NET Framework version for the executable.
set_property(TARGET MyWinFormApp PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.6.1")
# Set the executable to be 32-bit.
set_property(TARGET MyWinFormApp PROPERTY WIN32_EXECUTABLE TRUE)
# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

# Set the source file properties for Windows Forms use.
csharp_set_windows_forms_properties(
    Form1.cs
    Form1.Designer.cs
    Program.cs
    Properties/AssemblyInfo.cs
    Properties/Resources.Designer.cs
    Properties/Resources.resx
    Properties/Settings.Designer.cs
    Properties/Settings.settings
)

# If necessary, link in other library dependencies that were built locally in this source tree.
#target_link_libraries(MyWinFormApp MyLocalLib)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
#set_property(TARGET MyWinFormApp PROPERTY 
#    VS_DOTNET_REFERENCE_MyThirdPartyLib /path/to/libs/MyThirdPartyLib.dll)

# Add in the .NET reference libraries.
set_property(TARGET MyWinFormApp PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)