//
//  TopViewDetailView.swift
//  SXProject
//
//  Created by 王威 on 2025/2/23.
//

import UIKit

class TopViewDetailView: UIView {

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
    private lazy var backBut: UIButton = {
        let but = CreateBaseView.makeBut("")
        
        return but
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = CreateBaseView.makeLabel("--", UIFont.sx.font_t18Blod, kWhite, .center, 1)
        
        return label
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = AssetColors.bfff10.color
        
        return view
    }()
    private lazy var topLabel: UILabel = {
        let label = CreateBaseView.makeLabel("", UIFont.sx.font_t13, kWhite, .left, 1)
        
        return label
    }()
    private lazy var iconImg: UIImageView = {
        let iconImg = CreateBaseView.makeIMG("", .scaleAspectFit)
        
        return iconImg
    }()
    private lazy var centerLabel: UILabel = {
        let label = CreateBaseView.makeLabel("预审通过", UIFont.sx.font_t20Blod, kWhite, .center, 1)
        
        return label
    }()
    private lazy var centerSub: UILabel = {
        let label = CreateBaseView.makeLabel("请耐心等待咨询电话", UIFont.sx.font_t15, kWhite, .center, 1)
        
        return label
    }()
    
    
    private lazy var groundImg: UIImageView = {
        let img = CreateBaseView.makeIMG("alertView_ground", .scaleAspectFit)
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private lazy var titleCenterLabel: UILabel = {
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
