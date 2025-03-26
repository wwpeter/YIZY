//
//  URLDefinePath.swift
//  SXProject
//
//  Created by 王威 on 2024/4/23.
//
//解决Swift 不能调用OC 宏定义的问题

import Foundation

//登录相关
let kSendCode = "/app/user/sendCode"///发送验证码
let kReset = "/app/user/reset"///密码重置
let kRegister = "/app/user/register"///注册接口
let kLogin = "/app/user/login"///登录接口
let kForget = "/app/user/forget"//忘记密码
let kBind = "/app/user/bind"///绑定相关接口 手机号 邮箱

//用户信息相关
let kUpdate = "/app/user/update"/// 昵称 头像接口
let kProblemList = "/app/user/problem/list"///用户问题列表
let kProblemAdd = "/app/user/problem/add"///添加用户问题
let kUserDetail = "/app/user/detail"///用户详情接口
///
let kReceiveDevice = "/app/user/shareInfo/list"///接收设备列表
let kReceiveDeviceEdit = "/app/user/shareInfo/update"///接收设备消息编辑
let kShareDevice = "/app/user/share/list"///共享设备列表
let kShareDeviceEdit = "/app/user/share/update"///共享设备编辑
let kReceiveListClean = "/app/user/shareInfo/clear" ///共享设备消息清空

///消息设置
let kMessageSetting = "/app/user/msg/update" /// 消息设置
let kMessageSettingList = "/app/user/msg/list" /// 消息设置列表

//设备管理相关接口
let kDeviceShare = "/app/device/management/share"///分享设备
let kDeviceResetName = "/app/device/management/rename"///设备重命名
let kStatuPath = "/app/device/management/queryWifiConfigRecord"///配网成功之后设备状态接口
let kDeviceList = "/app/device/management/list"//设备列表接口
let kDeletedDevice = "/app/device/management/delete"///删除设备
let kAddDevice = "/app/device/management/add"///添加设备接口
let kAddShareDevce = "/app/device/management/addShare"///添加分享设备
///查询用户设备详情
let kDeviceDetail = "/app/device/management/detail"

//地图管理相关接口
let kMapReset = "/app/map/management/recreate"///地图重建
let kDeviceMapList = "/app/map/management/list"///设备地图列表
let kMapEdit = "/app/map/management/edit"///编辑地图
let kMapCreate = "/app/map/management/create"///创建地图
let kStopCreateMap = "/app/map/management/create/stop" ///停止建图
let kResumeMap = "/app/map/management/create/resume"///恢复建图
let kMapPause = "/app/map/management/create/pause"///暂停建图
let kDelMap = "/app/map/management/remove" /// 删除地图
/// 查看建图记录列表
let kCreateMapList = "/app/map/management/log/list"
/// 查看建图记录详情
let kCreateMapDetial = "/app/map/management/log/detial"
/// 删除建图记录
let kCreateMapDel = "/app/map/management/log/del"

//清扫相关接口
let kStartMopDry = "/app/device/clean/mop/dry/start"/// 开始烘干拖布
let kStartMopDryCancle = "/app/device/clean/mop/dry/cancel"/// 取消烘干拖布
///

let kStartMopClean = "/app/device/clean/mop/clean/start"///  开始清洗拖布
let kCleanMopPause = "/app/device/clean/mop/clean/pause" /// 暂停清洗拖布
let kCleanResume = "/app/device/clean/mop/clean/resume" /// 恢复清洗拖布
let kCleanMopCancel = "/app/device/clean/mop/clean/cancel" /// 取消清洗拖布

let kHomeInfo = "/app/device/clean/home/info" /// 查询基站状态信息
let kStartCollectDust = "/app/device/clean/dust/collect/start"/// 开始基站集尘


let kStartTempClean = "/app/device/clean/clean/temp/start"/// 开始临时清扫
let kStartZoneClean = "/app/device/clean/clean/zoning/start" /// 开始划区清扫
let kStopClean = "/app/device/clean/clean/stop"/// 结束清扫

let kStartClean = "/app/device/clean/clean/start"/// 开始全局清扫
let kResumeClean = "/app/device/clean/clean/resume"/// 恢复清扫
let kPauseClean = "/app/device/clean/clean/pause"/// 暂停清扫

let kCleanInfo = "/app/device/clean/clean/info"/// 查询清扫信息
let kPartStart = "/app/device/clean/clean/part/start"/// 开始选区清扫

let kCleanDeviceInfo = "/app/device/clean/clean/device/info"/// 查询清洁机器信息
let kCleanBackToStation = "/app/device/clean/clean/backToStation"/// 返回基站
let kCancelBackToStation = "/app/device/clean/cancelBackToStation" /// 取消返回基站

///清扫配置相关接口
let kSaveCleanSetting = "/app/device/clean/set/saveCleanSetting" /// 保存设备清扫设置
let kSaveCarpetCleanSetting = "/app/device/clean/set/saveCarpetCleanSetting" /// 保存地毯清扫设置
let kGetCleanSetting = "/app/device/clean/set/getCleanSetting" ///查询设备清扫设置
let kGetCarpetCleanSetting = "/app/device/clean/set/getCarpetCleanSetting" ///查询地毯清扫设置
let kGetAllCleanSetting = "/app/device/clean/set/getAllCleanSetting"///查询清扫设置项

