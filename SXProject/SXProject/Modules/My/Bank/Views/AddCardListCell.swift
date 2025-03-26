//
//  AddCardListCell.swift
//  SXProject
//
//  Created by 王威 on 2025/2/13.
//

import UIKit

class AddCardListCell: UITableViewCell {

    class func cellID() -> String {
        return "ListCardCell"
    }
    class func registerCell(tableView: UITableView) {
        tableView.register(ListCardCell.self, forCellReuseIdentifier: cellID())
    }
    class func cellHeight() -> CGFloat {
        return sxDynamic(133)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = kBF8
        self.selectionStyle = .none
        initViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - action


    func initViews() {
        contentView.addSubview(groundView)
        groundView.addSubview(bankCard)
        groundView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
      
        bankCard.snp.makeConstraints { make in
            make.width.height.equalTo(sxDynamic(15))
            make.centerY.equalTo(groundView.snp.centerY)
            make.right.equalTo(groundView.snp.centerX).offset(sxDynamic(-50))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bankCard.snp.centerY)
            make.height.equalTo(sxDynamic(20))
            make.left.equalTo(bankCard.snp.right).offset(sxDynamic(5))
        }
    }
    
    //MARK: - getter
    private lazy var groundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = sxDynamic(8)
        view.frame = CGRectMake(0, sxDynamic(10), kSizeScreenWidth - sxDynamic(30), sxDynamic(123))
        
        return view
    }()
    
    private lazy var bankCard: UIImageView = {
        let img = CreateBaseView.makeIMG("cell_add_card", .scaleAspectFit)
        
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = CreateBaseView.makeLabel("添加银行卡", UIFont.sx.font_t16, kT333, .left, 1)
        
        return titleLabel
    }()
    
}
