//
//  AddSubmitVC.swift
//  SXProject
//
//  Created by 王威 on 2025/3/26.
//

import UIKit

class AddSubmitVC: ViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViews()
        config()
    }
    
    func initViews() {
        view.backgroundColor = .white
        
        view.addSubview(myTableView)
        myTableView.tableFooterView = bottomView
        
        let alertView = AlertViewFillFirst()
        
        alertView.show()
        
        let alertViews = AlertViewFillSecond()
        
        alertViews.show()
    }
    
    func config() {
        bottomView.submitBlock = { [weak self] in
//            let vc = UnderReviewVC()
//            
//            self?.navigationController?.pushViewController(vc, animated: true)
            
            let vc = ApplicationDetailVC()
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - getter
    lazy var myTableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, kSizeScreenWidth, kSizeScreenHight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = kBF4F5F9
        tableView.layer.cornerRadius = sxDynamic(8)
        
        return tableView
    }()
   
    
    private lazy var bottomView: BottomView = {
        let view = BottomView()
        view.frame = CGRectMake(0, 0, kSizeScreenWidth, sxDynamic(75))
        
        return view
    }()
    
}
