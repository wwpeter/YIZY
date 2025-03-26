//
//  ApplicationDetailVC.swift
//  SXProject
//
//  Created by 王威 on 2025/2/23.
//

import UIKit

class ApplicationDetailVC: ViewController {

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
      
        initViewLayouts()
    }
    
    func initViewLayouts() {
        
    }
    
    func config() {
        
    }


}
