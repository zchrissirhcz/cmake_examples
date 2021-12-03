# Doxygen document coverage example

Straight-forward document coverage generation.

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