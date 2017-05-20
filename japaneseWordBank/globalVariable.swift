//
//  globalVariable.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

let testTuple1 = VocabTuple(japaneseTerm: "Osaka", chineseTerm: "大阪", city:"大阪", locationType: "城市")
let testTuple2 = VocabTuple(japaneseTerm: "Nanba", chineseTerm: "難波", city:"大阪", locationType: "市區")
let testTuple3 = VocabTuple(japaneseTerm: "Kyoto", chineseTerm: "京都", city:"京都", locationType: "城市")
let testTuple4 = VocabTuple(japaneseTerm: "Kyotoeki", chineseTerm: "京都駅", city:"京都", locationType: "車站")
let testTuple5 = VocabTuple(japaneseTerm: "Nana", chineseTerm: "奈良", city:"奈良", locationType: "城市")
let testList = [testTuple1,testTuple2,testTuple3,testTuple4,testTuple5]

var wholeArray = VocabList()

var filteredArray = FilteredVocabList()

var selectionRegion = ["所有地區"]

var selectionType = ["所有類型","景點","餐廳","車站","市區","城市"]

var selectedCityID = 0
var selectedTypeID = 0

//hex color function
func hexColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

