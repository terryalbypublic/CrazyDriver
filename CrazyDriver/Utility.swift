//
//  Utility.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 25/11/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class Utility: NSObject {
    
    public static func timeFormatted(totalMilliseconds: Int) -> String {
        let totalSeconds = totalMilliseconds / 1000;
        let tenths: Int = (totalMilliseconds / 100) % 10
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }

}
