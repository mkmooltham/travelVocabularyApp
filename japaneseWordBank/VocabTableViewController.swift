//
//  VocabTableViewController.swift
//  japaneseWordBank
//
//  Created by RAYW2 on 19/5/2017.
//  Copyright © 2017年 RAYW2. All rights reserved.
//

import UIKit

protocol VocabTableDelegate {
    func selectFilterRow()
}

class VocabTableViewController: UITableViewController, Homedelegate {
    var delegate: VocabTableDelegate!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Control function
    func changeTable(){
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredArray.arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! vocabTableViewCell
        
        cell.column1.text = filteredArray.arr[indexPath.row].vocab.kanji
        cell.pronunciation.setTitle(filteredArray.arr[indexPath.row].vocab.hiragana, for: .normal)
        cell.pronunciation.titleLabel?.adjustsFontSizeToFitWidth = true;
        cell.pronunciation.titleLabel?.minimumScaleFactor = 0.5;

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //remove in wholeArray
            wholeArray.arr.remove(at: filteredArray.arr[indexPath.row].index)
            //remove in local storage
            let userdefaults = UserDefaults.standard
            userdefaults.set(NSKeyedArchiver.archivedData(withRootObject: wholeArray), forKey: "wholeArray")
            //remove in selection
            if !wholeArray.containRegion(element: filteredArray.arr[indexPath.row].vocab.region) {
                let deleteID = selectionRegion.index(of: filteredArray.arr[indexPath.row].vocab.region)
                selectionRegion.remove(at: deleteID!)
                selectedCityID = 0
                delegate.selectFilterRow()
            }
            //remove in filteredArray
            filteredArray.update(vocabList: wholeArray, filteredByRegion: selectionRegion[selectedCityID], filteredByType: selectionType[selectedTypeID])
            changeTable()
        }
    }
}
