//
//  MyController+List.swift
//  SXProject
//
//  Created by 王威 on 2024/5/15.
//

import UIKit

extension MyController {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MyItemCell.cellID()) as?  MyItemCell {
            
            cell.setTitle(title: sourceData[indexPath.row], icon: sourceImg[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyItemCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let vc = BankListVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 1) {
            let vc = ProtocolVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            
        }
    }
}
