//
//  CenterViewDetailView.swift
//  SXProject
//
//  Created by 王威 on 2025/2/23.
//

import UIKit

class CenterViewDetailView: UIView {

    /// 使用代码创建一个View会调用该构造方法
    ///
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.initViewLayouts()
    }
    
    //MARK: - initialize
    func initViews() {
      
    }
    
    func initViewLayouts() {
        
    }
    
    //MARK: - getter
    
    private lazy var groundImg: UIImageView = {
        let img = CreateBaseView.makeIMG("alertView_ground", .scaleAspectFit)
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = CreateBaseView.makeLabel("稍后你注册本平台的手机号码会收到贷款咨询服务机构工作人员的电话，请根据平台短信核实工作人员信息，谨防他人冒充欺骗。", UIFont.sx.font_t13, kT333, .center, 0)
        
        return label
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = sxDynamic(16)
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .white
        
        return contentView
    }()
}
