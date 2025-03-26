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
let kUserId = UserSingleton.shared.getUserID()
let kPhone = UserSingleton.shared.getPhone()
let kProductKey = UserSingleton.shared.getAppProductKey()
let kDeviceName = UserSingleton.shared.getAppDeviceName()
let kDeviceSecret = UserSingleton.shared.getAppDeviceSecret()


struct UserInfo: HandyJSON {
    var uuid = ""
    var pictureUrl = ""
    var name = ""
    var phone = ""
    var email = ""
    var area = "0"
    var areaName = ""
    var appDeviceName = ""
    var appProductKey = ""
    var appDeviceSecret = ""
    
    /// 视频通话token
    var videoToken: String = ""
}
@objc class UserSingleton: NSObject {
    
    @objc static let shared = UserSingleton()
    
    var userInfo: UserInfo?
    
    private override init() {
        // 私有化构造函数，防止外部创建新的实例
    }
    
    ///删除用户
    func dealUser() {
        delUserDefault(key: "userDetail")
        delUserDefault(key: "access_token")
    }
    ///存储用户
    func saveUser() {
        
    }
    
    /// 储存视频token
    func saveVideoToken(token: String) {
        setUserDefault(key: "video", value: token)
    }
    
    func getVideoToken() -> String {
        return getUserDefault(key: "video")
    }
    
    @objc func getAppDeviceName() -> String {
        return UserSingleton.shared.userInfo?.appDeviceName ?? ""
    }
    
    @objc func getAppProductKey() -> String {
        return UserSingleton.shared.userInfo?.appProductKey ?? ""
    }
    
    @objc func getAppDeviceSecret() -> String {
        return UserSingleton.shared.userInfo?.appDeviceSecret ?? ""
    }
    
    
    func getUserID() -> String {
        return UserSingleton.shared.userInfo?.uuid ?? ""
    }
    func getEmail() -> String {
        return UserSingleton.shared.userInfo?.email ?? ""
    }
    
    func getPhone() -> String {
        return UserSingleton.shared.userInfo?.phone ?? ""
    }
    
    func getAreaName() -> String {
        return UserSingleton.shared.userInfo?.areaName ?? ""
    }
    
    func getPictureUrl() -> String {
        return UserSingleton.shared.userInfo?.pictureUrl ?? ""
    }
    
    func getName() -> String {
        return UserSingleton.shared.userInfo?.name ?? ""
    }
    
    func getArea() -> String {
        return UserSingleton.shared.userInfo?.area ?? ""
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
        let token = getUserDefault(key: "access_token")
        let param = ["token": token]
        NetworkRequestManager.sharedInstance().requestPath(kUserDetail, withParam: param) { result in
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
    
    ///
    /**
     setUserDefault(key: "userDetail", value: detailStr ?? "")
     */
}
