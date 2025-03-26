//
//  TopGuideCell.swift
//  SXProject
//
//  Created by 王威 on 2025/2/23.
//

import UIKit

class TopGuideCell: UITableViewCell {

  
    class func cellID() -> String {
        return "HelpJkCell"
    }
    class func registerCell(tableView: UITableView) {
        tableView.register(HelpJkCell.self, forCellReuseIdentifier: cellID())
    }
    class func cellHeight() -> CGFloat {
        return sxDynamic(110)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        self.selectionStyle = .none
        initViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - action
    
    //MARK: - initializa
    func initViews() {
        contentView.addSubview(titlleLabel)
        contentView.addSubview(groundView)
        contentView.addSubview(subLabel)
    }
    
    override func layoutSubviews() {
        titlleLabel.snp.makeConstraints { make in
            
        }
        groundView.snp.makeConstraints { make in
            
        }
        subLabel.snp.makeConstraints { make in
            
        }
    }
    
    //MARK: - getter
    
    private lazy var titlleLabel: UILabel = {
        let label = CreateBaseView.makeLabel("", UIFont.sx.font_t16Blod, kT333, .left, 1)
        
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = CreateBaseView.makeLabel("", UIFont.sx.font_t13, kT333, .left, 0)
        
        return label
    }()
    
    private lazy var groundView: UIView = {
        let view = UIView()
        view.backgroundColor = kBF8
        view.layer.cornerRadius = sxDynamic(16)
        
        return view
    }()
}
