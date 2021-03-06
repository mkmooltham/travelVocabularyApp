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

class HomeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AddEventDelegate, VocabTableDelegate{
    var delegate: Homedelegate!
    let dropDownMenu = UIPickerView()
    
    
    @IBOutlet weak var selectionBox: UITextField!
    @IBOutlet weak var selectionBoxRight: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrive data
        let userDefaults = UserDefaults.standard
        
        //TestData

//        let testTuple0 = VocabTuple(japaneseTerm: "おおさか", chineseTerm: "大阪", city:"大阪", locationType: "城市")
//        wholeArray.addVocab(vocab: testTuple0)
//        let testTuple1 = VocabTuple(japaneseTerm: "こうべ", chineseTerm: "神戶", city:"神戶", locationType: "城市")
//        wholeArray.addVocab(vocab: testTuple1)
//        let testTuple2 = VocabTuple(japaneseTerm: "なら", chineseTerm: "奈良", city:"奈良", locationType: "城市")
//        wholeArray.addVocab(vocab: testTuple2)
//         userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: wholeArray), forKey: "wholeArray")
        
        //get data from local storage
        if let data = userDefaults.object(forKey: "wholeArray") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
            unarc.setClass(VocabList.self, forClassName: "wholeArray")
            wholeArray = unarc.decodeObject(forKey: "root") as! VocabList
        }
        print("home whole length is \(wholeArray.arr.count)")

        
        selectionRegion += wholeArray.getRegionList()
        filteredArray.update(vocabList: wholeArray,filteredByRegion: selectionRegion[0], filteredByType: selectionType[0])
        //Create PickerView
        dropDownMenu.delegate = self
        selectionBox.inputView = dropDownMenu
        selectionBoxRight.inputView = dropDownMenu
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeSelection(_:)))
        view.addGestureRecognizer(tapGesture)
        
        //config
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        addButton.layer.shadowRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //selection menu
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return selectionRegion.count
        }else{
            return selectionType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return selectionRegion[row]
        }else{
            return selectionType[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            selectedCityID=row
            selectionBox.text = selectionRegion[row]
            selectionBoxRight.text = selectionType[selectedTypeID]
        }else{
            selectedTypeID=row
            selectionBoxRight.text = selectionType[row]
            selectionBox.text = selectionRegion[selectedCityID]
        }
        filteredArray.update(vocabList: wholeArray,filteredByRegion: selectionRegion[selectedCityID], filteredByType: selectionType[selectedTypeID])
        //update table
        delegate.changeTable()
        
    }
    
    func closeSelection(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func selectFilterRow(){
        self.dropDownMenu.selectRow(selectedCityID, inComponent: 0, animated: false)
        self.pickerView(self.dropDownMenu, didSelectRow: selectedCityID, inComponent: 0)
        self.dropDownMenu.selectRow(selectedTypeID, inComponent: 1, animated: false)
        self.pickerView(self.dropDownMenu, didSelectRow: selectedTypeID, inComponent: 1)
    }
    
    //Add Event
    @IBAction func addEvent(_ sender: UIButton) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEvent") as! AddEventController
        popUpVC.delegate = self
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    }
    
    func updateSelectionFromAddEvent(){
        self.dropDownMenu.reloadComponent(0)
    }
    
    func updateTableFromAddEvent(){
        selectFilterRow()
        delegate.changeTable()
    }
    
    func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func removeBlur(){
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    //connect to table
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToTable") {
            let tableVC = segue.destination  as! VocabTableViewController
            // Pass data to secondViewController before the transition
            self.delegate = tableVC
            tableVC.delegate = self
        }
    }
    

}
