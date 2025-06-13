FROM mysql:8.0

# 环境变量配置（避免行尾注释干扰）
ENV MYSQL_ROOT_PASSWORD=your_root_password \
    MYSQL_DATABASE=default_db \
    MYSQL_USER=app_user \
    MYSQL_PASSWORD=app_password

# 权限修复与字符集配置（其他部分保持不变）
RUN usermod -u 1000 mysql && \
    mkdir -p /var/run/mysqld && \
    chmod -R 777 /var/run/mysqld

RUN echo "character-set-server=utf8mb4" >> /etc/mysql/conf.d/charset.cnf && \
    echo "collation-server=utf8mb4_unicode_ci" >> /etc/mysql/conf.d/charset.cnf

COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 3306