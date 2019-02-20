/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
  
  @IBOutlet weak var sceneView: ARSCNView!
  @IBOutlet weak var sketchButton: UIButton!
  
  @IBOutlet weak var mappingStatusLabel: UILabel!
  @IBOutlet weak var sessionInfoView: UIVisualEffectView!
  @IBOutlet weak var sessionInfoLabel: UILabel!
  
  @IBOutlet weak var saveExperienceButton: StatusControlledButton!
  @IBOutlet weak var loadExperienceButton: StatusControlledButton!
  
  @IBOutlet weak var snapshotThumbnailImageView: UIImageView!
  @IBOutlet weak var resetSceneButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!
  
  fileprivate var previousPoint: SCNVector3?
  let lineColor = UIColor.white
  
  var isSketchButtonPressed = false
  var viewCenter: CGPoint?
  
  var defaultConfiguration: ARWorldTrackingConfiguration {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    configuration.environmentTexturing = .automatic
    return configuration
  }
  
  // MARK: - View Life Cycle
  
  // Lock the orientation of the app to the orientation in which it is launched
  override var shouldAutorotate: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let viewBounds = self.view.bounds
    viewCenter = CGPoint(x: viewBounds.width / 2.0, y: viewBounds.height / 2.0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sceneView.delegate = self
    
    sceneView.session.delegate = self
    sceneView.session.run(defaultConfiguration)
    
    // Prevent the screen from being dimmed after a while as users will likely
    // have long periods of interaction without touching the screen or buttons.
    UIApplication.shared.isIdleTimerDisabled = true
    
    //hide buttons
    saveExperienceButton.isHidden = true
    loadExperienceButton.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  // MARK: - Place AR content
  func addLineObject(sourcePoint: SCNVector3, destinationPoint: SCNVector3) {
    let lineNode = SCNLineNode(from: sourcePoint, to: destinationPoint, radius: 0.02, color: lineColor)
    guard let hitTestResult = sceneView
      .hitTest(self.viewCenter!, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
      .first
      else { return }
    lineNode.transform = SCNMatrix4(hitTestResult.worldTransform)
    sceneView.scene.rootNode.addChildNode(lineNode)
  }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
      self.isSketchButtonPressed = self.sketchButton.isHighlighted
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    guard let pointOfView = sceneView.pointOfView else { return }
    let transform = pointOfView.transform
    let direction = SCNVector3(-1 * transform.m31, -1 * transform.m32, -1 * transform.m33)
    let currentPoint = pointOfView.position + (direction * 0.1)
    if isSketchButtonPressed {
      if let previousPoint = previousPoint {
        addLineObject(sourcePoint: previousPoint, destinationPoint: currentPoint)
      }
    }
    previousPoint = currentPoint
  }
}

// MARK: - AR session management
extension ViewController: ARSessionDelegate {
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay.
    sessionInfoLabel.text = "Session was interrupted"
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required.
    sessionInfoLabel.text = "Session interruption ended"
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user.
    sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
  }
}

// MARK: - Persistent AR
extension ViewController {
  @IBAction func resetTracking(_ sender: UIButton?) {
  }
  
  @IBAction func saveExperience(_ sender: UIButton) {
  }
  
  @IBAction func loadExperience(_ sender: Any) {
  }
  
  
  @IBAction func shareWorldMap(_ sender: Any) {
  }
}
