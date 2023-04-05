# auto download packages

CMake provide two builtin:
- `FetchContent`: download packages during cmake **configure** stage.
- `ExternalProject`: download packages during cmake **build** stage.

CPM.cmake encapsulates `FetchContent`.

OpenPPL's `hpcc.common` also encapsulates `FetchContent`.