///运营相关内容
let kVoiceList = "/app/operation/voice/list"///音响指南列表
let kProblemListWeb = "/app/operation/problem/list"///常见问题列表
let kCustomerInfo = "/app/operation/office/info" /// 客服信息
let kGuideList = "/app/operation/guide/list"///产品使用指南列表
let kProtocolList = "/app/operation/agreement/list" /// 协议列表
let kAgreement = "/app/operation/agreement/detail"///协议详情

///机器设置相关接口
let kSettingUpdate = "/app/device/setting/update" ///修改设备设置
let kSettingGet = "/app/device/setting/get" ///获取设备设置
let kSettingUpdateTimeZone = "/app/device/setting/updateTimeZone"///修改时区设置
let kGetNotDisturb = "/app/device/setting/getNotDisturb" ///获取勿扰模式配置
let kUpdateNotDisturb = "/app/device/setting/updateNotDisturb" ///修改勿扰模式配置
let kAddNotDisturb = "/app/device/setting/addNotDisturb" ///新增勿扰模式配置
let kGetFirmwareConfig = "/app/device/setting/getFirmwareConfig" ///获取设备固件版本
let kDeviceReset = "/app/device/maintain/reset" /// 复位
let kDeviceGetInfo = "/app/device/maintain/getInfo" /// 获取设置维护保养信息
/// 定时任务
let kAddTimingClean = "/app/device/setting/addTimingClean" ///添加定时清务配置
let kDelTimingClean = "/app/device/setting/delTimingClean" /// 删除定时清务配置
let kChangeTimingCleanOpenStatus = "/app/device/setting/changeTimingCleanOpenStatus" /// 切换定时清务配置开启状态
let kListTimingClean = "/app/device/setting/listTimingClean" /// 获取定时清务配置


/// 划区相关接口
let kSaveZone = "/app/device/zone/saveZone" ///保存划区信息
let kQueryZoneList = "/app/device/zone/queryZoneList"/// 查询设备划区信息
///
/// 虚拟墙
/// 保存虚拟墙
let kSaveVirtualWall = "/app/virtualWall/management/saveVirtualWall"
/// 查询虚拟墙
let kQueryVirtualWall = "/app/virtualWall/management/queryVirtualWall"

///机器产品信息
let kSystemInfo = "/app/device/machine/systemInfo"

/// APP-清扫信息相关接口
/// 清洁历史统计信息
let kHistoryStatistic = "/app/device/clean/info/historyStatistic"
/// 清洁记录列表
let kHistoryList = "/app/device/clean/info/historyList"
/// 清洁记录详情
let kHistoryDetail = "/app/device/clean/info/historyDetail"
/// 清洁记录删除
let kHistoryDel = "/app/device/clean/info/history/del"

/// app功能
/// 寻找主机开始
let kSearchDevice = "/app/function/searchDevice/start"
/// 遥控控制
let kRemoteControl = "/app/function/remoteControl"

/// 巡航记录列表
let kCruiseHistoryList = "/app/device/cruise/info/historyList"
/// 巡航记录详情
let kCruisehistoryDetail = "/app/device/cruise/info/historyDetail"
/// 巡航记录列表
let kCruiseHistoryDel = "/app/device/cruise/info/history/del"

/// 机器OTA升级相关
/// 升级到最新版本
let kUpgradeLatestVersion = "/app/device/ota/upgradeLatestVersion"
/// 暂不升级
let kUnUpgrade = "/app/device/ota/unUpgrade"
/// 查询升级进度
let kQueryUpgradeProgress = "/app/device/ota/queryUpgradeProgress"
/// 获取设备最新版本
let kGetLatestVersion = "/app/device/ota/getLatestVersion"
///配置相关
let kLoginAreaConfig = "/app/config/area"///国家地区配置信息
///

/// 视频通话
let kVideoStop = "/app/video/chat/stop" ///关闭视频通话
let kVideoStart = "/app/video/chat/start" /// 发起视频通话
let kVideoLinked = "/app/video/chat/linked" /// 视频通话连接成功
let kVideoHasStartCode = "/app/video/chat/hasStartCode" /// 是否设置了视频启动码
let kVideoSetStartCode = "/app/video/chat/setStartCode" /// 设置视频视频启动码
let kVideoReset = "/app/video/chat/reset" /// 重置通话，开启关闭语音，开启关闭视频
let kVerifyStartCode = "/app/video/chat/verifyStartCode" ///校验视频通话密码是否正确
let kHeartBeat = "/app/video/chat/heartBeat" /// 心跳
let kStartCallBack = "/app/video/chat/startCallBack" /// APP加入视频通话成功后回调，给设备下发指令加入房间



///公共接口
let kUploadPolicy = "/app/common/upload/policy"//文件上传
