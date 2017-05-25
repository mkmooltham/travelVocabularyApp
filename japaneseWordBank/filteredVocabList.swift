//
//  selectedVocabList.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

class FilteredVocabTuple{
    public var vocab: VocabTuple
    public var index: Int
    
    init(vocabTuple:VocabTuple, indexValue: Int){
        //Vocab
        vocab = vocabTuple
        
        //index
        index = indexValue
    }

}

class FilteredVocabList{
    public var arr = [FilteredVocabTuple]()
    
    init(){}
    
    init(vocabList: VocabList, filteredByRegion: String){
        var count = 0
        for vocab in vocabList.arr {
            if(vocab.region==filteredByRegion || filteredByRegion==selectionRegion[0]){
                arr.append(FilteredVocabTuple(vocabTuple: vocab,indexValue: count))
            }
            count = count+1
        }
    }
    
    func update(vocabList: VocabList, filteredByRegion: String, filteredByType: String){
        self.arr.removeAll()
        var count = 0
        for vocab in vocabList.arr {
            if(vocab.region==filteredByRegion || filteredByRegion==selectionRegion[0]){
                if(vocab.type==filteredByType || filteredByType==selectionType[0]){
                self.arr.append(FilteredVocabTuple(vocabTuple: vocab,indexValue: count))
                }
            }
            count = count+1
        }
        self.arr.sort(by: { (o1: FilteredVocabTuple, o2: FilteredVocabTuple) -> Bool in
            return o1.vocab.region == o2.vocab.region ?
                (o1.vocab.type == o2.vocab.type ?
                    o1.vocab.kanji<o2.vocab.kanji:
                    o1.vocab.type<o2.vocab.type)
                : (o1.vocab.region < o2.vocab.region)
        })
        
    }
    
    func printArray(){
        for item in self.arr{
            print("\(item.vocab.kanji)  \(item.vocab.region)  \(item.vocab.type)  \(item.index)")
        }
    }
}






