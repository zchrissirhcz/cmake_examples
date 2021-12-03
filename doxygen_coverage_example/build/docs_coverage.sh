#!/bin/bash
# DOXYGEN=/home/zz/soft/doxygen-1.9.2-fix/bin/doxygen
# $DOXYGEN Doxyfile.in
#rm doc-coverage.info

doc_coverage_db="doc-coverage.info"

if [ -f "$doc_coverage_db" ] ; then
    rm "$doc_coverage_db"
fi

python -m coverxygen --xml-dir linux-x64/xml --src-dir ../src --output $doc_coverage_db --kind function --verbose

lcov -r $doc_coverage_db '*/linux-x64/*' -o $doc_coverage_db
lcov --summary $doc_coverage_db
genhtml --no-function-coverage --no-branch-coverage $doc_coverage_db -o doc_coverage_report
echo -e "\033[0;36mView doc coverage html report:\033[0m"
echo -e "    \033[0;36m cd doc_coverage_report \033[0m"
echo -e "    \033[0;36m python -m http.server 7088 \033[0m"