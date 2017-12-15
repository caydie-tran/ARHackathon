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
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.addSlenderMan), userInfo: nil, repeats: true)
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
    
    @objc func addSlenderMan() {
        guard isGameInPlay else { return }
        let randomX = arc4random();
        let randomY = arc4random();
        let randomZ = arc4random();

        let slenderMan = SCNScene(named: "art.scnassets/slender.dae")
        
        let slenderManNode = SCNNode()
        
        for child in (slenderMan?.rootNode.childNodes)! {
            slenderManNode.addChildNode(child)
        }
    
        slenderManNode.position = SCNVector3(0, -1, -2)
        
        sceneView.scene.rootNode.addChildNode(slenderManNode)
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
