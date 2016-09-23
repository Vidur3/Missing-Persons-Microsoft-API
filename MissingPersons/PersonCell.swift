//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Vidur Singh on 28/08/16.
//  Copyright © 2016 Vidur Singh. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    

    @IBOutlet weak var personImg: UIImageView!
    
    var person: Person!
    var count: Int = 0
    
    func configureCell(person: Person) {
        self.person = person
        
        if let url = NSURL(string: "\(baseURL)\(person.personImgUrl!)") {
            
            downloadImage(url)
            
        }
        
        
        
        
    }
    
    func downloadImage(url: NSURL) {
        
        getDataFromUrl(url) { (data, response, err) in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
               guard let data = data where err == nil else { return }
               self.personImg.image = UIImage(data: data)
               self.person.personImg = self.personImg.image
               
            }
            
            
        }
        
        
    }
    
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, err: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data,response,error) in
            
            completion(data: data, response: response, err: error)
            
        }.resume()
        
    }
    
    func setSelectedImage() {
        
        personImg.layer.borderWidth = 2.0
        personImg.layer.borderColor = UIColor.blueColor().CGColor
        
        self.person.downloadFaceId()
   }
    
    
    
    
}
