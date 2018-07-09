# -*- coding=utf-8 -*-

import sys
import os
import re
from zhtools.langconv import *
import chardet


""" 替换文件中的字符 """
def replace(file_path, old_str, new_str):
    print(file_path.split('/')[-1]+' | '+old_str+' | '+new_str)
    old_str = old_str.encode('utf-8','ignore')
    new_str = new_str.encode('utf-8','ignore')
    try:
        f = open(file_path,'r+')
        all_lines = f.readlines()
        f.seek(0)
        f.truncate()
        for line in all_lines:
            line = line.replace(old_str, new_str)
            f.write(line)
        f.close()
    except Exception, e:
        print(e)

# if __name__ == "__main__":
#     if len(sys.argv) < 4:
#         print("we need 3 params")
#         sys.exit(1)
#     file_name, src_str, des_str = sys.argv[1], sys.argv[2], sys.argv[3]
#     replace(file_name, src_str, des_str)

""" 对指定路径下的所有文件，进行相应的操作 """
def ergodicAllFileAndDoneAction(func, path):
    dirlist = os.listdir(path)
    for file in dirlist:
        abspath = os.path.join(path, file)
        if os.path.isfile(abspath):
            # a = ['.h', '.m', '.mm']
            # file_ext = os.path.splitext(abspath)[1]
            # if file_ext in a:
            #     print(abspath.split("/")[-1])
            #     func(abspath)
            # else:
            #     pass
            print(abspath.split('/')[-1])
            func(abspath)
        elif os.path.isabs(abspath):
            ergodicAllFileAndDoneAction(func, abspath)
        else:
            pass

""" 删除文件中的空行 """
def deleteBlankLine(infile, outfile):
    infp = open(infile, "r")
    outfp = open(outfile, "w")
    lines = infp.readlines()
    for line in lines:
        if line.split():
            print(line)
            outfp.writelines(line)
    infp.close()
    outfp.close()

""" 删除文件中重复的行 """
def deleteSameLine(infile, outfile):
    lines_seen = set()
    outfp = open(outfile, 'w')
    infp = open(infile, 'r')
    for line in infp.readlines():
        if line not in lines_seen:
            print(line)
            outfp.writelines(line)
            lines_seen.add(line)
    infp.close()
    outfp.close()

""" 删除字符串中的标点符号 """
def deletePuctuation(resStr):
    # str = re.sub("[+\.\!\/_,$%^*(+\"\']+|[+——！：:，。？、~@#￥%……&*（）]+".decode("utf8"), "".decode("utf8"),resStr.decode("utf-8","ignore"))
    str = re.sub("[\"]+".decode("utf8"), "".decode("utf8"),
                 resStr.decode("utf-8", "ignore"))
    return str

""" 处理字符串 """
def checkStrInFile(filePath):
    templateFile = open('/Users/zk/Desktop/oTip/estate_zh.txt', 'r')
    all_lines = templateFile.readlines()
    for line in all_lines:
        lineList = line.split('=')
        # zh_str = '@'+lineList[1].strip().strip('\n')
        # key_str = '@'+lineList[0].strip().strip('\n')
        zh_str = lineList[1].strip('\n').strip(';').strip('"').strip()
        zh_str = deletePuctuation(zh_str)
        key_str = lineList[0].strip().strip('\n').strip('"')
        # new_str = 'LocalizbleStr('+key_str+')'
        # replace(filePath, zh_str, new_str)
        replace(filePath, zh_str, key_str)

""" 繁体转简体 """
def hant_to_chs(line):
    line = Converter('zh-hans').convert(line.decode('utf-8'))
    line.encode('utf-8')
    return line

""" 简体转繁体 """
def chs_to_hant(line):
	line = Converter('zh-hant').convert(line.decode('utf-8','ignore'))
	line.encode('utf-8','ignore')
	return line

""" 获取文件的编码方式 """
def get_encoding(file):
    with open(file, 'rb') as f:
        return chardet.detect(f.read())

def checkFileIsEmpty(file):
    fp = open(file, 'r')
    lines = fp.readlines()
    isEmpty = 0
    for line in lines:
        if len(line.strip()) != 0:
            isEmpty = 1
            break
    if isEmpty == 1:
        outputfile = xib_name_path
        file_name = file.split('/')[-1].split('.')[0]+'\n'
        print(file_name)
        op = open(outputfile, 'a')
        op.write(file_name)
        op.close()



# project_path = "/Users/zk/Desktop/oTip/Resource"
# zh_str_path= "/Users/zk/Desktop/oTip/estate_zh.txt"
# ergodicAllFileAndDoneAction(checkStrInFile, project_path)

# xib_name_path = "/Users/zk/Desktop/oTip/xib_name.txt"

# zh_Hans_path = "/Users/zk/Desktop/work/accentrix/trunk/LifeTouch_Trunk/LifeTouch/zh-Hans.lproj"
# ergodicAllFileAndDoneAction(checkFileIsEmpty, zh_Hans_path)

zh_str_path = 'xxx.strings'

fp = open(zh_str_path, 'r+')
all_lines = fp.readlines()
fp.seek(0)
fp.truncate()
for line in all_lines:
    if len(line.strip('\n').strip()) == 0:
        continue
    line = line.decode("utf-8")
    zh_str = line.split("=")[1].strip()[1:-2]
    hans_str = chs_to_hant(zh_str.encode("utf-8"))
    new_line = line.replace(zh_str, hans_str)
    print(new_line)
    fp.write(new_line.encode("utf-8"))
fp.close()
