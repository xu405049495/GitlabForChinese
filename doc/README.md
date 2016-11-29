# 文档

## 用户文档

- [帐户安全](user/account/security.md) 通过双因素身份验证等方式保护您的帐户安全。
- [API](api/README.md) 通过简单而强大的API自动化GitLab。
- [CI/CD](ci/README.md) GitLab持续集成（CI）和持续交付（CD）入门， `.gitlab-ci.yml` 选项和示例。
- [GitLab作为OAuth2身份验证服务提供程序](integration/oauth_provider.md)。它允许您从GitLab登录到其他应用程序。
- [容器注册表](user/project/container_registry.md) 了解如何使用GitLab容器注册表。
- [GitLab基础知识](gitlab-basics/README.md) 逐步找到如何开始在您的命令行和GitLab上工作。
- [导入到GitLab](workflow/importing/README.md)。
- [在实例之间导入和导出项目](user/project/settings/import_export.md)。
- [Markdown](user/markdown.md) GitLab的高级格式化系统。
- [从SVN迁移](workflow/importing/migrating_from_svn.md) 将SVN存储库转换为Git和GitLab。
- [权限](user/permissions.md) 了解项目中的每个角色（外部/客户/记者/开发人员/主/所有者）可以做什么。
- [个人资料设置](profile/README.md)
- [项目服务](project_services/project_services.md) 将项目与外部服务（如CI和聊天）集成。
- [公共访问](public_access/public_access.md) 了解如何允许公共和内部访问项目。
- [SSH](ssh/README.md) 设置您的ssh密钥并部署密钥以安全访问您的项目。
- [Web钩子](web_hooks/web_hooks.md) 让GitLab在新代码推送到您的项目时通知您。
- [工作流](workflow/README.md) 使用GitLab功能并从GitHub和SVN导入项目。
- [教程](university/README.md) 通过视频和课程学习Git和GitLab。
- [Git属性](user/project/git_attributes.md) 使用`.gitattributes` 文件管理Git属性。
- [Git教程](https://gitlab.com/gitlab-com/marketing/raw/master/design/print/git-cheatsheet/print-pdf/git-cheatsheet.pdf) 下载描述最常用的Git操作的PDF。

## 管理员文档

- [访问限制](user/admin_area/settings/visibility_and_access_controls.md#enabled-git-access-protocols) 定义哪些Git访问协议可用于与GitLab通信。
- [身份验证/授权](administration/auth/README.md) 使用LDAP，SAML，CAS和其他Omniauth提供程序配置外部身份验证。
- [自定义Git钩子](administration/custom_hooks.md) 当web钩子不够时，自定义Git钩子（在文件系统上）。
- [安装](install/README.md) 要求，目录结构和源安装。
- [重新启动GitLab](administration/restart_gitlab.md) 了解如何重新启动GitLab及其组件。
- [集成](integration/README.md) 如何与系统如JIRA，Redmine，Twitter集成。
- [问题关闭模式](administration/issue_closing_pattern.md) 自定义如何通过提交消息关闭问题。
- [Koding](administration/integration/koding.md) 设置Koding以与GitLab一起使用。
- [Libravatar](customization/libravatar.md) 对用户头像使用Libravatar而不是Gravatar。
- [日志系统](administration/logs.md) 日志系统。
- [环境变量](administration/environment_variables.md) 配置GitLab。
- [操作](administration/operations.md) 保持GitLab的运行。
- [Raketasks](raketasks/README.md) 备份，维护，自动Web钩子设置和项目导入。
- [存储库检查](administration/repository_checks.md) 定期Git存储库检查。
- [存储库存储](administration/repository_storages.md) 管理用于存储存储库的路径。
- [安全](security/README.md) 了解如何进一步保护GitLab实例。
- [系统钩子](system_hooks/system_hooks.md) 用户，项目和键更改时的通知。
- [更新](update/README.md) 更新指南以升级安装。
- [欢迎消息](customization/welcome_message.md) 向登录页面添加自定义欢迎消息。
- [回复电子邮件](administration/reply_by_email.md) 允许用户回复通知电子邮件，以便对问题和合并请求发表评论。
- [将GitLab CI迁移到CE / EE](migrate_ci_to_ce/README.md) 按照本指南将现有的GitLab CI数据迁移到GitLab CE / EE。
- [Git LFS配置](workflow/lfs/lfs_administration.md)
- [维护](administration/housekeeping.md) 保持你的Git存储库整洁和快速。
- [GitLab性能监控](administration/monitoring/performance/introduction.md) 配置GitLab和InfluxDB以测量性能指标。
- [请求分析](administration/monitoring/performance/request_profiling.md) 获取缓慢请求的详细配置文件。
- [监控正常运行时间](user/admin_area/monitoring/health_check.md) 使用运行状况检查端点检查服务器状态。
- [调试提示](administration/troubleshooting/debug.md) 在调试错误时进行问题提示。
- [Sidekiq故障排除](administration/troubleshooting/sidekiq.md) 当Sidekiq出现挂起并且未处理作业时调试。
- [高可用](administration/high_availability/README.md) 配置多个服务器以实现扩展或高可用性。
- [容器注册表](administration/container_registry.md) 使用GitLab配置Docker注册表。
- [多个存储库](administration/repository_storages.md) 定义多个存储库存储路径以分配存储负载。

## 贡献者文档

- [开发](development/README.md) 解释如何贡献代码的所有风格。
- [法律](legal/README.md) 贡献者许可协议。
