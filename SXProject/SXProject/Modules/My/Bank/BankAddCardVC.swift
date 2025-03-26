//
//  BankAddCardVC.swift
//  SXProject
//
//  Created by 王威 on 2025/2/13.
//

import UIKit

class BankAddCardVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var sourceData = ["姓名：", "银行卡号：", "预留电话：", "归属银行："]
    var placeholderData = ["请输入姓名", "请输入银行卡号", "请输入银行预留电话", "请输入银行名称"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
       
    }
    
    func initViews() {
        view.backgroundColor = kWhite
        SX_navTitle = "添加银行卡"
        
        let viewT = UIView()
        viewT.frame = CGRectMake(0, 0, kSizeScreenWidth, sxDynamic(110))
        viewT.addSubview(loginOutBut)
        
        AddCardCell.registerCell(tableView: myTableView)
        view.addSubview(myTableView)
        myTableView.tableFooterView = viewT
    }
    
    //MARK: - initialize
    lazy var myTableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, kSizeScreenWidth , kSizeScreenHight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = kWhite
        tableView.layer.cornerRadius = sxDynamic(8)
        
        return tableView
    }()
    
    private lazy var loginOutBut: UIButton = {
        let but = CreateBaseView.makeBut("确认添加", kTBlue, .white, UIFont.sx.font_t16)
        but.layer.cornerRadius = sxDynamic(21)
        
        but.frame = CGRectMake(sxDynamic(20),sxDynamic(60), kSizeScreenWidth - sxDynamic(40), sxDynamic(50))
        
        return but
    }()
}
