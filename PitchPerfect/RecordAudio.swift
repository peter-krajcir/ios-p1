//
//  RecordAudio.swift
//  PitchPerfect
//
//  Created by Petrik on 06/06/15.
//  Copyright (c) 2015 Peter Krajcir. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl : NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}