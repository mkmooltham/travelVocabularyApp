//
//  vocabTableViewCell.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit
import AVFoundation

class vocabTableViewCell: UITableViewCell {
    
    let  synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var column1: UILabel!
    @IBOutlet weak var pronunciation: UIButton!
    
    @IBAction func tapForSound(_ sender: Any) {
        //text to speech
        let  utterace = AVSpeechUtterance(string: (pronunciation.titleLabel?.text)!)
        utterace.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        if((pronunciation.titleLabel?.text)!.characters.count>9){
            utterace.rate = 0.3
        }else{
            utterace.rate = 0.4
        }
        
        
        
        synthesizer.speak(utterace)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
