---
layout: article
title: "南昌大学企业微信打卡[已失效]"
tag: NCU
---

# 声明

1. 该方法目前稳定性尚不确定，`Token`有概率会不定时失效，如果使用后果自负
2. 该方法仅作`Python`学习使用，了解原理后使用后果自负
3. 疫情期间请以实际情况打卡汇报，切勿身体有状况而依旧以无状况打卡。

# 参考文章

1. [云函数实现南昌大学疫情打卡自动化_Hobin88的博客-CSDN博客](https://blog.csdn.net/Hobin88/article/details/114375620)
2. [简单三步，用 Python 发邮件 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/24180606?theme=dark)

# 实现的效果

​	将脚本挂载在服务器上，每天凌晨十二点半自动运行脚本，并且发送一条邮件到自己的QQ邮箱内返回打卡成功情况，如果QQ邮箱返回的为“请重新登入”，只需要重新在企业微信中导出Token即可。

# 运行环境

服务器版本：Ubuntu 20.04 + 宝塔面板

Python版本：3.9.5

# 需要准备的东西

1. 一台能定时运行脚本的设备（e.g. 服务器)
2. 一个能用SMTP登入并且发信的邮箱（也可以使用类似Server酱的消息推送平台，这里用QQ邮箱做示范）

# 获取Token

1. 在打卡界面中"复制链接"，并在电脑上打开

   ![企业微信](/2021/04/images/ClockIn_1.png)

2. 电脑浏览器打开链接，按F12，此时可能是电子ID，不用管，在右上角找到`Network`，并打开。

   (如果提示要按Ctrl+R，按就行)

   ![Network](/2021/04/images/ClockIn_2.png)

3. 在`Network`下方找到`loginByToken`，并且找到右边的`Token`信息，复制保存。

   ![TokenGet](/2021/04/images/ClockIn_3.png)

# 获取QQ邮箱的SMTP信息

1. 登入QQ邮箱，并点击左上角的“ 设置”

   ![Config](/2021/04/images/ClockIn_4.png)

2. 根据提示开启SMTP，并且保存并记录授权码。

   ![SMTP Pwd](/2021/04/images/ClockIn_5.png)

# 编辑脚本

1. 创建一个`ClockIn.py`的脚本文件，并且按注释编辑以下脚本

   ```python
   # encoding=utf-8
   import requests
   import smtplib
   import re
   from email.mime.text import MIMEText
   
   date = {
       'addressCity': "南昌市",
       'addressInfo': "江西省南昌市",
       'addressProvince': "江西省",
       'closeHb': "否",
       'closeIll': "否",
       'healthDetail': "无异常",
       'healthStatus': "无异常",
       'inChina': "是",
       'isGraduate': "否",
       'isIll': "否",
       'isIsolate': "否",
       'isIsolation': "否",
       'isolatePlace': "无",
       'isolationPlace': "无",
       'temperature': 0,
       'temperatureStatus': "正常",
       'userId': "**********"  # 填入你的学号
   }
   headers = {
       'Host': 'jc.ncu.edu.cn',
       'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1 Edg/90.0.4430.93',
       'token': '******************',  # token填入获取的token
   }
   
   url = 'http://jc.ncu.edu.cn/gate/student/signIn'
   req = requests.post(url, headers=headers, data=date)
   # 打卡完毕
   
   
   ans = re.sub(u"([^\u4e00-\u9fa5])", "", req.text)
   
   # 设置邮件服务器信息
   qq = 'xxxxxxxxx'  # xxxxxxxxx换成QQ号
   mail_host = 'smtp.qq.com'
   mail_user = qq + '@qq.com'
   mail_pass = '********'  # SMTP授权码
   sender = qq + '@qq.com'
   receivers = [qq + '@qq.com']
   
   message = MIMEText(ans, 'plain', 'utf-8')
   message['Subject'] = '打卡通知'
   message['From'] = "Clock In<" + sender + ">"
   message['To'] = "Clock In<" + receivers[0] + ">"
   
   try:
       smtpObj = smtplib.SMTP_SSL(mail_host)
       smtpObj.login(mail_user, mail_pass)
       smtpObj.sendmail(sender, receivers, message.as_string())
       smtpObj.quit()
       print('success')
   except smtplib.SMTPException as e:
       print('error', e)
   ```

# 运行脚本并测试

* 在`Ubuntu`下安装了`python3`以后，输入指令。

  ```shell
  python3 /path/to/ClockIn.py # /path/to/改成自己实际的目录
  ```

  如果返回了`success`，并且QQ邮箱收到了“打卡成功”的邮件，则设置完毕，接下来只需要设置服务器定时执行Shell指令即可。

* 在Windows下测试

  1. 安装`Python`运行环境

  2. 在`PowerShell`或者类似工具中安装`requests`拓展包

     ```shell
     pip install requests
     ```

  3. 在`ClockIn.py`的目录下运行脚本

     ```shell
     py ClockIn.py
     ```

