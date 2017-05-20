//
//  AddEventController.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 20/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

protocol AddEventDelegate{
    func updateSelectionFromAddEvent(cityid: Int)
    func updateTableFromAddEvent(cityid: Int, typeid: Int)
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
    @IBOutlet weak var typPicker: UIPickerView!
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var addNewCityBtn: UIButton!
    
    var kanji: String = "Kanji"
    var hiragana: String = "Hiragana"
    var cityid: Int = 1
    var typeid: Int = 1
    var city: String = selectionRegion[1]
    var type: String = selectionType[1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        print("\(kanji) \(hiragana) \(city) \(type)")
        if(cityPicker.isHidden == true){
            city = inputCity.text!
            selectionRegion.append(city)
            cityid = selectionRegion.count-1
            delegate.updateSelectionFromAddEvent(cityid: cityid)
        }
        
        
        let newVocab = VocabTuple(japaneseTerm: hiragana, chineseTerm: kanji, city: city, locationType: type)
        wholeArray.addVocab(vocab: newVocab)
        delegate.updateTableFromAddEvent(cityid: cityid, typeid: typeid)
        
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
            return NSAttributedString(string: selectionRegion[row+1], attributes: [NSForegroundColorAttributeName:hexColor(hex: "#000019")]) //66CCFF
        }else{
            return NSAttributedString(string: selectionType[row+1], attributes: [NSForegroundColorAttributeName:hexColor(hex: "#000019")])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == cityPicker){
            cityid = row+1
            city = selectionRegion[row+1]
        }else{
            typeid = row+1
            type = selectionType[row+1]
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
        }else if(cityPicker.isHidden == true && (inputKanji.text! == "" || inputHiragana.text! == "") || inputCity.text! == ""){
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
