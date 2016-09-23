//
//  ViewController.swift
//  MissingPersons
//
//  Created by Vidur Singh on 28/08/16.
//  Copyright © 2016 Vidur Singh. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imgPicker = UIImagePickerController()
    var selectedPerson: Person?
    var hasSelectedImg: Bool = false
    
    
    
    
    let missingPersons = [
    
    Person(personImageUrl: "person1.jpg"),
    Person(personImageUrl: "person2.jpg"),
    Person(personImageUrl: "person3.jpg"),
    Person(personImageUrl: "person4.jpg"),
    Person(personImageUrl: "person5.jpg"),
    Person(personImageUrl: "person6.png")
        
        
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imgPicker.delegate = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorAlert() {
        
        let alert = UIAlertController(title: "Missing Persons", message: "Select a Missing Person for MATCH", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBAction func checkForMatch(sender: AnyObject) {
        
        if selectedPerson == nil || hasSelectedImg == false {
            
          showErrorAlert()
        } else {
            
            if let img = selectedImg.image, let data = UIImageJPEGRepresentation(img, 0.8) {
             
                FaceService.instance.client.detectWithData(data, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        
                        var faceId: String?
                        for face in faces {
                            
                            faceId = face.faceId
                            break
                        }
                        
                        if faceId != nil {
                            
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                
                                if err == nil {
                                    
                                    print(result.confidence)
                                    print(result.isIdentical)
                                    print(result.debugDescription)
                                    
                                } else {
                                    
                                    print(err.debugDescription)
                                }
                               
                            })
                        }
                        
                    }
                })
                
            }
            
            
        }
            }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return missingPersons.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPerson = missingPersons[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.configureCell(selectedPerson!)
        cell.setSelectedImage()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as? PersonCell {
            let person = missingPersons[indexPath.row]
           // let url = "\(baseURL)\(missingPersons[indexPath.row])"
            cell.configureCell(person)
            return cell
            
        } else {
            
            let cell = UICollectionViewCell()
            return cell
            
        }
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImg.image = pickedImg
            hasSelectedImg = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UIGestureRecognizer) {
        
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .PhotoLibrary
        
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    

}

