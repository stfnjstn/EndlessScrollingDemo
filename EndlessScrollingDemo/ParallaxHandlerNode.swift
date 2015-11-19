//
//  ParallaxHandlerNode.swift
//  EndlessScrollingDemo
//
//  Created by STEFAN JOSTEN on 18/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    case left
    case right
    case up
    case down
    case none
}

let scrollLevelDampingX = 0.5 as CGFloat
let scrollLevelDampingY = 0.2 as CGFloat
let scrollBackgroundDampingX = 0.5 as CGFloat
let scrollBackgroundDampingY = 0.5 as CGFloat

// ToDo:
// TouchUp => ease out
// Touch => Stop
// Stehenbleiben: Mit letzter Geschwindigkeit weiterscrollen
// Quadratische Beschleunigung auf Speed

class ParallaxHandlerNode: SKNode {
    
    var backgroundNodes = [SKNode]()
    var offsetsY = [Int]()
    var directionsY = [Int]()
    var screenFrame: CGSize?
    
    init(frame: CGSize) {
        super.init()
        screenFrame = frame
        self.addBackground(["Background"], numberOfScreens: 1, offsetY: 0, directionY:1)
        self.addBackground(["LeftTileBush","RightTileBush","", "LeftTileBush"], numberOfScreens: 4, offsetY: -20, directionY: -1)
        self.addBackground(["LeftTile", "RightTile", "LeftTile"], numberOfScreens: 3, offsetY: +40, directionY: 1)
        self.addBackground(["", "TileGrass", ""], numberOfScreens: 3, offsetY: -60, directionY: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Add a parallax layer behind the existing layers
    func addBackground(imageNames: [String], numberOfScreens: Int, offsetY: Int, directionY: Int) {
        
        // Screen size:
        if (numberOfScreens == 1) {
            // Create static background
            let backgroundNode = SKSpriteNode(imageNamed: imageNames[0])
            
            // Scale size to enable parallax effect
            backgroundNode.size = screenFrame!
            backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
            backgroundNode.position = CGPoint(x: 0, y: 0)
            backgroundNode.zPosition = 0
            
            self.addChild(backgroundNode)
        } else {
            // Create a background for infinite scrolling
            
            // Create a SKNode a root element
            let backgroundNode = SKNode()
            self.addChild(backgroundNode)
            
            // Create and add tiles to the node
            for (var i=0; i<imageNames.count; i++) {
                let imageName = imageNames[i]
                var imageNode: SKSpriteNode?
                if (imageName != "") {
                    imageNode = SKSpriteNode(imageNamed: imageName)
                } else {
                    imageNode = SKSpriteNode()
                }
                
                imageNode!.size = CGSize(width: screenFrame!.width, height: screenFrame!.height + CGFloat(abs(offsetY)))

                imageNode!.anchorPoint = CGPoint(x: 0, y: 0)
                imageNode!.position = CGPoint(x:(i * Int(screenFrame!.width)), y: 0)
                backgroundNode.addChild(imageNode!)
                imageNode!.zPosition = CGFloat(backgroundNodes.count + 1)
            }
            
            // position background at the second screen
            backgroundNode.position=CGPoint(x: 0, y: offsetY/2)
            backgroundNodes.append(backgroundNode)
            offsetsY.append(offsetY)
            directionsY.append(directionY)
            
        }
    }
    
    func scroll(xSpeed: CGFloat, ySpeed: CGFloat) {
        if xSpeed < 0 {
            self.scrollX(Direction.left, speed: -xSpeed)
        } else {
            self.scrollX(Direction.right, speed: xSpeed)
        }
        
        if ySpeed < 0 {
            self.scrollY(Direction.down, speed: Int(-ySpeed))
        } else {
            self.scrollY(Direction.up, speed: Int(ySpeed))
        }
    }
    
    private func scrollX(scrollDirection: Direction, speed: CGFloat) {
        
        // Screen size:
        let width = Int(UIScreen.mainScreen().bounds.width)
        
        for (var i = 0; i < backgroundNodes.count; i++) {
            
            var parallaxPos : CGPoint?
            let node = backgroundNodes[i]
            let newSpeed = speed / CGFloat(2 * ((backgroundNodes.count - i)+1)) * scrollBackgroundDampingX
            
            parallaxPos = node.position
            
            if (scrollDirection == Direction.right) {
                parallaxPos!.x = parallaxPos!.x + newSpeed
                if (parallaxPos!.x>=0) {
                    // switch between first and last screen
                    parallaxPos!.x = CGFloat(-width*(node.children.count-1))
                }
            } else if (scrollDirection == Direction.left) {
                parallaxPos!.x = parallaxPos!.x - newSpeed
                if (parallaxPos!.x < CGFloat(-width*(node.children.count-1))) {
                    // switch between last and first screen
                    parallaxPos!.x = 0
                }
            }
            
            // Set the new position
            node.position = parallaxPos!
        }
    }
    
    private func scrollY(scrollDirection: Direction, speed: Int) {
        
        for (var i = 0; i < backgroundNodes.count; i++) {
            
            var parallaxPos : CGPoint?
            let node = backgroundNodes[i]
            let newSpeed = CGFloat(speed / (2 * ((backgroundNodes.count - i) + 1))) * scrollBackgroundDampingY // Slower
            let offset = offsetsY[i]
            let direction = CGFloat(directionsY[i])
            
            parallaxPos = node.position
            
            if (scrollDirection == Direction.up) {
                if offset < 0 && (parallaxPos!.y + newSpeed) <= 0 || offset > 0 && (parallaxPos!.y + newSpeed) <= CGFloat(offset) {
                    parallaxPos!.y = parallaxPos!.y + newSpeed * direction
                }
            } else if (scrollDirection == Direction.down) {
                if offset > 0 && (parallaxPos!.y - newSpeed) >= 0 || offset < 0 && (parallaxPos!.y - newSpeed) >= CGFloat(offset) {
                    parallaxPos!.y = parallaxPos!.y - newSpeed * direction
                }
            }
            
            // Set the new position
            node.position = parallaxPos!
            
        }
    }
    
    
}
