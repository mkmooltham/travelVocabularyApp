//
//  vocabTuple.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

class VocabTuple: NSObject, NSCoding {
    public var hiragana: String = "Hiranaga"
    public var kanji: String = "Kanje"
    public var region: String = "city"
    public var type: String = "type"
    
    override init(){}
    
    init(japaneseTerm: String, chineseTerm: String, city: String, locationType: String){
        //hiragana
        hiragana = japaneseTerm
        
        //kanji
        kanji = chineseTerm
        
        //region
        region = city
        
        //type
        type = locationType
    }
    
    required init(coder decoder: NSCoder) {
        self.hiragana = decoder.decodeObject(forKey: "hiragana") as? String ?? ""
        self.kanji = decoder.decodeObject(forKey: "kanji") as? String ?? ""
        self.region = decoder.decodeObject(forKey: "region") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(hiragana, forKey: "hiragana")
        coder.encode(kanji, forKey: "kanji")
        coder.encode(region, forKey: "region")
        coder.encode(type, forKey: "type")
    }
    
}

class VocabList: NSObject, NSCoding{
    public var arr = [VocabTuple]()
    
    override init(){}
    
    required init(coder decoder: NSCoder) {
        self.arr = (decoder.decodeObject(forKey: "arr") as? Array<VocabTuple>)!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(arr, forKey: "arr")
    }
    
    func addVocab(vocab: VocabTuple){
        self.arr.append(vocab)
    }
    
    func getRegionList() -> Array<String>{
        var regionArr = [String]()
        
        for vocab in self.arr{
            regionArr.append(vocab.region)
        }
        regionArr = regionArr.removeDuplicates()
        
        return regionArr
    }
    
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
