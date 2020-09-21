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
    @IBOutlet weak var startButton: UIButton!
    
    
    var timerManager = TimerManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get info for labels
        workoutSlider.value = 90
        breakSlider.value = 90
        workoutTimeLabel.text = timerManager.setWorkoutTime(time: Int(workoutSlider.value))
        breakTimeLabel.text = timerManager.setBreakTime(time: Int(breakSlider.value))
        startButton.layer.cornerRadius = 4
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

