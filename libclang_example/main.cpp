#include <iostream>
#include <clang-c/Index.h>  // This is libclang.
using namespace std;

ostream& operator<<(ostream& stream, const CXString& str)
{
    stream << clang_getCString(str);
    clang_disposeString(str);
    return stream;
}

int main()
{
    CXIndex index = clang_createIndex(0, 0);
    const char* source_filename = "header.hpp";
    CXTranslationUnit unit = clang_parseTranslationUnit(
        index,
        source_filename, nullptr, 0,
        nullptr, 0,
        CXTranslationUnit_None);
    if (unit == nullptr)
    {
        cerr << "Unable to parse translation unit. Quitting." << endl;
        exit(-1);
    }

    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);

    CXCursor cursor = clang_getTranslationUnitCursor(unit);
    clang_visitChildren(
        cursor,
        [](CXCursor c, CXCursor parent, CXClientData client_data)
        {
            //cout << "Cursor kind: " << clang_getCursorKind(c) << endl;
            cout << "Cursor '" << clang_getCursorSpelling(c) << "' of kind '"
                << clang_getCursorKindSpelling(clang_getCursorKind(c)) << "'\n";
            return CXChildVisit_Recurse;
        },
        nullptr);

    return 0;
}