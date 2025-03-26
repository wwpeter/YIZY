//
//  BottomView.swift
//  SXProject
//
//  Created by 王威 on 2025/3/26.
//

import UIKit

typealias BottomViewBlock = () -> Void
class BottomView: UIView {

    var submitBlock: BottomViewBlock?
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
    
    //MARK: - action
    @objc func addSubmit() {
        guard let blockT = submitBlock else {return}
        blockT()
    }
    
    @objc
    func agreeClick(button: UIButton) {
        button.isSelected = !button.isSelected
      
     
    }
    
    //MARK: - initialize
    func initViews() {
        addSubview(submitBut)
        addSubview(selectedBut)
        addSubview(subLabel)
    }
    
    func initViewLayouts() {
        submitBut.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(self.snp.left).offset(sxDynamic(20))
            make.right.equalTo(self.snp.right).offset(sxDynamic(-20))
            make.height.equalTo(sxDynamic(45))
        }
        selectedBut.snp.makeConstraints { make in
            make.width.height.equalTo(sxDynamic(22))
            make.left.equalTo(submitBut.snp.left)
            make.top.equalTo(submitBut.snp.bottom).offset(sxDynamic(10))
        }
      
        subLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectedBut.snp.trailing).offset(sxDynamic(5))
            make.centerY.equalTo(selectedBut.snp.centerY)
            make.height.equalTo(sxDynamic(18))
        }
    }

    
    //MARK: - getter
    
    private lazy var selectedBut: UIButton = {
        let but = UIButton.init(type: .custom)
        but.setImage(UIImage(named: "iot_login_check") , for: .normal)
        but.setImage(UIImage(named: "login_selected") , for: .selected)
        but.addTarget(self, action: #selector(agreeClick(button:)), for: .touchUpInside)
        
        return but
    }()
    
    private lazy var submitBut: UIButton = {
        let but = CreateBaseView.makeBut("立即申请", kTBlue, kWhite, UIFont.sx.font_t16Blod)
        but.layer.cornerRadius = sxDynamic(22)
        but.addTarget(self, action: #selector(addSubmit), for: .touchUpInside)
        
        return but
    }()
    
    private lazy var subLabel: UILabel = {
        let label = CreateBaseView.makeLabel("我已阅读并同意《个人信息共享授权协议》", UIFont.sx.font_t13, kT777, .center, 1)
        
        return label
    }()
}
