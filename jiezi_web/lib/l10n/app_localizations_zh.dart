// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '芥子云';

  @override
  String get adminConsoleTitle => '管理控制台';

  @override
  String get setupTitle => '芥子云初始化';

  @override
  String get setupSubtitle => '在开始使用前，请完成服务器配置';

  @override
  String get setupOnceNote => '此页面仅可访问一次，完成配置后将不再可用。';

  @override
  String get setupCompleteMessage => '初始化完成！正在跳转…';

  @override
  String get siteSettingsTitle => '站点设置';

  @override
  String get siteNameLabel => '站点名称';

  @override
  String get siteNameHint => '例如：芥子云';

  @override
  String get siteDescriptionLabel => '站点描述';

  @override
  String get siteDescriptionHint => '可选的站点标语';

  @override
  String get adminAccountTitle => '超级管理员账号';

  @override
  String get usernameLabel => '用户名';

  @override
  String get usernameHint => 'admin';

  @override
  String get usernameRequired => '用户名不能为空';

  @override
  String get usernameFormat => '3—50 个字符：字母、数字、_ 或 -';

  @override
  String get displayNameLabel => '显示名称';

  @override
  String get displayNameHint => '系统管理员';

  @override
  String get displayNameHelper => '在界面中显示，与登录用户名不同';

  @override
  String get displayNameTooltip =>
      '可选。在界面各处展示您身份时使用的名称，例如评论、文件操作记录等。留空则默认使用用户名。';

  @override
  String get usernameTooltip =>
      '这是您的登录凭据，用于登录系统。3–50 个字符。允许：英文字母（a-z、A-Z）、数字（0-9）、下划线（_）、连字符（-）。初始化完成后不可更改。';

  @override
  String get passwordTooltip => '至少 8 个字符。建议混合使用字母、数字和符号以提高安全性。';

  @override
  String get emailTooltip => '用于账号找回以及（开启时）邮箱验证，不会对外公开。';

  @override
  String get adminAccountNote => '您正在创建超级管理员账号。该账号拥有服务器的完整控制权，且不可删除。';

  @override
  String get emailLabel => '邮筱';

  @override
  String get emailHint => 'admin@example.com';

  @override
  String get emailRequired => '邮箱不能为空';

  @override
  String get emailInvalid => '请输入有效的邮箱地址';

  @override
  String get passwordLabel => '密码';

  @override
  String get passwordHint => '至少8个字符';

  @override
  String get passwordRequired => '密码不能为空';

  @override
  String get passwordTooShort => '密码长度不能少于8个字符';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get passwordMismatch => '两次输入的密码不一致';

  @override
  String get advancedOptionsTitle => '高级选项';

  @override
  String get maxUploadLabel => '最大上传大小（MB）';

  @override
  String get publicRegistrationLabel => '开放注册';

  @override
  String get publicRegistrationSubtitle => '允许访客自行创建账号';

  @override
  String get completeSetupButton => '完成初始化';

  @override
  String get usernameOrEmail => '用户名或邮箱';

  @override
  String get fieldRequired => '必填';

  @override
  String get signInButton => '登录';

  @override
  String get cannotReachServer => '无法连接服务器';

  @override
  String get retryButton => '重试';

  @override
  String get nextButton => '下一步';

  @override
  String get backButton => '上一步';

  @override
  String get stepSiteLabel => '站点';

  @override
  String get stepAccountLabel => '账号';

  @override
  String get stepAdvancedLabel => '高级';

  @override
  String get registerTitle => '创建账号';

  @override
  String get registerButton => '创建账号';

  @override
  String get noAccount => '还没有账号？';

  @override
  String get registerLink => '去注册';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get signInLink => '去登录';

  @override
  String get otpLabel => '验证码';

  @override
  String get otpHint => '6位验证码';

  @override
  String get sendCodeButton => '发送验证码';

  @override
  String get codeSentMessage => '验证码已发送至您的邮箱。';

  @override
  String get otpRequiredMessage => '需要邮箱验证，请输入收到的验证码。';

  @override
  String get registrationDisabledError => '管理员已关闭注册功能。';

  @override
  String get accountExistsError => '该用户名或邮箱已被注册。';

  @override
  String get registerSuccessMessage => '注册成功！正在登录…';

  @override
  String get filesNav => '文件';

  @override
  String get trashNav => '回收站';

  @override
  String get newFolderTitle => '新建文件夹';

  @override
  String get folderNameLabel => '文件夹名称';

  @override
  String get renameTitle => '重命名';

  @override
  String get newNameLabel => '新名称';

  @override
  String get deleteAction => '删除';

  @override
  String get restoreAction => '还原';

  @override
  String get deleteForeverAction => '彻底删除';

  @override
  String get uploadAction => '上传';

  @override
  String get dropFilesHint => '拖拽文件到此处上传';

  @override
  String get downloadAction => '下载';

  @override
  String get cancelButton => '取消';

  @override
  String get createButton => '创建';

  @override
  String get renameButton => '重命名';

  @override
  String get deleteConfirmTitle => '移入回收站？';

  @override
  String get deleteConfirmBody => '您可以从回收站恢复此项目。';

  @override
  String get permanentDeleteConfirmTitle => '彻底删除？';

  @override
  String get permanentDeleteConfirmBody => '此操作不可撤销。';

  @override
  String get emptyFolderMessage => '此文件夹为空。';

  @override
  String get emptyTrashMessage => '回收站为空。';

  @override
  String get profileNav => '个人';

  @override
  String get storageTitle => '存储空间';

  @override
  String storageUsedOf(String used, String total) {
    return '已用 $used，共 $total';
  }

  @override
  String storageUsedNoQuota(String used) {
    return '已用 $used';
  }

  @override
  String get accountTitle => '账号';

  @override
  String get roleLabel => '角色';

  @override
  String get joinedLabel => '注册时间';

  @override
  String get maxUploadSubtitle => '仅限制浏览器端上传，原生客户端没有大小限制';
}
