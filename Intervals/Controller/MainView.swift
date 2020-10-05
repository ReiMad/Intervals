//
//  ViewController.swift
//  Intervals
//
//  Created by Ramón Madrid on 15/09/20.
//  Copyright © 2020 Ramón Madrid. All rights reserved.
//

import UIKit

class MainView: UIViewController {

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
        if UserDefaults.standard.object(forKey: K.Activities.workout) == nil {
            workoutSlider.value = 90
            breakSlider.value = 90
            workoutTimeLabel.text = timerManager.setWorkoutTime(time: Int(workoutSlider.value))
            breakTimeLabel.text = timerManager.setBreakTime(time: Int(breakSlider.value))
            timerManager.defaults.setValue(true, forKey: "firstAppBoot")
        } else {
            //Loads User Defaults
                //workout time & label data
            workoutSlider.value = UserDefaults.standard.float(forKey: K.Activities.workout)
            workoutTimeLabel.text = timerManager.returnTimeString(for: UserDefaults.standard.integer(forKey: K.Activities.workout))
                //break time & label data
            breakSlider.value = UserDefaults.standard.float(forKey: K.Activities.breakTime)
            breakTimeLabel.text = timerManager.returnTimeString(for: UserDefaults.standard.integer(forKey: K.Activities.breakTime))
                //Intervals data
            stepper.value = UserDefaults.standard.double(forKey: "intervals")
            intervalsLabel.text = UserDefaults.standard.string(forKey: "intervals")
        }
        
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
}

