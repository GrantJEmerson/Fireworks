//
//  FireworksScene.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit
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
    
    private var fireworkShowSparkEmitterNode: SKEmitterNode?
    
    private var sparkEmitterNodes = [UITouch: SKEmitterNode]()
    
    private let fireworkDuration: CGFloat = 1.5
    
    private let sparkAudioFile: AVAudioFile = {
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
            explode(currentFirework,
                            at: touchLocation,
                            withColor: fireworksDelegate?.fireworksColor ?? .orange,
                            withScaleFactor: fireworksDelegate?.scaleFactor ?? 1)
        }
        guard sparkEmitterNodes.isEmpty else { return }
        sparkSoundPlayer.pause()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let sparkEmitterNode = sparkEmitterNodes[touch] else { continue }
            sparkEmitterNode.removeAllActions()
            sparkEmitterNode.removeFromParent()
            sparkEmitterNodes.removeValue(forKey: touch)
        }
        guard sparkEmitterNodes.isEmpty else { return }
        sparkSoundPlayer.pause()
    }
    
    // MARK: Private Functions
    
    private func explode(_ firework: Firework,
                                 at point: CGPoint, withColor color: UIColor,
                                 withScaleFactor scaleFactor: CGFloat) {
        guard let fireworkEmitter = SKEmitterNode(fileNamed: firework.name) else { return }
        fireworkEmitter.particlePosition = point
        fireworkEmitter.particleColorSequence = nil
        fireworkEmitter.particleScale *= scaleFactor
        fireworkEmitter.particleColor = color
        guard let smokeEmitter = SKEmitterNode(fileNamed: "FireworkSmokeEmitter") else { return }
        smokeEmitter.particlePosition = point
        let fireworkSound = SKAction.playSoundFileNamed(firework.name, waitForCompletion: false)
        let fireworkSequence = SKAction.sequence([
            SKAction.run({
                self.addChild(fireworkEmitter)
                self.addChild(smokeEmitter)
            }),
            SKAction.wait(forDuration: 2.5),
            SKAction.run(fireworkEmitter.removeFromParent),
            SKAction.wait(forDuration: 8),
            SKAction.run(smokeEmitter.removeFromParent)
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
        let swayAction = SKAction.sequence([
                            SKAction.moveBy(x: 10, y: 0, duration: 2),
                            SKAction.moveBy(x: -10, y: 0, duration: 2)
                         ]).repeated()
        addChild(cloud)
        cloud.position = CGPoint(x: 50, y: frame.maxY - 50)
        cloud.run(swayAction)
    }
    
    private func addSparkEmitter() {
        self.fireworkShowSparkEmitterNode = SKEmitterNode(fileNamed: "SparkEmitter")
        self.addChild(fireworkShowSparkEmitterNode!)
        fireworkShowSparkEmitterNode?.particlePosition = CGPoint(x: .random(to: frame.width), y: 0)
    }
    
    // MARK: Public Functions
    
    public func startFireworkShow() {
        let addAction = SKAction.run { [weak self] in
            guard let `self` = self else { return }
            self.addSparkEmitter()
            self.sparkSoundPlayer.play()
        }
        let moveAction = SKAction.run { [weak self] in
            guard let `self` = self,
                let currentX = self.fireworkShowSparkEmitterNode?.particlePosition.x,
                let currentY = self.fireworkShowSparkEmitterNode?.particlePosition.y else { return }
            let upperScreen = CGRect(x: 0, y: self.frame.midY,
                                     width: self.frame.width, height: self.frame.height / 2)
            let amountOfStops: CGFloat = 20
            let randomPoint = CGPoint.random(in: upperScreen)
            let xAddOn = (randomPoint.x - currentX) / amountOfStops
            let yAddOn = (randomPoint.y - currentY) / amountOfStops
            let smoothTranistion = SKAction.sequence([
                SKAction.run {
                    self.fireworkShowSparkEmitterNode?.particlePosition.x += xAddOn
                    self.fireworkShowSparkEmitterNode?.particlePosition.y += yAddOn
                },
                SKAction.wait(forDuration: TimeInterval(self.fireworkDuration / amountOfStops))
            ])
            self.fireworkShowSparkEmitterNode?.run(SKAction.repeat(smoothTranistion, count: Int(amountOfStops)))
        }
        let waitAction = SKAction.wait(forDuration: TimeInterval(fireworkDuration))
        let explodeAction = SKAction.run { [weak self] in
            guard let `self` = self,
                let explosionPoint = self.fireworkShowSparkEmitterNode?.particlePosition else { return }
            self.fireworkShowSparkEmitterNode?.removeFromParent()
            self.fireworkShowSparkEmitterNode = nil
            self.sparkSoundPlayer.pause()
            self.explode(Firework.defaultSet[Int(arc4random_uniform(4))],
                                 at: explosionPoint,
                                 withColor: .random,
                                 withScaleFactor: .randomDecimal)
        }
        let fireworksSequence = SKAction.sequence([addAction, moveAction, waitAction, explodeAction]).repeated()
        run(fireworksSequence)
    }
    
    public func endFireworkShow() {
        removeAllActions()
        sparkSoundPlayer.pause()
        fireworkShowSparkEmitterNode?.removeFromParent()
        fireworkShowSparkEmitterNode = nil
    }
}
