---
title: 爬取 TapTap 网站上的游戏排行榜信息
date: 2020-09-08T13:35:28+08:00
tags:
  - spider
  - Python
categories: Programming
---

> 爬虫小项目代码存档


```python
import requests
import time
from lxml import etree
import json
import pickle

class Tapspider:
    def __init__(self):
            self.responses = list()
            self.datas = list()

            self.get_page()
            self.get_game_info()
            self.save_data(self.datas, 'DownloadList')

    def get_datas(self, code):
        base_url = 'http://www.taptap.com/app/'
        url = base_url+code
        html = self.get_game_page(url)
        result = etree.HTML(html)
        test = -1
        free = -1

        installs = -1
        pre_reg = -1
        purchases = -1

        game_info = result.xpath("//div[@class='app-data-wrap']/p/span/text()")
        # print(node)
        # print(type(node))
        print(len(game_info))
        if len(game_info) == 1:
            test = 1
            installs = -1
            pre_reg = -1
            purchases = -1
            followers = str(game_info[0]).replace(' 人关注','')
        else:
            print(game_info[0])
            print(type(game_info[0]))

            if '购买' in str(game_info[0]):
                purchases = str(game_info[0]).replace(' 人购买', '')
            elif '安装' in str(game_info[0]):
                installs = str(game_info[0]).replace(' 人安装', '')
                free = 1
            elif '预约' in str(game_info[0]):
                pre_reg = str(game_info[0]).replace(' 人预约', '')
            followers = str(game_info[1]).replace(' 人关注','')
        return test, free, installs, pre_reg, purchases ,followers

    def get_game_info(self):
        for response in self.responses:
            html = json.loads(response)['data']['html']
            results = etree.HTML(html)
            game_list = results.xpath(
                "//div[@class='taptap-top-card']")
            print(len(game_list))
            response_num = self.responses.index(response)
            for game in game_list:
                game_num = game_list.index(game)
                print('正在获取第%d个游戏的信息' % (response_num*30+game_num+1))
                order = str(game.xpath(
                    "./span[@class ='top-card-order-text orange ']/text() | ./span[@class = 'top-card-order-text  ']/text() | ./span[@class='top-card-order-text  small-font']/text()")[0])
                name = str(game.xpath(
                    "./div[@class='top-card-middle']/a[@class='card-middle-title ']/h4/text()")[0]).strip().strip('\n')
                developer = str(game.xpath(
                    "./div[@class='top-card-middle']/p[@class='card-middle-author']/a/text()")[0]).strip('厂商:\xa0')
                score = str(game.xpath(
                    "./div[@class='top-card-middle']/div[@class='card-middle-score']/p/span/text()")[0])
                description = str(game.xpath(
                    "./div[@class='top-card-middle']/p[@class='card-middle-description']/text()")[0]).strip().strip('\n')
                tags = game.xpath(
                    "./div[@class='top-card-middle']/div[@class='card-tags']/a/text()")
                for i in range(len(tags)):
                    tags[i] = str(tags[i])
                category = str(game.xpath(
                    "./div[@class='top-card-middle']/div[@class='card-middle-category']/a/text()")[0])
                game_code = str(game.xpath(
                    "./div[@class='top-card-middle']/a[@class='card-middle-title ']/@href")[0]).replace('https://www.taptap.com/app/', '')

                test, free, installs, pre_reg, purchases ,followers = self.get_datas(game_code)

                data = {
                    'order': order,
                    'code': game_code,
                    'name': name,
                    'developer': developer,
                    'score': score,
                    'description': description,
                    'tags': tags,
                    'category': category,
                    'free': free,
                    'test': test,
                    'followers': followers,
                    'installs': installs,
                    'purchases': purchases,
                    'pre_reg': pre_reg
                }
                print(data)
                self.datas.append(data)
        print('共有%d个游戏' % len(self.datas))

    def get_page(self):
        base_url = "http://www.taptap.com/ajax/top/download?"
        # 1:30, 2:30, 3:90
        for i in range(5):
            page = str(i+1)
            total = str((i)*30)
            params = {
                'page': page,
                'total': total
            }
            headers = {
                'Usr-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36'}
            response = requests.get(
                base_url, params=params, headers=headers)
            print('正在获取页面内容...')

            print('Page:', response.url, '\tstatus code:',
                  response.status_code, '\tlength:', len(response.text))
            self.responses.append(response.text)
        print('-------------------------------------------------')

    def get_game_page(self, url):
        headers = {
            'Usr-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36'}
        response = requests.get(
            url,  headers=headers)
        return response.text

    def save_data(self,datas, list_type):
        date = time.strftime("%Y-%m-%d", time.localtime())
        filename = list_type +date +'.pkl'
        with open('./'+filename,'wb') as f:
            pickle.dump(datas,f)


if __name__ == '__main__':
    start = time.time()
    spider = Tapspider()
    end = time.time()
    print('用时：', end-start)

```
