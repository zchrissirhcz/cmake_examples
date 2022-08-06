#-------------------------------------------------------------
# gen_sleek_doc.py
# 从 sleek.cmake 提取出 API 文档
#-------------------------------------------------------------

def parse_sleek_API_docs():
    fin = open('sleek.cmake')
    bucket = []
    docs = []
    for line in fin.readlines():
        line = line.rstrip()
        if (len(line) == 0):
            bucket = []
            continue
        if (line[0] == '#'): 
            bucket.append(line)
        elif (line.startswith('macro') or line.startswith('function')):
            bucket.append(line)
            for item in bucket:
                docs.append(item)
            bucket = []
            docs.append('')
    fin.close()

    return docs

if __name__ == '__main__':
    docs = parse_sleek_API_docs()
    for item in docs:
        print(item)