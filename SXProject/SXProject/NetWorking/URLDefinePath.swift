//
//  URLDefinePath.swift
//  SXProject
//
//  Created by 王威 on 2024/4/23.
//
//解决Swift 不能调用OC 宏定义的问题

import Foundation

/// 用户登录相关接口
/// 根据手机验证码登录
let kLogin = "/hht/h5/account/login"
/// 登出
let kLogout = "/hht/h5/account/logout"
/// 注销账户
let kRemoveAccount = "/hht/h5/account/removeAccount"
/// 首页 - 首页信息查询
let kAppPageInfo = "/hht/h5/user/appPageInfo"

/// 订单相关接口
/// 填写借款信息
let kLoanInformation = "/hht/h5/user/app/loanInformation"

/// App我的页面相关接口
/// 添加银行卡信息
let kAddCard = "/hht/h5/userIndex/addCard"
/// 删除银行卡信息
let kDdeleteCard = "/hht/h5/userIndex/deleteCard"
/// 查询银行卡列表
let kQueryBankCardList = "/hht/h5/userIndex/queryBankCardList"
///申请记录（新）
let kQueryOrdersHistoryPageApp = "/hht/h5/userIndex/queryOrdersHistoryPageApp"

/// 通用接口
let kSendValidateCode = "/hht/common/sendValidateCode"

///用户主流程相关接口
///用户信息回显
let kQueryUserOrderInfo = "/hht/h5/user/queryUserOrderInfo"

/// app版本管理相关接口
/// 根据系统查询最新app版本信息
let kQueryLastAppVersionInfo = "/hht/h5/version/queryLastAppVersionInfo"

///用户埋点相关接口
///增加埋点
let kPointAdd = "/hht/h5/userPoint/add"
/// 增加渠道用户转化埋点
let kAddTransformPoint = "/hht/h5/userPoint/addTransformPoint"
/// 订单相关接口
/// 根据身份证号查询用户黑名单记录
let kQueryBlackUserIdCard = "/hht/h5/user/queryBlackUserIdCard"

///字典控制器
///查询对应的模块
let kQueryListByType = "/hht/dictionary/queryListByType"
