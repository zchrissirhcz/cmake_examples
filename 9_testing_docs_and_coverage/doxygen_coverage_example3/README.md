# Doxygen document coverage example3

Straight-forward document coverage generation.

Show each function's corresponding header file by set `SHOW_GROUPED_MEMB_INC = YES` in Doxyfile, and in C/C++ header file `defgroup` and `addtogroup`.

Set `STRIP_FROM_PATH = @CMAKE_SOURCE_DIR@/src` in Doxyfile.in to strip prefix in header includings.

## Prepare
```bash
sudo apt install lcov
```

```bash
pip install -r requirements.txt
```

Remember to ensure `GENERATE_XML = YES` in Doxyfile. Generated xml files are required by coverxygen.

## Usage
```bash
cd build
./linux-x64.sh  # compile, generating the document via integrated doxygen
./docs_coverage.sh # generate document coverage report

# view report in html
cd doc_coverage_report 
python -m http.server 7088 
```

## References
https://github.com/psycofdj/coverxygen