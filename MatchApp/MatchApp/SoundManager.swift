//
//  SoundManager.swift
//  MatchApp
//
//  Created by kayesh Abhisheka on 2023-05-07.
//

import Foundation
import AVFoundation     // Audio video related class


class SoundManager {
    
    var  audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
            case .flip:
                soundFileName = "cardFlip"
                
            case .match:
                soundFileName = "dingcorrect"
                
            case .nomatch:
                soundFileName = "dingwrong"
                
            case .shuffle:
                soundFileName = "shuffle"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")    //  Get the path to the resource
        
        //  Check that it's not nil
        guard bundlePath != nil else {
            return  //  Couldn't find the resource, exit
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)    //  Create the audio player
            audioPlayer?.play()     // Play the sound effect
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
    
    }
    
}
