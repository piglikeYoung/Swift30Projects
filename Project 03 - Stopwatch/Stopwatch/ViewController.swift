//
//  ViewController.swift
//  Stopwatch
//
//  Created by pike young on 2017/7/26.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    static let identifier = "lapCell"
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapRestButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    fileprivate let mainStopwatch: Stopwatch = Stopwatch()
    fileprivate let lapStopwatch: Stopwatch = Stopwatch()
    fileprivate var isPlay: Bool = false
    fileprivate var laps: [String] = []
    
    // MARK: disable landscape mode
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: hide status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCircleButton(playPauseButton)
        initCircleButton(lapRestButton)
        
        lapRestButton.isEnabled = false
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
    }

    fileprivate func initCircleButton(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.yellow
    }
    
    // MARK: play, pause, lap, and reset
    @IBAction func playPauseTimer(_ sender: Any) {
        lapRestButton.isEnabled = true
        changeButton(lapRestButton, title: "Lap", titleColor: UIColor.black)
        if !isPlay {
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: .commonModes)
            RunLoop.current.add(lapStopwatch.timer, forMode: .commonModes)
            
            isPlay = true
            changeButton(playPauseButton, title: "Stop", titleColor: UIColor.red)
        } else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, title: "Start", titleColor: UIColor.green)
            changeButton(lapRestButton, title: "Reset", titleColor: UIColor.black)
        }
    }
    
    @IBAction func lapResetTimer(_ sender: Any) {
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapRestButton, title: "Lap", titleColor: UIColor.lightGray)
            lapRestButton.isEnabled = false
        } else {
            if let timerLabelText = timerLabel.text {
                laps.append(timerLabelText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: .commonModes)
        }
    }
    
    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
    }
    
    // MARK: reset timer seperately
    fileprivate func resetMainTimer() {
        resetTimer(mainStopwatch, label: timerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    
    fileprivate func resetLapTimer() {
        resetTimer(lapStopwatch, label: lapTimerLabel)
    }
    
    fileprivate func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    // MARK: update two timer labels seperately
    func updateMainTimer() {
        updateTimer(mainStopwatch, label: timerLabel)
    }
    
    func updateLapTimer() {
        updateTimer(lapStopwatch, label: lapTimerLabel)
    }
    
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", stopwatch.counter.truncatingRemainder(dividingBy: 60))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier, for: indexPath)
        if let labelNum = cell.viewWithTag(11) as? UILabel {
            labelNum.text = "Lap \(laps.count - indexPath.row)"
        }
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
            labelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        
        return cell
    }
}

fileprivate extension Selector {
    static let updateMainTimer = #selector(ViewController.updateMainTimer)
    static let updateLapTimer = #selector(ViewController.updateLapTimer)
}

