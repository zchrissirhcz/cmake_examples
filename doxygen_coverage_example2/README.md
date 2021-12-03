# Doxygen document coverage example2

Straight-forward document coverage generation, with fully integration in CMake.

## Prepare
```bash
sudo apt install lcov
```

```bash
pip install -r requirements.txt
```

Remember to ensure `GENERATE_XML = YES` in Doxyfile. Generated xml files are required by coverxygen.

## Usage
Simply do:
```bash
cd build
./linux-x64.sh
```

Or:
```bash
mkdir -p build
cd build
cmake ../.. -GNinja -DCMAKE_BUILD_TYPE=Release
cmake --build . --target doc  # generate doc
cmake --build . --target doc_coverage # generate doc coverage report

# view report in html
cd doc_coverage_report 
python -m http.server 7088 
```

## References
https://github.com/psycofdj/coverxygen