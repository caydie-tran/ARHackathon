//
//  ViewController.swift
//  slender
//
//  Created by Daniel Tam on 12/14/17.
//  Copyright © 2017 Daniel Tam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
//        let scene = SCNScene(named: "art.scnassets/slender.dae")!
        
        // Set the scene to the view
        sceneView.scene = scene
        //self.addSlenderMan();
        
//        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addSlenderMan), userInfo: nil, repeats: true)
        
        let startText = SCNText(string: "Tap on Slenderman\nBy SSED", extrusionDepth: 1)
        let textNode = SCNNode(geometry: startText)
        textNode.scale = SCNVector3Make( 1, 1, 1)
        textNode.geometry = startText
        textNode.position = SCNVector3Make(-50, 0, -50)
        self.gameInstNode = textNode
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.removeGameInst), userInfo: nil, repeats: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    var isGameInPlay = true
    var slenderManNode: SCNNode!
    var gameInstNode: SCNNode!

    @objc func addSlenderMan() {
        guard isGameInPlay else { return }
    
        var randomX = CGFloat(arc4random_uniform(16) + 0)
        if (Float(arc4random()) /  Float(UInt32.max) < 0.5) {
            randomX = randomX * -1
        }
        
        var randomY = CGFloat(arc4random_uniform(12) + 0)
        if (Float(arc4random()) /  Float(UInt32.max) < 0.5) {
            randomY = randomY * -1
        }
        
        var randomZ = CGFloat(arc4random_uniform(12) + 0)
        if (Float(arc4random()) /  Float(UInt32.max) < 0.5) {
            randomZ = randomZ * -1
        }
        
    
        print (randomX)
    
        print (randomY)
    
        print (randomZ)
        

        let slenderMan = SCNScene(named: "art.scnassets/slender.dae")

        let slenderManNode = SCNNode()
        self.slenderManNode = slenderManNode
        
        for child in (slenderMan?.rootNode.childNodes)! {
            slenderManNode.addChildNode(child)
        }
        
        slenderManNode.position = SCNVector3(randomX, randomY, randomZ)
        sceneView.scene.rootNode.addChildNode(slenderManNode)
        
        _ = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.removeSlenderMan), userInfo: nil, repeats: false)

    }
    
    @objc func removeSlenderMan() {
        guard isGameInPlay else { return }
//        sceneView.scene.rootNode.removeAllActions()
//        slenderManNode.removeFromParentNode()
        
        for child in (sceneView.scene.rootNode.childNodes) {
            child.removeFromParentNode()
        }
    }
    
    @objc func removeGameInst() {
        gameInstNode.removeFromParentNode()
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addSlenderMan), userInfo: nil, repeats: true)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
