//
//  ViewController.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Tyler Gonzalez on 11/27/20.
//

import UIKit
import CoreData
import AVFoundation

class HomeViewController: UIViewController {
    // Global Variables
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ShowerTimeRemaining: UILabel!
    @IBOutlet weak var DailyWaterSaved: UILabel!
    @IBOutlet weak var TotalWaterSaved: UILabel!
    @IBOutlet weak var LengthOfShower: UILabel!
    
    var player: AVAudioPlayer!
    var newShower: Shower? = nil
    var showerArray = [Shower]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var seconds: Int = 420
    var desiredShowerLength: Int = 420
    var timer: Timer? = nil
    var timeString: String = "7:00" {
        didSet {
            ShowerTimeRemaining.text = "\(timeString)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDate()
        timeString = setTime(withSeconds: seconds)
        LengthOfShower.text = ""
        DailyWaterSaved.text = ""
        loadShowers()
        if showerArray.count == 0 {
            TotalWaterSaved.text = "0 gallons"
        }
        else {
            TotalWaterSaved.text = String(format: "%.2f gallons", showerArray[0].totalWaterSaved)
        }
    }
    
    /*
     Function to set the date Label's text
     */
    func setDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateLabel.text = dateFormatter.string(from: date)
    }
    
    /*
     Function to toggle the Play/Pause button
     */
    @IBAction func PlayPauseButtonPressed(_ sender: Any) {
        print("play/pause pressed")
        if timer == nil {
            startTimer()
        }
        else
        {
            stopTimer()
        }
    }
    
    /*
     Event handler when the reset button is pressed
     */
    @IBAction func ResetButtonPressed(_ sender: Any) {
        print("reset button pressed")
        reset()
    }
    
    /*
     Function that resets the UILabel text
     */
    func reset() {
        if timer != nil
        {
            stopTimer()
        }
        timeString = setTime(withSeconds: desiredShowerLength)
        seconds = desiredShowerLength
        LengthOfShower.text = ""
        DailyWaterSaved.text = ""
    }
    
    /*
     Event handler for when the save button is pressed
     */
    @IBAction func SaveButtonPressed(_ sender: Any) {
        print("saved pressed")
        loadShowers() // need to reload to resort array
        if timer != nil
        {
            stopTimer()
        }
        let saveAlert = UIAlertController(title: "Shower Finished", message: "Would you like to save this shower?", preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            // use 480 seconds because 8 minutes is average shower length
            let waterSaved = (Double(480 - (self.desiredShowerLength - self.seconds)) / 60) * 2.5
            self.DailyWaterSaved.text = String(format: "%.2f gallons", waterSaved)
            self.LengthOfShower.text = self.setTime(withSeconds: self.desiredShowerLength - self.seconds)
            
            // create new shower object and append to array of showers
            let newShower = Shower(context: self.context)
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            newShower.date = date
            newShower.time = self.setTime(withSeconds: self.desiredShowerLength - self.seconds)
            newShower.waterSaved = waterSaved
            
            print(self.showerArray)
            // total water
            
            if self.showerArray.isEmpty {
                print("EMPTY")
                newShower.totalWaterSaved = waterSaved
            }
            else {
                print("NOT EMPTY")
                newShower.totalWaterSaved = waterSaved + self.showerArray[0].totalWaterSaved
            }
            
            self.showerArray.append(newShower)
            // used to pass data to history VC
            let barViewControllers = self.tabBarController?.viewControllers
            let secondVC = barViewControllers![1] as! HistoryViewController
            secondVC.showerArray = self.showerArray
            secondVC.loadShowers()
        
    
            self.TotalWaterSaved.text = String(format: "%.2f gallons", newShower.totalWaterSaved)
            // save
            self.saveShower()
        }))
        saveAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            self.reset()
        }))
        present(saveAlert, animated: true, completion: { () -> Void in
            print("save alert just presented")
        })
    }
    
    /*
     Event handler that increments/decrements the time
     */
    @IBAction func TimeStepperChanged(_ sender: UIStepper) {
        sender.minimumValue = 180
        sender.maximumValue = 900
        sender.wraps = false
        sender.autorepeat = true
        desiredShowerLength = Int(sender.value)
        seconds = Int(sender.value)
        timeString = setTime(withSeconds: seconds)
    }
    
    /*
     Function to start the timer/deal with special cases
     */
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] (timer) in
            self.seconds -= 1
            if self.seconds == 60 {
                self.playSound(with: "onemin")
                print("sound playing")
            }
            if self.seconds == 00 || self.seconds == 0 {
                print("Times up")
                stopTimer()
                let saveAlert = UIAlertController(title: "Shower Finished", message: "Would you like to save this shower?", preferredStyle: .alert)
                saveAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                    // use 480 seconds because 8 minutes is average shower length
                    let waterSaved = (Double(480 - (self.desiredShowerLength - self.seconds)) / 60) * 2.5
                    self.DailyWaterSaved.text = String(format: "%.2f gallons", waterSaved)
                    self.LengthOfShower.text = self.setTime(withSeconds: self.desiredShowerLength - self.seconds)
                    
                    // create new shower object and append to array of showers
                    let newShower = Shower(context: self.context)
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    newShower.date = date
                    newShower.time = self.setTime(withSeconds: self.desiredShowerLength - self.seconds)
                    newShower.waterSaved = waterSaved
                    // self.showerArray.insert(newShower, at: 0)
                    self.showerArray.append(newShower)
                    print(self.showerArray)
                    // used to pass data to history VC
                    let barViewControllers = self.tabBarController?.viewControllers
                    let secondVC = barViewControllers![1] as! HistoryViewController
                    secondVC.showerArray = self.showerArray
                    secondVC.loadShowers()
                    // save
                    self.saveShower()
                }))
                saveAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                    self.reset()
                }))
                present(saveAlert, animated: true, completion: { () -> Void in
                    print("save alert just presented")
                })
            }
            self.timeString = self.setTime(withSeconds: self.seconds)
        })
    }
    
    /*
     Function to stop the timer
     */
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /*
     Function to set the time
     */
    func setTime(withSeconds seconds: Int) -> String {
        if seconds >= 0 {
            let second = seconds % 60
            let minute = (seconds / 60) % 60
            let time = "\(minute):" + String(format: "%02d", second)
            return time
        }
        let second = -(seconds % 60)
        let minute = -(seconds / 60) % 60
        let time = "-\(minute):" + String(format: "%02d", second)
        return time
    }
    
    /*
     Function to attempt to save a shower instance
     */
    func saveShower() {
        do {
            try context.save()
        }
        catch {
            print("Error saving showers \(error)")
        }
    }
    
    /*
     Function to play an audio file given a name for the file
     */
    func playSound(with name: String) {
        let path = Bundle.main.path(forResource: name, ofType: "wav")!
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.play()
        }
        catch {
            print("Audio file cannot be found")
        }
    }
    
    func loadShowers() {
        let request: NSFetchRequest<Shower> = Shower.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                request.sortDescriptors = [sortDescriptor]
        do {
            showerArray = try context.fetch(request)
        }
        catch {
            print("Error loading showers \(error)")
        }
    }
}

