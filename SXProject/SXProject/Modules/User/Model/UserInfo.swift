//
//  UserInfo.swift
//  DigitalSleep
//
//  Created by reset on 2021/12/9.
//

import Foundation

/*
 "data": {
    "uuid": "string",
    "pictureUrl": "string",
    "name": "string",
    "phone": "string",
    "email": "string",
    "area": "string"地区:0国内1国外
    "areaName":地区名称
  }
 */

/// 用户相关
let kUserId = UserSingleton.shared.getToken()
let kPhone = UserSingleton.shared.getHhtPageUrl()
let kProductKey = UserSingleton.shared.getHjfqPageUrl()
let kDeviceName = UserSingleton.shared.getShowHhtPage()
let kDeviceSecret = UserSingleton.shared.getUserId()


struct UserInfo: HandyJSON {
    ///好汇推页面url（IOS使用）
    var hhtPageUrl = ""
    ///好汇推页面url（IOS使用）
    var hjfqPageUrl = ""
    ///    是否展示好汇推页面（APP使用）
    var showHhtPage = ""

    var token = ""
    var userId = ""
}
@objc class UserSingleton: NSObject {
    
    @objc static let shared = UserSingleton()
    
    var userInfo = UserInfo()
    
    private override init() {
        // 私有化构造函数，防止外部创建新的实例
        super.init()
        
        getUser()
    }
    
    ///删除用户
    func dealUser() {
        delUserDefault(key: "token")
        delUserDefault(key: "userId")
        delUserDefault(key: "showHhtPage")
        delUserDefault(key: "hjfqPageUrl")
        delUserDefault(key: "hhtPageUrl")
    }
    ///存储用户
    func getUser() {
        userInfo.token =  getUserDefault(key: "token")
        userInfo.userId =  getUserDefault(key: "userId")
        userInfo.showHhtPage =  getUserDefault(key: "showHhtPage")
        userInfo.hjfqPageUrl =  getUserDefault(key: "hjfqPageUrl")
        userInfo.hhtPageUrl =  getUserDefault(key: "hhtPageUrl")
    }
    
    func upDataUser() {
        userInfo.token =  getUserDefault(key: "token")
        userInfo.userId =  getUserDefault(key: "userId")
        userInfo.showHhtPage =  getUserDefault(key: "showHhtPage")
        userInfo.hjfqPageUrl =  getUserDefault(key: "hjfqPageUrl")
        userInfo.hhtPageUrl =  getUserDefault(key: "hhtPageUrl")
    }
    
    
    @objc func getToken() -> String {
        return  UserSingleton.shared.userInfo.token
    }
    
    @objc func getHhtPageUrl() -> String {
        return  UserSingleton.shared.userInfo.hhtPageUrl
    }
    
    @objc func getHjfqPageUrl() -> String {
        return  UserSingleton.shared.userInfo.hjfqPageUrl
    }
    
    
    @objc func getShowHhtPage() -> String {
        return  UserSingleton.shared.userInfo.showHhtPage
    }
    
    @objc func getUserId() -> String {
        return  UserSingleton.shared.userInfo.userId
    }
    
    
    ///获取用户信息
    func getUserDetail() {
        let userJson = getUserDefault(key: "userDetail")
        let tempJson = userJson.sx.base64Decoded ?? ""
        if let userInfoT: UserInfo = JSONHelper.parse(jsonString: tempJson) {
            printLog(userInfoT)
            userInfo = userInfoT
        }
    }
    
    ///用户详情接口
    func userDetail() {
        let token = getUserDefault(key: "token")
        let param = ["token": token]
        NetworkRequestManager.sharedInstance().requestPath(kQueryUserOrderInfo, withParam: param) { result in
            printLog(result)
            let detailStr = result.sx.base64Encoded
            setUserDefault(key: "userDetail", value: detailStr ?? "")
            _ = JSONHelper.exchangeDic(jsonStr: result)
            if let userInfo: UserInfo = JSONHelper.parse(jsonString: result) {
                printLog(userInfo)
                UserSingleton.shared.userInfo = userInfo
            }
            self.getUserDetail()
        } failure: { error in
//            Toast.showInfoMessage("".sx_T)
        }
    }
    
    
}
