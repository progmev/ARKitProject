//
//  ViewController.swift
//  ARKitProject
//
//  Created by MartynovEV on 24/01/2018.
//  Copyright © 2018 MartynovEV. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        createBox(in: scene)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(boxTapped(touch:)))
        self.sceneView.addGestureRecognizer(gestureRecognizer)
        
        //createFigures(in: scene)
        
        // MARK: - AR Sphere
        /*
        let sphereGeometry = SCNSphere(radius: 0.1)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "earth.jpg")
        
        // change the size of the texture
        // sphereMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 2)
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.materials = [sphereMaterial];
        sphereNode.position = SCNVector3(0, 0, -1)
        
        scene.rootNode.addChildNode(sphereNode)
        */
        
        // MARK: - AR Box
        /*
        let boxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.brown
        
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.geometry?.materials = [material];
        boxNode.position = SCNVector3(0, 0, -1.0)
        
        scene.rootNode.addChildNode(boxNode)
        
        let textGeometry = SCNText(string: "This is the cube", extrusionDepth: 2.0)
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.red
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        textNode.geometry?.materials = [textMaterial]
        
        textNode.position = SCNVector3(0, 0.2, -1.0)
        scene.rootNode.addChildNode(textNode)
        */
        
        sceneView.scene = scene
    }
    
    @objc func boxTapped(touch: UITapGestureRecognizer) {
        let sceneView = touch.view as! SCNView  // touch SCNView
        let touchLocation = touch.location(in: sceneView) // coordinats
        
        let touchResults = sceneView.hitTest(touchLocation, options: [:])
        
        // touchResults is not Empty & we can eject node
        guard !touchResults.isEmpty, let node = touchResults.first?.node else { return }
        
        // change property touch object
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.blue
        boxMaterial.specular.contents = UIColor.red
        node.geometry?.materials[0] = boxMaterial
        
    }
    
    private func createBox(in scene: SCNScene) {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        
        boxMaterial.diffuse.contents = UIColor.red      // color box
        boxMaterial.specular.contents = UIColor.yellow  // reflected light
        
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(0.0, 0.0, -1.0)
        scene.rootNode.addChildNode(boxNode)
    }
    
    private func createFigures(in scene: SCNScene) {
        let array: [SCNGeometry] = [SCNPlane(), SCNSphere(), SCNBox(), SCNPyramid(), SCNTube(), SCNCone(), SCNTorus(), SCNCylinder(), SCNCapsule()]
        var xCoordinate: Double = 1
        sceneView.autoenablesDefaultLighting = true
        
        for geometryShape in array {
            let node = SCNNode(geometry: geometryShape)
            
            let material = SCNMaterial()
        
            if (geometryShape is SCNSphere) {
                material.diffuse.contents = UIImage(named: "earth.jpg")
            } else if (geometryShape is SCNCapsule) {
                material.diffuse.contents = UIImage(named: "head.jpg")
            } else {
                material.diffuse.contents = UIColor.red
            }

            node.geometry?.materials = [material]
            node.scale = SCNVector3(0.3, 0.3, 0.3)
            
            node.position = SCNVector3(xCoordinate, 0, -1)
            xCoordinate -= 0.4
            
            scene.rootNode.addChildNode(node)
        }
    }
    
    // Before the advent of VC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    // After the advent of VC
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
