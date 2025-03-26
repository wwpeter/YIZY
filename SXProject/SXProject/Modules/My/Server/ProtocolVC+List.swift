//
//  ProtocolVC+List.swift
//  SXProject
//
//  Created by 王威 on 2025/2/13.
//

import UIKit

extension ProtocolVC {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         4
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: ProtocolCell.cellID()) as?  ProtocolCell {
             
             cell.setTitle(title: sourceData[indexPath.row], icon: "")
             
             return cell
         }
         
         return UITableViewCell()
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return ProtocolCell.cellHeight()
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 {
             let vc = UserProtocolVC()
             
             self.navigationController?.pushViewController(vc, animated: true)
         }
     }
}
