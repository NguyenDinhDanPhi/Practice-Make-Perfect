//
//  AudioPlayService.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 17/02/2025.
//

import AVFoundation
protocol AudioPlayService {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayService {
    private var player: AVAudioPlayer?
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try  AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let err) {
            print("error \(err.localizedDescription)")
        }
    }
    
    
}
