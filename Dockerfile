# 设置基础镜像 
FROM nginx:alpine
# 定义作者
MAINTAINER lmkj-黄宏欣
# 将dist文件中的内容复制到 /etc/nginx/html/ 这个目录下面
COPY dist/  /etc/nginx/html/
# 将配置文件中的内容复制到 /etc/nginx 这个目录下面(增加自己的代理及一些配置)
RUN rm -rf /etc/nginx/nginx.conf 
COPY nginx.conf /etc/nginx/nginx.conf