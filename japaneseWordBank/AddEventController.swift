//
//  AddEventController.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 20/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

protocol AddEventDelegate{
    func updateSelectionFromAddEvent()
    func updateTableFromAddEvent()
    func addBlur()
    func removeBlur()
}

class AddEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var delegate: AddEventDelegate!
    
    @IBOutlet weak var popUpBackground: UIImageView!
    @IBOutlet weak var popUpBoard: UIImageView!
    
    @IBOutlet weak var inputKanji: UITextField!
    @IBOutlet weak var inputHiragana: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var addNewCityBtn: UIButton!
    
    var kanji: String = "Kanji"
    var hiragana: String = "Hiragana"
    var cityid: Int = 0
    var typeid: Int = 0
    var city: String = selectionRegion[0]
    var type: String = selectionType[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //layout
        if(selectionRegion.count<=1){
            cityPicker.isHidden = true
            addNewCityBtn.isHidden = true
            inputCity.isHidden = false
        }else{
            self.cityPicker.selectRow(cityid, inComponent: 0, animated: false)
            self.pickerView(self.cityPicker, didSelectRow: cityid, inComponent: 0)
            self.typePicker.selectRow(typeid, inComponent: 0, animated: false)
            self.pickerView(self.typePicker, didSelectRow: typeid, inComponent: 0)
        }
        
        //Effect
        delegate.addBlur()
        self.showAnimate()
        
        //config
        popUpBoard.layer.cornerRadius = 10
        popUpBoard.layer.shadowColor = UIColor.black.cgColor
        popUpBoard.layer.shadowOpacity = 0.5
        popUpBoard.layer.shadowOffset = CGSize(width: 3, height: 3)
        popUpBoard.layer.shadowRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Input field layout
    @IBAction func addNewCity(_ sender: UIButton) {
        if(cityPicker.isHidden == false){
            cityPicker.isHidden = true
            addNewCityBtn.setTitle("返回選擇", for: .normal)
            inputCity.isHidden = false
        }else{
            cityPicker.isHidden = false
            addNewCityBtn.setTitle("新增城市", for: .normal)
            inputCity.isHidden = true
        }
    }

    //Update Table
    func updateTable(){
        kanji = inputKanji.text!
        hiragana = inputHiragana.text!
        if cityPicker.isHidden == true{
            city = inputCity.text!
        }else{
            city = selectionRegion[cityid]
        }
        type = selectionType[typeid]

        if !selectionRegion.contains(city){
            selectionRegion.append(city)
            selectedCityID = selectionRegion.count-1
            delegate.updateSelectionFromAddEvent()
        }else{
            selectedCityID = cityid
        }
        
        selectedTypeID = typeid
        
        let newVocab = VocabTuple(japaneseTerm: hiragana, chineseTerm: kanji, city: city, locationType: type)
//        print("whole length is \(wholeArray.arr.count)")
        wholeArray.addVocab(vocab: newVocab)
//        print("added whole length is \(wholeArray.arr.count)")
        //update on local storage
        let userdefaults = UserDefaults.standard
        userdefaults.set(NSKeyedArchiver.archivedData(withRootObject: wholeArray), forKey: "wholeArray")
//        print("added to storage")
        delegate.updateTableFromAddEvent()
        
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == cityPicker){
            return selectionRegion.count-1
        }else{
            return selectionType.count-1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(pickerView == cityPicker){
            if(selectionRegion.count<=1){
                return NSAttributedString(string: selectionRegion[row], attributes: [NSForegroundColorAttributeName:hexColor(hex: "#000019")])
            }else{
                return NSAttributedString(string: selectionRegion[row+1], attributes: [NSForegroundColorAttributeName:hexColor(hex: "#000019")]) //66CCFF
            }
        }else{
            return NSAttributedString(string: selectionType[row+1], attributes: [NSForegroundColorAttributeName:hexColor(hex: "#000019")])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == cityPicker){
            if(selectionRegion.count>1){
                cityid = row+1
                city = selectionRegion[cityid]
            }
        }else{
            typeid = row+1
            type = selectionType[typeid]
        }
    }
    
    //Leave Action
    @IBAction func cancel(_ sender: UIButton) {
        delegate.removeBlur()
        self.removeAnimate()
    }
    
    @IBAction func add(_ sender: UIButton) {
        if(cityPicker.isHidden == false && (inputKanji.text! == "" || inputHiragana.text == "")){
            inputKanji.placeholder = "請勿漏空"
            inputHiragana.placeholder = "請勿漏空"
        }else if(cityPicker.isHidden == true && (inputKanji.text! == "" || inputHiragana.text! == "" || inputCity.text! == "") ){
            inputKanji.placeholder = "請勿漏空"
            inputHiragana.placeholder = "請勿漏空"
            inputCity.placeholder = "請勿漏空"
        }else{
            inputKanji.placeholder = "請輸入中文"
            inputHiragana.placeholder = "請輸入外語"
            inputCity.placeholder = "請輸入城市"
            updateTable()
            delegate.removeBlur()
            self.removeAnimate()
        }
        
        
    }
    
    //Effect
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }

}
