//
//  HomeController.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

protocol Homedelegate {
    func changeTable()
}

class HomeController: UIViewController {
    var delegate: Homedelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToTable") {
            let tableVC = segue.destination  as! VocabTableViewController
            // Pass data to secondViewController before the transition
            self.delegate = tableVC
        }
    }
    
    @IBAction func testBtn(_ sender: UIButton) {
        delegate.changeTable()
    }
}

//http://stackoverflow.com/questions/40715210/swift-3-call-function-from-parent-viewcontroller
