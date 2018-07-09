# -*- coding=utf-8 -*-

import os, re
import xlwt
import xlrd
import csv

""" 删除非中文字符 """
def is_ustr(in_str):
    out_str=''
    for i in range(len(in_str)):
        if is_uchar(in_str[i]):
            out_str=out_str+in_str[i]
        else:
            out_str=out_str+''
    return out_str

""" 判断是否是中文 """
def is_uchar(uchar):
    if uchar >= u'\u4e00' and uchar <= u'\u9fa5':
        return True
    else:
        return False

""" 遍历所有文件 """
def searchAllFile(path):
    dirlist = os.listdir(path)
    for file in dirlist:
        abspath = os.path.join(path, file)
        if os.path.isfile(abspath):
            a = ['.h','.m','.mm']
            file_ext = os.path.splitext(abspath)[1]
            if file_ext in a:
                start_find_zh(abspath)
            else:
                pass
        elif os.path.isabs(abspath):
            searchAllFile(abspath)
        else:
            pass

""" 对指定路径下的所有文件，进行相应的操作 """
def ergodicAllFileAndDoneAction(func, path):
    dirlist = os.listdir(path)
    for file in dirlist:
        abspath = os.path.join(path, file)
        if os.path.isfile(abspath):
            a = ['.h', '.m', '.mm']
            file_ext = os.path.splitext(abspath)[1]
            if file_ext in a:
                func(abspath)
            else:
                pass
        elif os.path.isabs(abspath):
            ergodicAllFileAndDoneAction(func, abspath)
        else:
            pass

""" 正则中文并写入txt """
def start_find_zh(path):
    find_count = 0
    with open(path,'rb') as infile:
        while True:
            content = infile.readline()
            strList = re.match(ur'(.*@\".*[\u4E00-\u9FA5]+.*\")',content.decode('utf-8'))
            if strList:
                maStr = strList.group(0)
                print(maStr.encode("utf-8","ignore"))
                pathList = path.split("/")
                type_name =  pathList[9] if len(pathList) > 9 else "lifeTouch"
                sMaStr = maStr.split('@')
                for iterm in sMaStr:
                    print(is_ustr(iterm))
                    f = open(txtFile, 'a')
                    res = is_ustr(iterm).strip("\n")
                    if len(res) > 0:
                        f.write("\n" + res.encode('utf-8', 'ignore') + " " + type_name)
                    f.close()
            if not content:
                return find_count

excelPath = "xxx.csv"

txtFile = "xxx.txt"

# searchAllFile('xxxPath')

""" txt转cvs """
def readTxtAndWriteToExcel():
    fopen = open(txtFile, 'r')
    lines = fopen.readlines()

    # file = xlwt.Workbook()
    # sheet = file.add_sheet('iData')
    # i = 0
    # for line in lines:
    #     sheet.write(i,0,line)
    #     i=i+1
    # file.save(excelPath)
    f = open(excelPath,'w')
    writer = csv.writer(f)
    for line in lines:
        writer.writerow(line)
    f.close()

# readTxtAndWriteToExcel()