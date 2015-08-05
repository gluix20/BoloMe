//
//  ViewController.swift
//  DrunkMe
//
//  Created by Luis Cordon on 23/07/15.
//  Copyright (c) 2015 Genz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stop: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        record.enabled = true
        recordLabel.hidden = true
        stop.hidden = true
    }
    

    @IBAction func recordSound(sender: UIButton) {
        record.enabled = false
        recordLabel.hidden = false
        stop.hidden = false
        
        println("RecordAudiooo")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
    }

    @IBAction func stopSound(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        self.performSegueWithIdentifier("stopRecording", sender : recordedAudio)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC : DrunkViewController = segue.destinationViewController as! DrunkViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
}

