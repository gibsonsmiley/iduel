//
//  SoundController.swift
//  Duellum
//
//  Created by Batman on 5/20/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

extension SystemSoundID {
    
    static func playGunShot1(fileName: String, withExtenstion fileExtenstion: String? = "mp3") {
        var gun1: SystemSoundID = 0
        if let gun1SoundUrl = NSBundle.mainBundle().URLForResource("1gunshot", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(gun1SoundUrl, &gun1)
            AudioServicesPlaySystemSound(gun1)
        }
    }
    
    static func playGunShot2(fileName: String, withExtenstion fileExtenstion: String? = "mp3") {
        var gun2: SystemSoundID = 0
        if let gun2SoundUrl = NSBundle.mainBundle().URLForResource("2gunshot", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(gun2SoundUrl, &gun2)
            AudioServicesPlaySystemSound(gun2)
        }
        
    }
    
    static func playGunCocking(fileName: String, withExtenstion fileExtenstion: String? = "mp3") {
        var gunCocking: SystemSoundID = 0
        if let gunCockingSoundUrl = NSBundle.mainBundle().URLForResource("GunCocking", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(gunCockingSoundUrl, &gunCocking)
            AudioServicesPlaySystemSound(gunCocking)
        }
        
    }
    
    // Example on how to call this anywhere in the app. 1. import AudioToolbox 2. Then write this SystemSoundId.playGunShot1("1gunshot")

}

    // To play the dueling background music just call " playDuelBackGroundMusic("_______.mp3)" or "playMainThemeBackGroundMusic(bensound-epic.mp3)"

var duelBackGroundMusic = AVAudioPlayer()

func playDuelBackGroundMusic(filename: String){
    let url = NSBundle.mainBundle().URLForResource("DuelTrack", withExtension: "mp3")
    guard let newURL = url else {
        print("could not find file: \("DuelTrack")")
        return
    }
    do {
        duelBackGroundMusic = try AVAudioPlayer(contentsOfURL: newURL)
        duelBackGroundMusic.numberOfLoops = -1
        duelBackGroundMusic.prepareToPlay()
        duelBackGroundMusic.play()
    } catch let error as NSError {
        print(error.description)
    }
}


var MainThemeBackGroundMusic = AVAudioPlayer()

func playMainThemeBackGroundMusic(filename: String){
    let url = NSBundle.mainBundle().URLForResource("DuelMenuTrack", withExtension: "mp3")
    guard let newURL = url else {
        print("could not find file: \("DuelMenuTrack")")
        return
    }
    do {
        duelBackGroundMusic = try AVAudioPlayer(contentsOfURL: newURL)
        duelBackGroundMusic.numberOfLoops = -1
        duelBackGroundMusic.prepareToPlay()
        duelBackGroundMusic.play()
    } catch let error as NSError {
        print(error.description)
    }
}










