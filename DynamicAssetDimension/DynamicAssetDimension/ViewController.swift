//
//  ViewController.swift
//  DynamicAssetDimension
//
//  Created by James Daigler on 10/23/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var dotNodes = [SCNNode]()
    
    //These are the scaled values for the model scene,
    //to be used to scale the model to the target window size
    var boundingboxWidth = Float(84.069)
    var boundingboxHeight = Float(78.752)
    var boundingboxDepth = Float(60.711)
    
    @IBOutlet weak var WidthLabel: UILabel!
    @IBOutlet weak var DepthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
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
    @IBAction func OnTapGesture(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        //get location of touch once cast to next feature point it hits
            
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
                
        if let hitResult = hitTestResults.first {
            addDot(at: hitResult)
        }

        if dotNodes.count == 3 {
            addAsset()
        } else if dotNodes.count > 3 {
            resetScene()
        }
            
    }
    
    func addDot(at hitResult: ARHitTestResult )
    {
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [dotMaterial]
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
    }
    func addAsset() {
        //get window measurements
        let width = calculateDistance3D(start: dotNodes[0], end: dotNodes[1])
        let depth = calculateDistance3D(start: dotNodes[1], end: dotNodes[2])
        
        //display measurements
        WidthLabel.text = "Width: \(width)"
        DepthLabel.text = "Depth: \(depth)"
        WidthLabel.textColor = UIColor.black
        DepthLabel.textColor = UIColor.black
                
        //get model scale
        let scaleX = getScale(originalMeasurement: boundingboxWidth, newMeasurement: width)
        let scaleZ = getScale(originalMeasurement: boundingboxDepth, newMeasurement: depth)
        let scaleY = getAverage(x: scaleX, y: scaleZ)
        
        //get model node placement location
        let centerX = getMiddle(n1: dotNodes[0].position.x, n2: dotNodes[1].position.x)
        let centerY = dotNodes[0].position.y
        let centerZ = getMiddle(n1: dotNodes[1].position.z, n2: dotNodes[2].position.z)
        
        //get rid of the dots
        dotNodes.removeAll()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        //add model to scene
        if let tvScene = SCNScene(named: "art.scnassets/crtv.scn") {
            
            if let tvNode = tvScene.rootNode.childNode(withName: "tv_retro", recursively: true) {
                
                tvNode.position = SCNVector3(centerX, centerY, centerZ)
                tvNode.scale = SCNVector3(scaleX, scaleY, scaleZ)
                
                sceneView.scene.rootNode.addChildNode(tvNode)
                print("add node to scene")
            }
        }
    }
    func resetScene() {
        dotNodes.removeAll()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        WidthLabel.text = ""
        DepthLabel.text = ""
    }


}
