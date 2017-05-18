//
//  vocabTuple.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

enum wordType {
    case all
    case city
    case area
    case site
    case station
}

class VocabTuple {
    public var hiragana: String = "Hiranaga"
    public var kanji: String = "Kanje"
    public var vocabType: wordType = wordType.all
    
    init(){}
    
    init(japaneseTerm: String, chineseTerm: String, type: wordType){
        //hiragana
        hiragana = japaneseTerm
        
        //kanji
        kanji = chineseTerm
        
        //type
        vocabType = type
    }
    
}
