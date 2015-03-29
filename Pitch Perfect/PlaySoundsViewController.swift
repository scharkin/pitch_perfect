//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sergey Charkin on 12/25/14.
//  Copyright (c) 2014 Fun with App. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!

    var file: AVAudioFile!
    var engine: AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var url = NSURL.fileURLWithPath(path)
//            audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
//            audioPlayer.enableRate = true
//            file = AVAudioFile(forReading: url, error: nil)
//        } else {
//            println("ERROR: No audio file")
//        }
        var url = receivedAudio.filePathUrl
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        audioPlayer.enableRate = true
        file = AVAudioFile(forReading: url, error: nil)
        engine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func playAudio(speed: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudio(0.5)
    }

    @IBAction func playFastAudio(sender: AnyObject) {
        playAudio(2)
    }

    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playEffect(1000) // +10 semitone
    }
    
    @IBAction func playDarthVader(sender: AnyObject) {
        playEffect(-800) // -10 semitone
    }

    func playEffect(pitch: Float) {
        audioPlayer.stop()
        engine.stop()
        engine.reset()

        let player = AVAudioPlayerNode()
        engine.attachNode(player)

        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        engine.attachNode(pitchEffect)

        engine.connect(player, to: pitchEffect, format: file.processingFormat)
        engine.connect(pitchEffect, to: engine.mainMixerNode, format: file.processingFormat)

        player.scheduleFile(file, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)

        player.play()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        engine.stop()
    }
}
