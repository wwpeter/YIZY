//
//  LoginVC+Config.swift
//  SXProject
//
//  Created by 王威 on 2025/3/26.
//

import UIKit

extension LoginVC {
    /// 获取验证码
    func getPhoneCode() {
        if let telephone = self.textField.text {
            if telephone.isEmpty {
                Toast.showInfoMessage("请输入手机号")
                return
            }
            let param = ["telephone": telephone, "appCode":"HHT","channelCode":"ios"]
            NetworkRequestManager.sharedInstance().requestPath(kSendValidateCode, withParam: param) { [weak self] result in
                printLog(result)
                
                
                _ = JSONHelper.exchangeDic(jsonStr: result)
                
            } failure: { error in
                //            Toast.showInfoMessage("".sx_T)
            }
        }
    }
}
