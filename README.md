# SSLGUALA

后台地址 [https://sslguala.ce04.com](https://sslguala.ce04.com)
前台地址 [https://sslguala.com](https://sslguala.com)

供用户使用的 API 说明

使用说明
需要在使用API时,需要在参数中带入 `api_token`, `api_token` 可在网页中申请. 返回均为 json

## 域名列表
url https://www.sslguala.com/api/v1/api_tokens/check_domains.json

action GET

description 获取域名列表

params

response
- name | description | type | remark
- id       域名ID integer
- domain  域名  string
- project_id  分组ID  integer
- expire_at 域名ssl过期时间  datetime
- created_at 域名创建时间  datetime
- check_expire_time_at  最后一次检测的时间 datetime
- remain_days ssl过期预留的天数 integer
- msg_channels  关联的通知渠道   Array

## 分类列表
url https://www.sslguala.com/api/v1/api_tokens/projects.json

action GET

description 获取分类列表

params

response
- name | description | type | remark
- id 分类的ID  integer
- name 分类名称 string
- description 分类描述 string
- check_domains_count 关联的域名数量 integer

## 通知渠道列表
url https://www.sslguala.com/api/v1/api_tokens/msg_channels.json

action GET

description 获取通知渠道列表

params

response
- name | description | type | remark
- id 渠道ID     string
- title  渠道名称     string
- url  渠道的链接地址     string
- config_email  邮箱地址    string  只有邮箱类型时才有此值
- type  类型    string
- markup   备注   string
- is_common  是否常用渠道     string
- config_secret  渠道的secret      string
- config_custom_string  渠道的其他配置    string 可忽略

## 创建域名
url https://www.sslguala.com/api/v1/api_tokens/create_domain.json

action POST

description 创建域名

params
name  description type  required remaker
- domain  域名  string   true   域名（如 zhihu.com https://zhihu.com 会自动裁剪）
- project_id 归属分类的ID integer false  可从分类列表中获取
-  channel_id 归属渠道的ID  integer false  可从渠道列表中获取
- markup   备注   string     false

response
- name | description | type | remark
- id       域名ID integer
- domain  域名  string
- project_id  分组ID  integer
- expire_at 域名ssl过期时间  datetime
- created_at 域名创建时间  datetime
- check_expire_time_at  最后一次检测的时间 datetime
- remain_days ssl过期预留的天数 integer
- msg_channels  关联的通知渠道   Array