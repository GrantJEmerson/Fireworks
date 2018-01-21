//
//  FireworksScene.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import AVKit
import SpriteKit
import GameplayKit

public protocol FireworksSceneDelegate: class {
    var fireworksColor: UIColor? { get }
}

class FireworksScene: SKScene {
    
    // MARK: Properties
    
    public weak var fireworksDelegate: FireworksSceneDelegate?
    
    private var sparkEmitterNodes = [UITouch: SKEmitterNode]()
    
    private let sparkAudioFile: AVAudioFile = {
        // I am using force unwrap due to my certainty of the file existing
        let urlString = Bundle.main.path(forResource: "SizzlingSparkSound", ofType: "wav")!
        return try! AVAudioFile(forReading: URL(string: urlString)!)
    }()
    
    private lazy var sparkSoundPlayer: AVAudioPlayerNode = {
        let sparkSoundPlayer = AVAudioPlayerNode()
        sparkSoundPlayer.volume = 0.45
        
        let buffer = AVAudioPCMBuffer(pcmFormat: sparkAudioFile.processingFormat,
                                      frameCapacity: AVAudioFrameCount(sparkAudioFile.length))
        do {
            try sparkAudioFile.read(into: buffer!)
            audioEngine.attach(sparkSoundPlayer)
            audioEngine.connect(sparkSoundPlayer, to: audioEngine.mainMixerNode, format: buffer?.format)
            sparkSoundPlayer.scheduleBuffer(buffer!, at: nil, options: .loops)
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
        
        return sparkSoundPlayer
    }()

    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .black
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let sparkEmitterNode = SKEmitterNode(fileNamed: "SparkEmitter")
            addChild(sparkEmitterNode!)
            sparkEmitterNode?.particlePosition = touchLocation
            sparkSoundPlayer.play()
            sparkEmitterNodes[touch] = sparkEmitterNode
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let sparkEmitterNode = sparkEmitterNodes[touch] else { continue }
            sparkEmitterNode.particlePosition = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            guard let sparkEmitterNode = sparkEmitterNodes[touch] else { continue }
            sparkEmitterNode.removeAllActions()
            sparkEmitterNode.removeFromParent()
            sparkEmitterNodes.removeValue(forKey: touch)
            let touchLocation = touch.location(in: self)
            explodeFirework(at: touchLocation)
        }
        guard sparkEmitterNodes.isEmpty else { return }
        sparkSoundPlayer.pause()
    }
    
    // MARK: Private Functions
    
    private func explodeFirework(at point: CGPoint) {
        guard let firework = SKEmitterNode(fileNamed: "Firework") else { return }
        firework.particlePosition = point
        firework.particleColorSequence = nil
        firework.particleColor = fireworksDelegate?.fireworksColor ?? .orange
        let fireworkSound = SKAction.playSoundFileNamed("FireworkSound", waitForCompletion: false)
        let fireworkSequence = SKAction.sequence([
            SKAction.run({ self.addChild(firework) }),
            SKAction.wait(forDuration: 2000),
            SKAction.run { firework.removeFromParent() }
        ])
        run(fireworkSound)
        run(fireworkSequence)
    }
}

