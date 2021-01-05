//
//  Constants.swift
//  Intervals
//
//  Created by Ramón Madrid on 15/09/20.
//  Copyright © 2020 Ramón Madrid. All rights reserved.
//

import Foundation

struct K {
    static let timerViewSegue = "goToTimerScreen"
    static let appFirstBoot = "firstBoot"
    static let intervals = "intervals"
    
    struct Activities {
        static let getReady = "getReady"
        static let workout = "workout"
        static let breakTime = "breakTime"
    }
    
    struct ActivityMessages {
        static let getReady = "Get Ready!"
        static let workout = "Time to Work!"
        static let breakTime = "Take a Break"
        static let workoutDone = "Good Work!"
    }
    
    struct Sounds {
        struct CountDown {
            static let ping1 = "ping1"
            static let ping2 = "ping2"
            static let ping3 = "ping3"
        }
        
        struct Done {
            static let done1 = "done1"
            static let done2 = "done2"
        }
    }
    
}
