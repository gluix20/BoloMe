//
//  DrunkViewController.swift
//  DrunkMe
//
//  Created by Luis Cordon on 23/07/15.
//  Copyright (c) 2015 Genz. All rights reserved.
//

import UIKit
import AVFoundation

class DrunkViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    var receivedAudio : RecordedAudio!
    var finLoop : Bool = false
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChange(sender: AnyObject) {
        println(slider.value)
        //audioPlayer.rate = slider.value
    }
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
        //            var filePathURL = NSURL.fileURLWithPath(filePath)
        //
        //        }
        //        else {
        //            println("The path is empty")
        //        }
        
        println(receivedAudio.filePathUrl)
        
        
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
   
    
    func startRecordingDrunk(){
        
    }
    
    @IBAction func playDrunk(sender: UIButton) {
        playAudioWithVariablePitch()
    }
    
    @IBAction func StopSounds(sender: UIButton) {
        stopButton.hidden = true
        audioEngine.stop()
    }
    
    func playAudioWithVariablePitch(){
        
        audioEngine.stop()
        //audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        //changePitchEffect.rate = 1.4
        audioEngine.attachNode(changePitchEffect)

        
        
        
        
        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {self.finLoop = false})
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        /*
        var mainMixer : AVAudioMixerNode = audioEngine.mainMixerNode
        var mixerOutputFile : AVAudioFile = AVAudioFile(forWriting: <#NSURL!#>, settings: <#[NSObject : AnyObject]!#>, error: <#NSErrorPointer#>)
        */
        
        //startRecording()
        
        
        var f : Float = 0.6
        var bajando : Float = -1
//        let duration = Int(audioPlayer.duration)*10
        finLoop = true
        
        
            while finLoop {
                
                f += (0.08*bajando)
                //audioPlayerNode.rate = f
                
                changePitchEffect.rate = f
                if f <= 0.6
                {
                    bajando = 1
                    println("subeidno")
                    usleep(300000)
                }
                
                if f >= 0.9
                {
                    bajando = -1
                    println("bjando")
                    usleep(300000)
                }
                println(f)
                usleep(100000)
                /*
                var f = Float(arc4random_uniform(300)) / 1000+0.4
                audioPlayer.rate = f
                println("\(f) ")
                sleep(2)
                */
            }
        sleep(3)
        
        //stopRecording()
        
        audioPlayerNode.stop()
        
        
        
        
        

        
        
    }
    
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_output.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        
        
        var mainMixer : AVAudioMixerNode  = audioEngine.mainMixerNode
        
        var formato: AVAudioFormat = mainMixer.outputFormatForBus(0 as AVAudioNodeBus)
        var output : AVAudioFile = AVAudioFile(forWriting: filePath, settings: nil, error: nil)
        
        mainMixer.installTapOnBus(0, bufferSize: 4096, format: formato, block: nil)
        
    }
    
    func stopRecording() {
        audioEngine.mainMixerNode.removeTapOnBus(0)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    
    
    
    
    
    */

}
