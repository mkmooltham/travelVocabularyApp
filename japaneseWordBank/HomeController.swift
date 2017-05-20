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

class HomeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AddEventDelegate{
    var delegate: Homedelegate!
    let dropDownMenu = UIPickerView()
    
    var selectedCityID = 0
    var selectedTypeID = 0
    
    @IBOutlet weak var selectionBox: UITextField!
    @IBOutlet weak var selectionBoxRight: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
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
//        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: wholeArray), forKey: "wholeArray")
        
        //get data from local storage
        if let data = userDefaults.object(forKey: "wholeArray") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
            unarc.setClass(VocabList.self, forClassName: "wholeArray")
            wholeArray = unarc.decodeObject(forKey: "root") as! VocabList
        }

        
        selectionRegion += wholeArray.getRegionList()
        filteredArray.update(vocabList: wholeArray,filteredByRegion: selectionRegion[0], filteredByType: selectionType[0])
        filteredArray.printArray()
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
        filteredArray.printArray()
        delegate.changeTable()
        
    }
    
    func closeSelection(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    
    func updateSelectionFromAddEvent(cityid: Int){
        self.dropDownMenu.reloadComponent(0)
    }
    
    func updateTableFromAddEvent(cityid: Int, typeid: Int){
        self.dropDownMenu.selectRow(cityid, inComponent: 0, animated: false)
        self.pickerView(self.dropDownMenu, didSelectRow: cityid, inComponent: 0)
        self.dropDownMenu.selectRow(typeid, inComponent: 1, animated: false)
        self.pickerView(self.dropDownMenu, didSelectRow: typeid, inComponent: 1)
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
        }
    }

}
