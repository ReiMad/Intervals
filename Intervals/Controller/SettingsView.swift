//
//  ViewController.swift
//  Intervals
//
//  Created by Ramón Madrid on 15/09/20.
//  Copyright © 2020 Ramón Madrid. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {

    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var workoutSlider: UISlider!
    @IBOutlet weak var breakSlider: UISlider!
    @IBOutlet weak var intervalsLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var startButton: UIButton!
    
    
    var timerManager = TimerManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 4
        loadUserPreferences()
    }

    
    // MARK: - User set parameters
    @IBAction func workoutTimeChanged(_ sender: UISlider) {
        workoutTimeLabel.text = timerManager.setWorkoutTime(time: Int(sender.value))
    }
    
    @IBAction func breakTimeChanged(_ sender: UISlider) {
        breakTimeLabel.text = timerManager.setBreakTime(time: Int(sender.value))
    }
    
    @IBAction func intervalsStepperTapped(_ sender: UIStepper) {
        intervalsLabel.text = timerManager.updateIntervals(sender.value)
    }
    
    
    // MARK: - Button and segue
    @IBAction func startBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.timerViewSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.timerViewSegue {
            let timerView = segue.destination as! TimerView
            timerView.timerManager = timerManager
        }
    }
    
    // MARK: - Load user preferences function
    func loadUserPreferences() {
        if timerManager.defaults.object(forKey: K.appFirstBoot) != nil {
            //Sliders values
            workoutSlider.value = timerManager.defaults.float(forKey: K.Activities.workout)
            breakSlider.value = timerManager.defaults.float(forKey: K.Activities.breakTime)
            //Labels text
            workoutTimeLabel.text = timerManager.setWorkoutTime(time: timerManager.defaults.integer(forKey: K.Activities.workout))
            breakTimeLabel.text = timerManager.setBreakTime(time: timerManager.defaults.integer(forKey: K.Activities.breakTime))
            intervalsLabel.text = timerManager.updateIntervals(timerManager.defaults.double(forKey: K.intervals))
        } else {
            workoutSlider.value = 90
            breakSlider.value = 90
            workoutTimeLabel.text = timerManager.setWorkoutTime(time: Int(workoutSlider.value))
            breakTimeLabel.text = timerManager.setBreakTime(time: Int(breakSlider.value))
            intervalsLabel.text = timerManager.updateIntervals(Double(timerManager.totalOfIntervals))
            timerManager.defaults.setValue(true, forKey: K.appFirstBoot)
        }
    }
}

