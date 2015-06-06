//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Petrik on 05/06/15.
//  Copyright (c) 2015 Peter Krajcir. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    
    var receivedAudio : RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        playSoundAtRate(0.5)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playSoundAtRate(2.0)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        killSound()
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbSound(sender: UIButton) {
        killSound()
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 75

        attachEffectAndPlay(reverbEffect)
    }
    
    @IBAction func playEchoSound(sender: UIButton) {
        killSound()
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.2

        attachEffectAndPlay(echoEffect)
    }
    
    // custom function that attaches AVAudioUnitEffect instance to audioEngine
    func attachEffectAndPlay(effect:AVAudioUnitEffect) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func killSound() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playSoundAtRate(rate : Float) {
        killSound()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        killSound()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
