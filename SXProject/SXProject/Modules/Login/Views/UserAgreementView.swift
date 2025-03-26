//
//  UserAgreementView.swift
//  SXProject
//
//  Created by 王威 on 2025/2/22.
//

import UIKit
import WebKit

class UserAgreementView: UIView, WKNavigationDelegate {
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
        addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        contentView.addSubview(cancleBut)
        contentView.addSubview(submitBut)
    }
    
    func initViewLayouts() {
        
    }
    
    // MAKR: - 事件
    @objc
    func click() {
   
        
        self.dismiss()
    }
    
    @objc
    func cancelClick() {
   
        
        self.dismiss()
    }
    
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
    
    //MARK: - getter
    
    // 定义懒加载的 WKWebView
    lazy var webView: WKWebView = {
        // 创建配置 (可选)
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        // 初始化 WebView
        let webView = WKWebView(frame: CGRect(x: 0, y: sxDynamic(55), width: kSizeScreenWidth, height: sxDynamic(600)), configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        
        return webView
    }()
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = sxDynamic(16)
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .white
        
        return contentView
    }()
    private lazy var submitBut: UIButton = {
        let submitBut = CreateBaseView.makeBut("iot_ok".sx_T, .clear, kTBlue, UIFont.sx.font_t13)
        submitBut.addTarget(self, action: #selector(click), for: .touchUpInside)
        submitBut.backgroundColor = .white
        
        return submitBut
    }()
    
    private lazy var cancleBut: UIButton = {
        let cancleBut = CreateBaseView.makeBut("map_cancle".sx_T, .clear, kT777, UIFont.sx.font_t13)
        cancleBut.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        cancleBut.backgroundColor = .white
        
        return cancleBut
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhite
        
        return view
    }()
    private lazy var topView: ProtocolTopView = {
        let view = ProtocolTopView()
        view.layer.cornerRadius = sxDynamic(16)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
 
}
