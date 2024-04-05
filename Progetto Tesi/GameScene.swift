//
//  GameScene.swift
//  Progetto Tesi
//
//  Created by Utente on 21/04/23.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var jumpCount = 0
    let maxJumpCount = 3
    var Player = SKSpriteNode()
    let PlayerTexture = SKTexture(imageNamed: "player")
    var PlayerMovesLeft = false
    var PlayerMovesRight = false
    let cam = SKCameraNode()
    let PlayerCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    
    enum bitMaks: UInt32 {
        case Player = 0b1 //1
        case ground = 0b10 // 2
    
    }
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
               for node in self.children{
            if (node.name == "PlatformMap") {
                if let someTileMap: SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                }
                break
            }
        }
        

        addPlayer()
    }
    func addPlayer() {
        Player = childNode(withName: "player") as! SKSpriteNode
        Player.physicsBody?.restitution = 0.0
        Player.physicsBody = SKPhysicsBody(texture: PlayerTexture, size: Player.size)
        Player.physicsBody?.categoryBitMask = bitMaks.Player.rawValue
        Player.physicsBody?.contactTestBitMask = bitMaks.ground.rawValue
        Player.physicsBody?.collisionBitMask = bitMaks.ground.rawValue
        Player.physicsBody?.allowsRotation = false
    }
    func giveTileMapPhysicsBody(map: SKTileMapNode) {
        let tileMap = map
        let startLocation: CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns{
            for row in 0..<tileMap.numberOfRows{
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    
                    let tileArray = tileDefinition.textures
                    let tileTextures = tileArray[0]
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    let tileNode = SKSpriteNode(texture: tileTextures)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTextures, size: CGSize(width: tileTextures.size().width, height: tileTextures.size().height))
                    tileNode.physicsBody?.categoryBitMask = bitMaks.ground.rawValue
                    tileNode.physicsBody?.contactTestBitMask = bitMaks.Player.rawValue
                    tileNode.physicsBody?.collisionBitMask = bitMaks.Player.rawValue
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.friction = 1
                    tileNode.zPosition = 20
                    tileNode.anchorPoint = .zero
                    
                    tileNode.position = CGPoint(x: tileNode.position.x + startLocation.x, y: tileNode.position.y + startLocation.y)
                    self.addChild(tileNode)
                }
                
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let touchNode = self.nodes(at: position)
            
            for node in touchNode {
                if node.name == "Left"{
                    PlayerMovesLeft = true
                }
                if node.name == "Right"{
                    PlayerMovesRight = true
                }
                if node.name == "Up" && jumpCount < maxJumpCount {
                                Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 16))
                                jumpCount += 1
                }
            }
        }
    }
    func updateJumpLabel() {
        let jumpLabel = SKLabelNode(text: "Jumps: 2")
        jumpLabel.position = CGPoint(x: 100, y: 100)
        addChild(jumpLabel)
        // Aggiorna il testo dell'etichetta dei salti nell'interfaccia utente
        jumpLabel.text = "Jumps: \(jumpCount)"
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PlayerCategory | groundCategory {
            // Il personaggio ha toccato il suolo
            jumpCount = 0
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let touchNode = self.nodes(at: position)
            
            for node in touchNode {
                if node.name == "Left"{
                    PlayerMovesLeft = false
                }
                if node.name == "Right"{
                    PlayerMovesRight = false
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if PlayerMovesLeft == true {
                Player.position.x -= 5
        }
        if PlayerMovesRight == true {
                Player.position.x += 5
        }
        cam.position = Player.position
    }
}
