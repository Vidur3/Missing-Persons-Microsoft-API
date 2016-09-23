//
//  FaceService.swift
//  MissingPersons
//
//  Created by Vidur Singh on 30/08/16.
//  Copyright © 2016 Vidur Singh. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "d3335b4e47e04790aa59ac35dec17397")
    
    

    
}
