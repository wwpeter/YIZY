//
//  AlertViewFillFirst.swift
//  SXProject
//
//  Created by 王威 on 2025/2/23.
//

import UIKit

class AlertViewFillFirst: UIView {

   
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
        self.backgroundColor = AssetColors.b00030.color
        addSubview(contentView)
        contentView.addSubview(groundImg)
        contentView.addSubview(closeBut)
        contentView.addSubview(titleLabel)
        contentView.addSubview(submitBut)
    }
    
    func initViewLayouts() {
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(sxDynamic(248))
            make.width.equalTo(sxDynamic(260))
        }
        groundImg.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo((contentView.snp.right))
            make.height.equalTo(sxDynamic(174))
            make.top.equalTo(contentView.snp.top).offset(sxDynamic(-14))
        }
        closeBut.snp.makeConstraints { make in
            make.width.height.equalTo(sxDynamic(24))
            make.right.equalTo(contentView.snp.right).offset(sxDynamic(-20))
            make.top.equalTo(contentView.snp.top).offset(sxDynamic(15))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(sxDynamic(22))
        }
        submitBut.snp.makeConstraints { make in
            make.height.equalTo(sxDynamic(45))
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(sxDynamic(-40))
            make.width.equalTo(sxDynamic(200))
        }
    }
    
    //MARK: - getter
    func show() {
        //获取delegate
        let window = UIWindow.key
        self.frame = window?.bounds ?? CGRect.zero
        window?.addSubview(self)
        
        UIView.animate(withDuration: 0.35) {
            self.contentView.alpha = 1.0
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.4) {
//            self.contentView.transform = CGAffineTransformMakeScale
            self.contentView.alpha = 0.0
        } completion: { finished in
            self.removeFromSuperview()
        }
    }
    
    @objc func submitClick() {
        
    }
    
    //MARK: - getter
    private lazy var closeBut: UIButton = {
        let but = CreateBaseView.makeBut("alert_close")
        but.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        return but
    }()
    
    private lazy var groundImg: UIImageView = {
        let img = CreateBaseView.makeIMG("alertView_ground", .scaleAspectFit)
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = CreateBaseView.makeLabel("还差一步将出额度", UIFont.sx.font_t16Blod, kT333, .center, 1)
        
        return label
    }()
    
    private lazy var submitBut: UIButton = {
        let but = CreateBaseView.makeBut("继续填写", kWhite, kTBlue,  UIFont.sx.font_t16Blod)
        but.layer.cornerRadius = sxDynamic(25)
        but.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        
        return but
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = sxDynamic(16)
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .white
        
        return contentView
    }()
    
}
