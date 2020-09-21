//
//  TimerBrain.swift
//  HIIT it up
//
//  Created by Ramón Madrid on 10/06/20.
//  Copyright © 2020 Ramón Madrid. All rights reserved.
//

import UIKit
import AVFoundation

protocol TimerManagerDelegate {
    func updateIntervals()
    func updateCurrentActivity()
    func updateRingProgress(currentTime: String, ringProgress: CGFloat)
}


class TimerManager {
    var delegate: TimerManagerDelegate?
    var timer = Timer()
    
    var currentInterval: Int = 1
    var totalOfIntervals: Int = 1
    var currentActivity: String = K.Activities.getReady
    var currentActivityDescription: String = K.ActivityMessages.getReady
    
    //Times for timers
    var timers: [String: Double] = [
        K.Activities.getReady: 10,
        K.Activities.workout: 90,
        K.Activities.breakTime: 90
    ]
    
    //Timer Progress
    let timeInterval: Double = 0.05
    var currentTime: Double = 0
    var percentageProgress: Double = 0
   
    func starTimer(time : Double) {
        percentageProgress = 0
        delegate?.updateCurrentActivity()
        currentTime = time + 1
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(countDownTimerProgress), userInfo: nil, repeats: true)
    }
    
    func resumeTimer(time: Double) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(countDownTimerProgress), userInfo: nil, repeats: true)
    }
    
    
    @objc func countDownTimerProgress() {
        if currentTime < 1 + timeInterval {
            timer.invalidate()
            percentageProgress = 0
            if let nextTimer = startNextTimer(with: currentActivity) {
                starTimer(time: nextTimer)
            }
            //Resetting soundsPlayed values to false
            for (key, _) in soundsPlayed {
                soundsPlayed[key] = false
            }
            
        } else {
            currentTime -= timeInterval
            percentageProgress += timeInterval
            var ringProgress: CGFloat{
                let totalTime = CGFloat(timers[currentActivity]!)
                let currentTime = CGFloat(percentageProgress)
                let currentProgress = currentTime / totalTime
                return currentProgress
            }
            //Update Countdown & ring progress
            var currentTimeString: String {
                let timeWhitNoDecimal = Int(currentTime)
                return returnTimeString(for: timeWhitNoDecimal)
            }
            shouldPlayCountDownSound(currentTime: currentTimeString)
            delegate?.updateRingProgress(currentTime: currentTimeString, ringProgress: ringProgress)
        }
    }
    
    
    
        //The first time this runs is once the warm up is done.
    func startNextTimer(with activity: String) -> Double? {
        let previousActivity = activity
        var nextActivity: String
        var intervalsCompleted: Bool {
            if currentInterval == totalOfIntervals {
                return true
            } else {
                return false
            }
        }

        switch previousActivity {
        case K.Activities.getReady :
            playSound(sound: K.Sounds.CountDown.ping1)
            nextActivity = K.Activities.workout
            currentActivity = nextActivity
            currentActivityDescription = K.ActivityMessages.workout
            let newTimer = timers[nextActivity]!
            return newTimer

        case K.Activities.workout:
            if intervalsCompleted {
                //The timer ends here!
                currentActivityDescription = K.ActivityMessages.workoutDone
                delegate?.updateCurrentActivity()
                delegate?.updateRingProgress(currentTime: "Done", ringProgress: 1)
                playSound(sound: K.Sounds.Done.done2)
                resetTimerParameters()
                return nil
            } else {
                playSound(sound: K.Sounds.CountDown.ping1)
                nextActivity = K.Activities.breakTime
                currentActivity = nextActivity
                currentActivityDescription = K.ActivityMessages.breakTime
                let newTimer = timers[nextActivity]!
                return newTimer
            }

        case K.Activities.breakTime:
            playSound(sound: K.Sounds.CountDown.ping1)
            currentInterval += 1
            delegate?.updateIntervals()
            nextActivity = K.Activities.workout
            currentActivity = nextActivity
            currentActivityDescription = K.ActivityMessages.workout
            let newTimer = timers[nextActivity]!
            return newTimer

        default:
            print("Something went wrong")
            timer.invalidate()
            resetTimerParameters()
            return nil
        }
    }
    
    func resetTimerParameters() {
        currentActivity = K.Activities.getReady
        currentActivityDescription = K.ActivityMessages.getReady
        currentTime = 0
        percentageProgress = 0
        currentInterval = 1
        for (key, _) in soundsPlayed {
            soundsPlayed[key] = false
        }
    }
    
    
    
    //Functions executed from the main view
    func setWorkoutTime(time: Int) -> String {
        timers[K.Activities.workout] = Double(time)
        return returnTimeString(for: time)
    }
    
    func setBreakTime(time: Int) -> String {
        timers[K.Activities.breakTime] = Double(time)
        return returnTimeString(for: time)
    }
    
    func updateIntervals(_ intervals: Double) -> String {
        totalOfIntervals = Int(intervals)
        let intervalString = String(totalOfIntervals)
        return intervalString
    }
    
    func returnTimeString(for time: Int) -> String {
        switch time {
        case 60..<120:
            if time < 70 {
                return "01:0\(time - 60)"
            } else {
                return "01:\(time - 60)"
            }
        case 120..<180:
            if time < 130 {
                return "02:0\(time - 120)"
            } else {
               return "02:\(time - 120)"
            }
        case 180:
            return "03:00"
        default:
            return "\(time)"
        }
    }
    
    
    //Sound functions
    var player: AVAudioPlayer?
    func playSound(sound: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var soundsPlayed: [Int:Bool] = [
        3: false,
        2: false,
        1: false
    ]
    
    func shouldPlayCountDownSound(currentTime: String) {
        switch currentTime {
        case "3":
            if soundsPlayed[3]! == false {
                playSound(sound: K.Sounds.CountDown.ping2)
                soundsPlayed[3] = true
            }
        case "2":
            if soundsPlayed[2]! == false {
                playSound(sound: K.Sounds.CountDown.ping2)
                soundsPlayed[2] = true
            }
        case "1":
            if soundsPlayed[1]! == false {
                playSound(sound: K.Sounds.CountDown.ping2)
                soundsPlayed[1] = true
            }
        default:
            return
        }
    }

}
