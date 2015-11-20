//
//  BackgroundScrollingNode.swift
//  EndlessScrollingDemo
//
//  Created by STEFAN JOSTEN on 20/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//


import UIKit
import SpriteKit

class BackgroundScrollingNode: SKNode {
    
    var nodeTileWidth: CGFloat = 0.0
    
    override init() {
        super.init()
        
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
        self.addChild(leftNode)
        self.addChild(rightNode)
        self.addChild(middleNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scroll() {
    
    }

}