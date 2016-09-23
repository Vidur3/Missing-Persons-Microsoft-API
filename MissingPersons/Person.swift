//
//  Person.swift
//  MissingPersons
//
//  Created by Vidur Singh on 30/08/16.
//  Copyright © 2016 Vidur Singh. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    
    var faceId: String?
    var personImg: UIImage?
    var personImgUrl: String?
    
    init(personImageUrl: String) {
        
        self.personImgUrl = personImageUrl
    }
    
    func downloadFaceId() {
        
        if let image = personImg, let imgData = UIImageJPEGRepresentation(image, 0.8) {
            
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                
                if err == nil {
                    
                    var faceId: String?
                    for face in faces {
                       
                        faceId = face.faceId
                        print("FaceId: \(faceId)")
                        break
                    }
                    
                    self.faceId = faceId
                    
                }
                
            })
        }
        
        
    }
    
}
