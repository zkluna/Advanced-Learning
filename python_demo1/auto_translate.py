# -*- coding=utf-8 -*-

""" 通过调用有道翻译的API,实现中译英 """

import urllib
import urllib2
import json
import time
import hashlib
import re

class YouDaoFanyi:
    def __init__(self):
        self.url = 'https://openapi.youdao.com/api/'
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.109 Safari/537.36",
        }
        self.appKey = "你的有道账号的Key"
        self.appSecret = "你的有道账号的Secret"
        self.langFrom = 'auto'
        self.langTo = 'EN'

    def getUrlEncodedData(self, queryText):
        salt = str(int(round(time.time() * 1000)))
        sign_str = self.appKey + queryText + salt + self.appSecret
        sign = hashlib.md5(sign_str).hexdigest()
        payload= {
            'q': queryText,
            'from': self.langFrom,
            'to': self.langTo,
            'appKey': self.appKey,
            'salt': salt,
            'sign': sign
        }
        data = urllib.urlencode(payload)
        return data

    def parseHtml(self, html, queryText):
        data = json.loads(html)
        translationResult = data['translation']
        if isinstance(translationResult, list):
            translationResult = translationResult[0]
        self.writeStrToFile(translationResult, queryText)

    def translate(self, queryText):
        data = self.getUrlEncodedData(queryText)
        target_url = self.url + '?' + data
        request = urllib2.Request(target_url, headers=self.headers)
        response = urllib2.urlopen(request)
        self.parseHtml(response.read(), queryText)

    def writeStrToFile(self, en_str, zh_str):
        file = open('/Users/zk/Desktop/oTip/estate_zh.txt','a')
        re_str = "[+\.\!\/_,$%^*(+\"\']+|[+——！：:，。？、~@#￥%……&*（）]+"
        en_str = re.sub(re_str.decode("utf8"), "".decode("utf8"),en_str.decode("utf-8", "ignore"))
        en_str = en_str.strip().replace(' ', '_')
        new_str = '"'+ en_str +'" = "' + zh_str.strip('\n').decode("utf-8") + '";'
        print new_str
        file.writelines("\n"+new_str.encode("utf-8","ignore"))
        file.close()


# def write_zh_asKeyValues(zh_str):
#     file = open(outFile, 'a')
#     zh_str = zh_str.strip('\n').decode("utf-8")
#     new_str = zh_str+';'
#     print(new_str)
#     file.writelines("\n"+new_str.encode("utf-8","ignore"))
#     file.close()

if __name__  == "__main__":
    translate = YouDaoFanyi()
    file = open('xxx.txt','r')
    all_lines = file.readlines()
    # i = 0
    for line in all_lines:
        # i += 1
        line = line.strip()
        if len(line):
            res = translate.translate(line)
        # if i == 5:
        #     break
    file.close()

outFile = "xxx.txt"
# inFile = "/Users/zk/Desktop/oTip/estate.txt"
#
# file = open(inFile,'r')
# all_lines = file.readlines()
# for line in all_lines:
#     write_zh_asKeyValues(line)
# file.close()
