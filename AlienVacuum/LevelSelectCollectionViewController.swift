//
//  LevelSelectCollectionViewController.swift
//  AlienVacuum
//
//  Created by Guilherme on 25/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import UIKit

private let reuseIdentifier = "levelCell"

class LevelSelectCollectionViewController: UICollectionViewController {
    
    var levelCounter: Int!//quantity of levels
    let playerHelper = Player_Manager.sharedInstance

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.window?.rootViewController = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //read number of levels
        let filePath = NSBundle.mainBundle().pathForResource("LevelHelper", ofType:"txt")
        let fileContent = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        
        levelCounter = Int((fileContent! as NSString).intValue)
        
        Sound_Manager.sharedInstance.checkIfPlayingTitle()
        
        let starData = NSUserDefaults.standardUserDefaults().objectForKey("stars") as? NSData
        
        if starData != nil{
            if let data = starData {
                let starsArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Int]
                playerHelper.starsPerLevel = starsArray!
              
                collectionView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationViewController = segue.destinationViewController as? GameViewController, selectedIndex = collectionView?.indexPathsForSelectedItems()?.first {
            
            destinationViewController.levelSelected = selectedIndex.row
        }
        
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return levelCounter
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LevelSelectCollectionViewCell
        
        cell.levelSelectImageView.image = UIImage(named: "level\(indexPath.row)")
        cell.levelSelectLabel.text = "Level \(indexPath.row + 1)"
        
        switch playerHelper.starsPerLevel[indexPath.row] {
        case 1:
            cell.starsImageView.image = UIImage(named: "Estrelas100")
        case 2:
            cell.starsImageView.image = UIImage(named: "Estrelas110")
        case 3:
            cell.starsImageView.image = UIImage(named: "Estrelas111")
        default:
            cell.starsImageView.image = UIImage(named: "Estrelas000")

        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "LevelHeaderView", forIndexPath: indexPath) as! LevelSelectCollectionReusableView
        
        //headerView.levelSelect.text = "Seleção de nível"
        
        return headerView
        
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

