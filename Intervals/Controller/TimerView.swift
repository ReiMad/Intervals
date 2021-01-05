//
//  TimerViewController.swift
//  Intervals
//
//  Created by Ramón Madrid on 15/09/20.
//  Copyright © 2020 Ramón Madrid. All rights reserved.
//

import UIKit
import AVFoundation

class TimerView: UIViewController {

    @IBOutlet weak var intervalsLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!

    
    var timerManager: TimerManager?
    let animatedLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    var ringHasBeenDrawn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeTimerManager = timerManager {
            safeTimerManager.delegate = self
            intervalsLabel.text = "\(safeTimerManager.currentInterval) / \(safeTimerManager.totalOfIntervals)"
            activityLabel.text = safeTimerManager.currentActivity
            pauseBtn.layer.cornerRadius = 4
            
            if let warmUptimer = safeTimerManager.timers[K.Activities.getReady] {
                safeTimerManager.starTimer(time: warmUptimer)
            }
        } 
    }
    
    //Draw the progress ring
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if ringHasBeenDrawn {
            return
        } else {
            drawRing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ringHasBeenDrawn = true
    }
    

    func drawRing() {
        let center = CGPoint(x: progressView.frame.width/2, y: progressView.frame.height/2)
        let frameWidth = progressView.frame.width
        let frameHeight = progressView.frame.height
        var radius: CGFloat {
            if frameWidth < frameHeight {
                return (frameWidth / 2) - 20
            } else {
                return (frameHeight / 2) - 20
            }
        }
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        //Circular track layer
        tracklayer.path = circularPath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = UIColor(named: "TrackColor")?.cgColor
        tracklayer.lineWidth = 10
        tracklayer.position = center
        
        //Animated progress layer.
        animatedLayer.path = circularPath.cgPath
        animatedLayer.fillColor = UIColor.clear.cgColor
        animatedLayer.strokeColor = UIColor(named: "RedApp")?.cgColor
        animatedLayer.lineWidth = 10
        animatedLayer.lineCap = .round
        animatedLayer.strokeEnd = 0
        animatedLayer.position = center
        animatedLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        progressView.layer.addSublayer(tracklayer)
        progressView.layer.addSublayer(animatedLayer)
    }
    
    @IBAction func pauseBtnTapped(_ sender: UIButton) {
        if let safeTimerManager = timerManager {
            if safeTimerManager.timer.isValid {
                safeTimerManager.timer.invalidate()
                pauseBtn.setTitle("Resume", for: .normal)
            } else {
                safeTimerManager.resumeTimer(time: safeTimerManager.currentTime)
                pauseBtn.setTitle("Pause", for: .normal)
            }
        }
        
        if stopBtn.isEnabled {
            stopBtn.isEnabled = false
        } else {
            stopBtn.isEnabled = true
        }
    }
    
    @IBAction func stopBtnTapped(_ sender: UIButton) {
        if let safeTimerManager = timerManager {
            safeTimerManager.timer.invalidate()
            safeTimerManager.resetTimerParameters()
            safeTimerManager.player?.stop()
        }
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: - TimerManagerDelegate
extension TimerView: TimerManagerDelegate {
    func updateRingProgress(currentTime: String, ringProgress: CGFloat) {
        timerLabel.text = currentTime
        animatedLayer.strokeEnd = ringProgress
    }
    
    func updateIntervals() {
        if let safeTimerManager = timerManager {
            intervalsLabel.text = "\(safeTimerManager.currentInterval) / \(safeTimerManager.totalOfIntervals)"
        }
    }
    
    func updateCurrentActivity() {
        activityLabel.text = timerManager?.currentActivityDescription
        if activityLabel.text == K.ActivityMessages.workoutDone {
            pauseBtn.isEnabled = false
            pauseBtn.alpha = 0.5
            stopBtn.setTitle("Close", for: .normal)
            stopBtn.isEnabled = true
        }
    }
}
