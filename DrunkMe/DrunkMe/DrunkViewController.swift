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
    
    var buffer : AVAudioPCMBuffer!
    var buffer2 : AVAudioPCMBuffer!
    
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
        
        buffer = AVAudioPCMBuffer(PCMFormat: audioPlayerNode.outputFormatForBus(0), frameCapacity: 100)
        buffer.frameLength = 100
        
        audioEngine.mainMixerNode
        var mainMixer : AVAudioMixerNode = audioEngine.mainMixerNode
        
        
        
        var changePitchEffect = AVAudioUnitTimePitch()
        //changePitchEffect.rate = 1.4
        audioEngine.attachNode(changePitchEffect)
        
        
        audioEngine.connect(changePitchEffect, to: mainMixer, format: buffer.format)

        var mixerOutputFilePlayer = AVAudioPlayerNode()
        audioEngine.attachNode(mixerOutputFilePlayer)
        
        
        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: buffer.format)
        audioEngine.connect(changePitchEffect, to: mainMixer, format: buffer.format)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {self.finLoop = false})
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        /*
        var mainMixer : AVAudioMixerNode = audioEngine.mainMixerNode
        var mixerOutputFile : AVAudioFile = AVAudioFile(forWriting: <#NSURL!#>, settings: <#[NSObject : AnyObject]!#>, error: <#NSErrorPointer#>)
        */
        
        println(audioEngine.running)
        
        startRecording()
        
        
        var f : Float = 0.6
        var bajando : Float = -1
//        let duration = Int(audioPlayer.duration)*10
        finLoop = true
        
        
            while finLoop {
                
                f += (0.08*bajando)
                f=slider.value
                //audioPlayerNode.rate = f
                
                changePitchEffect.rate = f
                if f <= 0.45
                {
                    bajando = 1
                    println("subiendo")
                    usleep(300000)
                }
                
                if f >= 0.7
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
        sleep(2)
        
        
        
        stopRecording()
        
        audioPlayerNode.stop()
        
        
        
        
        
        

        
        
    }
    
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_output.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        
        var mainMixer : AVAudioMixerNode  = audioEngine.mainMixerNode
        
    
        
        var error: NSError?
        var output : AVAudioFile = AVAudioFile(forWriting: filePath, settings: mainMixer.outputFormatForBus(0 as AVAudioNodeBus).settings, error: &error)
        
        mainMixer.installTapOnBus(0, bufferSize: 4096, format: mainMixer.outputFormatForBus(0 as AVAudioNodeBus)) { (buffer:AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                output.writeFromBuffer(buffer, error: &error)
                if error != nil{
                    println(error)
                    return
                }
            }
        
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
