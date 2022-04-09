---
layout: article
title: "OSTEP-比例份额调度"
date: 2022-04-09
categories: 知识记录
tags: os
---

## 第八章：调度：比例份额

在CPU资源进行调度的时候，有的时候我们很难让每个程序都尽量公平的分配到资源。“彩票调度`(lottery scheduling)`”通过给不同的任务分配不同的彩票数，再通过随机数和期望分布来对资源进行调度，实现一个类似于平均分配的调度方法

本章中文译本内缺少对`Linux`系统的`CFS`调度的说明，不过不影响课后练习

1. 完成随机种子1、2和3对应的习题计算
   > 该题目的主要思路即判断随机数取模后的数字和`tickets`的数量比较，然后依次逐步执行判断即可

2. 当彩票分布设计的十分极端的情况下，由于第一个`Job0 10:1`获得的票数太少，几乎不可能在`Job1 10:100`前完成任务，将会在结果上滞后`Job0`的完成

3. 通过设立不同的`seed`，可以得到不同的情况如下

   ```sh
   $ ./lottery.py -l 100:100,100:100 -s 1 -c
   ...
   --> JOB 1 DONE at time 196
   ...
   --> JOB 0 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -s 2 -c
   ...
   --> JOB 1 DONE at time 190
   ...
   --> JOB 0 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -s 3 -c
   ...
   --> JOB 0 DONE at time 196
   ...
   --> JOB 1 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -s 4 -c
   ...
   --> JOB 1 DONE at time 199
   ...
   --> JOB 0 DONE at time 200
   ```

   可以大致看出在任务的长度足够大的情况下，调度分布基本公平，最后的结果趋紧于类似RR切换任务的平均期望

4. 在修改了`quantum`大小之后，由于时间片变大，相当于任务本身的长度缩短，整个任务的公平性会偏向不稳定和不公平，大致结果如下

   ```sh
   $ ./lottery.py -l 100:100,100:100 -q 20 -c -s 1
   ...
   --> JOB 0 DONE at time 180
   ...
   --> JOB 1 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -q 20 -c -s 2
   ...
   --> JOB 1 DONE at time 180
   ...
   --> JOB 0 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -q 20 -c -s 3
   ...
   --> JOB 1 DONE at time 120
   ...
   --> JOB 0 DONE at time 200

   $ ./lottery.py -l 100:100,100:100 -q 20 -c -s 4
   ...
   --> JOB 1 DONE at time 140
   ...
   --> JOB 0 DONE at time 200
   ```

5. 这题主要用来当Python练习了，模拟生成图像的代码如下（和`lottery.py`实验代码放于同一目录下）

   ```python
   import os
   import re
   import matplotlib.pyplot as plt
   import numpy as np

   # 执行彩票概率检查，返回概率结果

   def countLottery(length, seed):
      r = os.popen(
         "./lottery.py -l " + length + ":100," + length + ":100 -c" + " -s " + seed)
      text = r.read()
      r.close()
      lottery_time = re.findall(r"^--> .*(\d*)", text, re.M)
      return int(lottery_time[0])/int(lottery_time[1])

   def average(length):
      sum = 0
      # 调整重复
      time = 20
      for i in range(1, time):
         sum += countLottery(length, str(i))
      return sum / (time - 1)

   length = []
   chance = []

   # 设定工作长度和间隔

   length_start = 1
   length_end = 100
   step = 5
   for i in np.arange(length_start, length_end, step):
      length.append(i)
      chance.append(average(str(int(i))))

   plt.ylabel("Fairness")
   plt.xlabel("Job Length")

   plt.plot(length, chance, 'b-')

   plt.savefig("./lottery.png")
   ```

   最后生成的图片效果

   ![模拟图像](https://lsky.halc.top/ewA3BX.png)