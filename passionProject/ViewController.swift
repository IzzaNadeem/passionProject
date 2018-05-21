//
//  ViewController.swift
//  passionProject
//
//  Created by C4Q on 5/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    var nodeDetected: SCNNode?
      var imageLink: URLS?
    
   
