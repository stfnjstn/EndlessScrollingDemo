//
//  GameScene.swift
//  EndlessScrollingDemo
//
//  Created by STEFAN JOSTEN on 13/11/15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Declare the globaly needed sprite kit nodes
    var worldNode: SKNode?
    var spriteNode: SKSpriteNode?

    // store the width of the NodeTiles
    var nodeTileWidth: CGFloat = 0.0
    
    // store the start position of the movement
    var xOrgWorldPosition: CGFloat?
    var xOrgTouchPosition: CGFloat?
    var xTargetPosition: CGFloat?
    var touchesEnded = true
    var touchesCounter = 0
    
    override func didMoveToView(view: SKView) {
        
        // Setup static background
        let backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -10
        self.addChild(backgroundNode)
        
        // Setup world
        worldNode = SKNode()
        self.addChild(worldNode!)
        
        // Setup dynamic background tiles
        // Image of left and right node must be identical
        let leftNode = SKSpriteNode(imageNamed: "LeftTile")
        let middleNode = SKSpriteNode(imageNamed: "RightTile")
        let rightNode = SKSpriteNode(imageNamed: "LeftTile")
        
        nodeTileWidth = leftNode.frame.size.width
        
        leftNode.anchorPoint = CGPoint(x: 0, y: 0)
        leftNode.position = CGPoint(x: 0, y: 0)
        middleNode.anchorPoint = CGPoint(x: 0, y: 0)
        middleNode.position = CGPoint(x: nodeTileWidth, y: 0)
        rightNode.anchorPoint = CGPoint(x: 0, y: 0)
        rightNode.position = CGPoint(x: nodeTileWidth * 2, y: 0)
        
        // Add tiles to worldNode. worldNode is used to realize the scrolling
        worldNode!.addChild(leftNode)
        worldNode!.addChild(rightNode)
        worldNode!.addChild(middleNode)
        
        // Setup sprite
        spriteNode = SKSpriteNode(imageNamed: "Spaceship")
        spriteNode?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        spriteNode?.xScale = 0.1
        spriteNode?.yScale = 0.1
        spriteNode?.zPosition = 10
        self.addChild(spriteNode!)
    }
    
//    // Implement the scrolling, triggered by swipe gestures
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        for touch in touches {
//            
//            // Touch position
//            let xTouchPosition = touch.locationInNode(self).x
//            if xOrgPosition != 0.0 {
//                
//                // calculate the new position
//                let xNewPosition = worldNode!.position.x + (xOrgPosition - xTouchPosition)
//                
//                // Check if right end is reached
//                if xNewPosition <= -(2 * nodeTileWidth) {
//                    worldNode!.position = CGPoint(x: 0, y: 0)
//                    print("Right end reached")
//                // Check if left end is reached
//                } else if xNewPosition >= 0 {
//                    worldNode!.position = CGPoint(x: -(2 * nodeTileWidth), y: 0)
//                    print("Left end reached")
//                } else {
//                    worldNode!.position = CGPoint(x: xNewPosition, y: 0)
//                }
//                
//                // Rotate sprite depending on direction
//                if xTouchPosition < xOrgPosition {
//                    spriteNode?.zRotation = CGFloat(M_PI/2.0)
//                } else {
//                    spriteNode?.zRotation = -CGFloat(M_PI/2.0)
//                }
//                
//            }
//            
//            // Store the current touch position to calculate the delta in the next iteration
//            xOrgPosition = xTouchPosition
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        // Reset value for the next swipe gesture
//        xOrgPosition = 0
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        xOrgWorldPosition = worldNode?.position.x
        for touch in touches {
            xOrgTouchPosition = touch.locationInNode(self).x
        }
        touchesEnded = false
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            xTargetPosition = xOrgWorldPosition! - xOrgTouchPosition! + touch.locationInNode(self).x
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesEnded = true
        touchesCounter = 100
        //xTargetPosition = nil
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if let xPos = xTargetPosition {
            var xNewPos = worldNode!.position.x + (xPos - worldNode!.position.x) * 0.1

            // Check if right end is reached
            if xNewPos <= -(2 * nodeTileWidth) {
                xNewPos = 0
                xOrgWorldPosition = 0
                print("Right end reached")
            // Check if left end is reached
            } else if xNewPos >= 0 {
                xNewPos = -(2 * nodeTileWidth)
                xOrgWorldPosition = xNewPos
                print("Left end reached")
            }
            worldNode!.position.x = xNewPos
            
            // Rotate sprite depending on direction
            if xNewPos > xTargetPosition {
                spriteNode?.zRotation = CGFloat(M_PI/2.0)
            } else {
                spriteNode?.zRotation = -CGFloat(M_PI/2.0)
            }
            
            // Continue after touches ended
            if touchesEnded {
                touchesCounter = touchesCounter - 1
                if touchesCounter <= 0 {
                    xTargetPosition = nil
                }
            }
            
        }
    }
}
