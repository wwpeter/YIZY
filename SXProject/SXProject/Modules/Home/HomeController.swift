//
//  HomeController.swift
//  SXProject
//
//  Created by 王威 on 2024/1/3.
//

import UIKit
import SXBaseModule
import MJExtension

class HomeController: ViewController, HomeTopViewDelegate {
 
    
    var isConnectWiFiHotSpot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.SX_navTitle = "title".sx_T
        initViews()
    }
    
    func initViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(bottomView)
        scrollView.addSubview(topView)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    //MARK: - getter
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRectMake(0, 0, kSizeScreenWidth, kSizeScreenHight)
        scrollView.contentSize = CGSize(width: kSizeScreenWidth, height: kSizeScreenHight + sxDynamic(50))
        scrollView.backgroundColor = kBF8
        
        return scrollView
    }()
    private lazy var bottomView: HomeBottomView = {
        let view = HomeBottomView()
  
        view.frame = CGRectMake(0, sxDynamic(472) + kTopBarHeight, kSizeScreenWidth, sxDynamic(163))
        
        return view
    }()
    
    private lazy var topView: HomeTopView = {
        let view = HomeTopView()
        view.homeEventDelegate = self
        view.frame = CGRectMake(0, 0, kSizeScreenWidth, sxDynamic(525))
       
        return view
    }()
}
