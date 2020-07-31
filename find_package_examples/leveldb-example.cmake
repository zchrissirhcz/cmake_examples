set(LevelDB_DIR "D:/lib/leveldb/willyd/x64/vc12/CMake")

find_package(LevelDB REQUIRED)

if (LevelDB_FOUND)
    message(STATUS "----- LevelDB found")
endif()

