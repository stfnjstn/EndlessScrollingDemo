//
//  GameScene.swift
//  EndlessScrollingDemo
//
//  Created by STEFAN JOSTEN on 13/11/15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Some global variables to preserve the state and store the touch positions
    var lastUpdateTime: CFTimeInterval?
    var currentSpeed: CGFloat = 0.0
    var nodeTileWidth: CGFloat = 0.0
    var xTouchCurrentPosition: CGFloat = 0.0
    var xTouchStartPosition: CGFloat = 0.0
    var xTouchDistance: CGFloat = 0.0
    
    // Some global constants to configure the speed
    let speedFactor:CGFloat = 5.0
    let easeOutfactor: CGFloat = 0.04
    
    // Declare the globaly needed sprite kit nodes
    var worldNode: SKSpriteNode?
    var spriteNode: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        
        // Setup static background
        let backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -10
        self.addChild(backgroundNode)
        
        // Setup dynamic background tiles
        worldNode = SKSpriteNode()
        self.addChild(worldNode!)
        
        // Create the dynamic background tiles. Image of left and right node must be identical
        let leftNode = SKSpriteNode(imageNamed: "LeftTile")
        let middleNode = SKSpriteNode(imageNamed: "RightTile")
        let rightNode = SKSpriteNode(imageNamed: "LeftTile")
        
        // store this value globaly to avoid recalculations during each update call
        nodeTileWidth = leftNode.frame.size.width
        
        leftNode.anchorPoint = CGPoint(x: 0, y: 0)
        leftNode.position = CGPoint(x: 0, y: 0)
        middleNode.anchorPoint = CGPoint(x: 0, y: 0)
        middleNode.position = CGPoint(x: nodeTileWidth, y: 0)
        rightNode.anchorPoint = CGPoint(x: 0, y: 0)
        rightNode.position = CGPoint(x: nodeTileWidth * 2, y: 0)
        
        // Add the tiles to worldNode. worldNode is used to realize the scrolling
        worldNode!.addChild(leftNode)
        worldNode!.addChild(rightNode)
        worldNode!.addChild(middleNode)
        
        
        // Setup spaceship sprite
        spriteNode = SKSpriteNode(imageNamed: "Spaceship")
        spriteNode?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        spriteNode?.xScale = 0.1
        spriteNode?.yScale = 0.1
        spriteNode?.zPosition = 10
        self.addChild(spriteNode!)
    }
    
    // Store the start touch position
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            xTouchStartPosition = touch.locationInNode(self).x
        }
    }
    
    // Calculate the distance of the toch movement
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            xTouchCurrentPosition = touch.locationInNode(self).x
            xTouchDistance = xTouchStartPosition - xTouchCurrentPosition
        }
    }
    
    // Reset all movement states
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        xTouchCurrentPosition = 0.0
        xTouchDistance = 0.0
        xTouchStartPosition = 0.0
    }
    
    // SpriteKits gameloop function
    override func update(currentTime: CFTimeInterval) {
        
        // Scroll the background
        scroll(xTouchDistance, currentTime: currentTime)

        // Rotate sprite depending on direction
        if xTouchDistance > 0 {
            spriteNode?.zRotation = CGFloat(M_PI/2.0)
        } else if xTouchDistance < 0 {
            spriteNode?.zRotation = -CGFloat(M_PI/2.0)
        }

    }
    
    // Implement the scrolling
    func scroll(speed: CGFloat, currentTime: CFTimeInterval) {
        if lastUpdateTime != nil {
            
            // Calculate the new speed with the easing function (New speed is influence by current speed)
            let  newSpeed = (currentSpeed + (speed - currentSpeed) * easeOutfactor)
            currentSpeed = newSpeed
            
            // Set the new x position depending on the timeframe since the last calls.
            // This is needed because spritekit cannot guarantee that the timeframe is allways the same
            worldNode!.position.x = worldNode!.position.x + newSpeed * CGFloat((currentTime - lastUpdateTime!)) * speedFactor
            
            // Check if right end is reached
            if worldNode!.position.x < -(2 * self.nodeTileWidth) {
                worldNode!.position.x = 0.0
                // Check if left end is reached
            } else if worldNode!.position.x > 0 {
                worldNode!.position.x = -(2 * self.nodeTileWidth)
            }
        }
        lastUpdateTime = currentTime
    }
    
}
