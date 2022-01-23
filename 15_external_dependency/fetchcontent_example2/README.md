# fetch content example2

## 切换git repo为镜像

```cmake
if(DEP_USE_GITEE)
    set(googletest_repo https://gitee.com/mirrors/googletest.git)
else()
    set(googletest_repo https://github.com/google/googletest.git)
endif()


FetchContent_Declare(googletest
    GIT_REPOSITORY ${googletest_repo}
    GIT_TAG release-1.11.0
    SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/googletest
    BINARY_DIR ${FETCHCONTENT_BASE_DIR}/googletest-build
    SUBBUILD_DIR ${FETCHCONTENT_BASE_DIR}/googletest-subbuild
)
```

![](cmake_fetchcontent_gitclone_commands.png)


## See also
https://github.com/openppl-public/ppl.cv/pull/55