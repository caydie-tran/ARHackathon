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
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var player: AVAudioPlayer = AVAudioPlayer()
    var count = 0
    var isGameInPlay = true
    var slenderManNode: SCNNode!
    var gameInstNode: SCNNode!
    var counterTextNode: SCNNode!
    
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
         addTapGestureToSceneView()
        
//        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addSlenderMan), userInfo: nil, repeats: true)
        
        let startText = SCNText(string: "Tap on Slenderman\nBy SSED", extrusionDepth: 1)
        let textNode = SCNNode(geometry: startText)
        textNode.scale = SCNVector3Make( 1, 1, 1)
        textNode.geometry = startText
        textNode.position = SCNVector3Make(-50, 0, -50)
        self.gameInstNode = textNode
        
        sceneView.scene.rootNode.addChildNode(gameInstNode)
        
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.removeGameInst), userInfo: nil, repeats: false)
        setupSound();

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
        player.play()
    }
    
    @objc func removeSlenderMan() {
        guard isGameInPlay else { return }
        
//        for child in (sceneView.scene.rootNode.childNodes) {
//            child.removeFromParentNode()
//        }
        slenderManNode.removeFromParentNode()
        player.stop()
    }
    
    @objc func removeGameInst() {
        gameInstNode.removeFromParentNode()
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addSlenderMan), userInfo: nil, repeats: true)
        
        // Node for counter
        let counterText = SCNText(string: String(format: "%d", count), extrusionDepth: 1)
        counterTextNode = SCNNode(geometry: counterText)
        counterTextNode.scale = SCNVector3Make( 1, 1, 1)
        counterTextNode.geometry = counterText
        counterTextNode.position = SCNVector3Make(-50, 0, -50)
        
        sceneView.scene.rootNode.addChildNode(counterTextNode)
    }
    
    @objc func setupSound() {
        guard isGameInPlay else { return }
        
        do {
            let audioPath = Bundle.main.path(forResource: "art.scnassets/SlenderManTrim", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {
            // Error
        }
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
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        if (hitTestResults.first != nil) {
            incrementCount()
        } else {
            return
        }
    }
    
    func incrementCount() {
        count = count + 1
        print(count)
        counterTextNode!.removeFromParentNode()
        
        let counterText = SCNText(string: String(format: "%d", count), extrusionDepth: 1)
        counterTextNode = SCNNode(geometry: counterText)
        counterTextNode.scale = SCNVector3Make( 1, 1, 1)
        counterTextNode.geometry = counterText
        counterTextNode.position = SCNVector3Make(-50, 0, -50)
        
        sceneView.scene.rootNode.addChildNode(counterTextNode)
    }
}
