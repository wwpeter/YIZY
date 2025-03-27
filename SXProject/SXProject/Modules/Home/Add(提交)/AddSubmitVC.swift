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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func initViews() {
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(myTableView)
        myTableView.tableFooterView = bottomView
        
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
    
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - getter
    lazy var myTableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, sxDynamic(98), kSizeScreenWidth, kSizeScreenHight - sxDynamic(98)), style: .plain)
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
    
    private lazy var topView: AddTopView = {
        let view = AddTopView()
        view.backBut.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        view.frame = CGRect(x: 0, y: 0, width: kSizeScreenWidth, height: sxDynamic(160))
        
        return view
    }()
}
