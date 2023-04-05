# use find_package() here...
if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(WARNING "ARTIFACTS_DIR env var not defined")
endif()

set(Ceres_DIR "${ARTIFACTS_DIR}/ceres/2.1.0/linux-x64/lib/cmake/Ceres")
find_package(Ceres REQUIRED)
