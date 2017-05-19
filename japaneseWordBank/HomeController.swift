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

class HomeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var delegate: Homedelegate!
    
    @IBOutlet weak var selectionBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrive data
        let userDefaults = UserDefaults.standard
        
        //TestData
//        wholeArray.addVocab(vocab: testTuple1)
//        wholeArray.addVocab(vocab: testTuple2)
//        wholeArray.addVocab(vocab: testTuple3)
//        wholeArray.addVocab(vocab: testTuple4)
//        wholeArray.addVocab(vocab: testTuple5)
        
        if let data = userDefaults.object(forKey: "wholeArray") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
            unarc.setClass(wholeArray.self, forClassName: "wholeArray")
            let wholeArray = unarc.decodeObject(forKey: "root")
        }

        
        selectionRegion += wholeArray.getRegionList()
        filteredArray.update(vocabList: wholeArray,filteredByRegion: selectionRegion[0])
        //Create PickerView
        let dropDownMenu = UIPickerView()
        dropDownMenu.delegate = self
        selectionBox.inputView = dropDownMenu
        
        //StoreDataPlay
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //selection menu
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionRegion.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectionRegion[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionBox.text = selectionRegion[row]
        //update table
        filteredArray.update(vocabList: wholeArray,filteredByRegion: selectionRegion[row])
        filteredArray.printArray()
        delegate.changeTable()
        self.view.endEditing(true)
    }
    
    //connect to table
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToTable") {
            let tableVC = segue.destination  as! VocabTableViewController
            // Pass data to secondViewController before the transition
            self.delegate = tableVC
        }
    }

}
