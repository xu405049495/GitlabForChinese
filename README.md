##关于
Git是一个非常好的东西 , 也是目前为止地球上最好的版本管理工具 . 但有些时候 , 我们更愿意我们能完全控制着代码 , 例如天朝公司所谓的'代码安全' , 于是乎我们使用了Gitlab . 但是Gitlab的全英文操作对于我们这些母语是中文的天朝程序猿/程序媛来说 , 操作起来确实有一点点的困难 . 于是 , 我利用业余时间 , 整理和汉化了Gitlab . 对于汉化 , 因为时间原因 , 我将对每一个大版本提供汉化 , 如果小版本修复了致命Bug也将跟进 .  对于汉化的质量 , 肯定也包含一些不足的地方 , 如果你有更好的建议与意见 , 欢迎联系我或提Issues . 
by: 黄涛<htve$outlook.com>

##CentOS 7 最小安装后操作
1. 设置时区  
  `timedatectl set-timezone Asia/Shanghai`
2. 添加 Gitlab 清华源
   1. `vi /etc/yum.repos.d/gitlab-ce.repo`
   2.     [gitlab-ce]  
    name=gitlab-ce  
    baseurl=http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7  
    repo_gpgcheck=0  
    gpgcheck=0  
    enabled=1  
    gpgkey=https://packages.gitlab.com/gpg.key
3. 添加 yum 163源并更新CentOS  
    yum -y install wget  
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup  
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo  
    yum clean all  
    yum makecache  
    yum -y update  
4. 删除系统默认Git , 并装Git与其它依赖组件
    sudo yum -y remove git  
    sudo yum -y install gcc zlib-devel perl-CPAN gettext curl-devel expat-devel openssl-devel patch  
    cd /tmp  
    curl --progress https://www.kernel.org/pub/software/scm/git/git-2.10.2.tar.gz | tar xz  
    cd git-2.10.2/  
    ./configure  
    sudo make  
    sudo make prefix=/usr/local install  
5. 安装GItlab
   1. 安装最新Gitlab  
      sudo yum install gitlab-ce
   2. 安装指定版本
    cd /opt  
    curl -LJO https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.14.0-ce.0.el7.x86_64.rpm  
    rpm -i gitlab-ce-8.14.0-ce.0.el7.x86_64.rpm  
6. 编辑gitlab.rb文件  
  1. `vi /etc/gitlab/gitlab.rb`
  2. 将`external_url 'http://localhost'`改成将`external_url 'http://你服务器的ip'`
7. 将下载后的`v8.14.0.zh1.diff`拷贝到`/opt`
8. 执行汉化与配置
    sudo patch -d /opt/gitlab/embedded/service/gitlab-rails -p1 < v8.14.0.zh1.diff  
    sudo gitlab-ctl reconfigure  
    sudo NO_PRIVILEGE_DROP=true USE_DB=false gitlab-rake assets:precompile  
    sudo gitlab-ctl reconfigure  
    sudo gitlab-ctl restart  
    sudo gitlab-ctl restart  
9. 开启防火墙  
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    firewall-cmd --zone=public --add-port=443/tcp --permanent
    firewall-cmd --reload
    systemctl restart firewalld.service