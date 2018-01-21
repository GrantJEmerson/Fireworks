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

protocol FireworksSceneDelegate: class {
    var fireworksColor: UIColor? { get }
    var scaleFactor: CGFloat { get }
    var currentFirework: Firework? { get }
    
    func didExplodeFirework(with color: UIColor)
}

class FireworksScene: SKScene {
    
    // MARK: Properties
    
    public weak var fireworksDelegate: FireworksSceneDelegate?
    
    private var sparkFireworkShowEmitter: SKEmitterNode?
    
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
        addCloud()
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
            guard let currentFirework = fireworksDelegate?.currentFirework else { return }
            explodeFirework(currentFirework,
                            at: touchLocation,
                            withColor: fireworksDelegate?.fireworksColor ?? .orange,
                            withScaleFactor: fireworksDelegate?.scaleFactor ?? 1)
        }
        guard sparkEmitterNodes.isEmpty else { return }
        sparkSoundPlayer.pause()
    }
    
    // MARK: Private Functions
    
    private func explodeFirework(_ firework: Firework,
                                 at point: CGPoint, withColor color: UIColor,
                                 withScaleFactor scaleFactor: CGFloat) {
        guard let firework = fireworksDelegate?.currentFirework,
            let fireworkEmitter = SKEmitterNode(fileNamed: firework.name) else { return }
        fireworkEmitter.particlePosition = point
        fireworkEmitter.particleColorSequence = nil
        fireworkEmitter.particleScale *= scaleFactor
        fireworkEmitter.particleColor = color
        let fireworkSound = SKAction.playSoundFileNamed(firework.name, waitForCompletion: false)
        let fireworkSequence = SKAction.sequence([
            SKAction.run({ self.addChild(fireworkEmitter) }),
            SKAction.wait(forDuration: 2000),
            SKAction.run { fireworkEmitter.removeFromParent() }
        ])
        run(fireworkSound)
        run(fireworkSequence)
        fireworksDelegate?.didExplodeFirework(with: color)
    }
    
    private func addCloud() {
        let cloud = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "CloudIcon")), size: CGSize(width: 50, height: 50))
        let blurEffect = SKEffectNode()
        blurEffect.shouldRasterize = true
        blurEffect.addChild(SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "CloudIcon")), size: CGSize(width: 40, height: 40)))
        blurEffect.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius" : 20])
        cloud.addChild(blurEffect)
        let swayAction =
            SKAction.sequence([
                SKAction.moveBy(x: 10, y: 0, duration: 2),
                SKAction.moveBy(x: -10, y: 0, duration: 2)
            ]).repeated()
        addChild(cloud)
        cloud.position = CGPoint(x: 50, y: frame.maxY - 50)
        cloud.run(swayAction)
    }
    
    // MARK: Public Functions
    
    public func startFireworkShow() {
        let waitAction = SKAction.wait(forDuration: Double(arc4random_uniform(300))/100)
        let addAction = SKAction.run { [weak self] in
            guard let `self` = self else { return }
            let sparkEmitterNode = SKEmitterNode(fileNamed: "SparkEmitter")
            self.addChild(sparkEmitterNode!)
            sparkEmitterNode?.particlePosition = .random(in: self.frame.size)
            self.sparkFireworkShowEmitter = sparkEmitterNode
            self.sparkSoundPlayer.play()
        }
        let moveAction = SKAction.repeat(SKAction.run { [weak self] in
            guard let `self` = self else { return }
            self.sparkFireworkShowEmitter?.run(SKAction.move(to: .random(in: self.frame.size), duration: 0.2))
        }, count: 4)
        let explodeAction = SKAction.run { [weak self] in
            guard let `self` = self,
                let explosionPoint = self.sparkFireworkShowEmitter?.particlePosition else { return }
            self.sparkFireworkShowEmitter?.removeFromParent()
            self.sparkFireworkShowEmitter = nil
            self.explodeFirework(Firework.defaultSet[Int(arc4random_uniform(3))],
                                 at: explosionPoint,
                                 withColor: .random,
                                 withScaleFactor: .randomDecimal)
            
        }
        let fireworksSequence = SKAction.sequence([waitAction, addAction, moveAction, explodeAction]).repeated()
        run(fireworksSequence)
    }
    
    public func endFireworkShow() {
        removeAllActions()
        sparkSoundPlayer.pause()
        sparkFireworkShowEmitter?.removeFromParent()
        sparkFireworkShowEmitter = nil
    }
}

// Firwork Show

// Every 0.5 - 3 seconds new firework starts (randomized
// fireworks travel to random new locations for duration 0.2 seconds for 0.8 seconds
// then explode firework at ending location with

