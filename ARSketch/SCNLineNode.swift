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

import SceneKit

class SCNLineNode: SCNNode {
  
  init(from startPoint: SCNVector3, to endPoint: SCNVector3, radius: CGFloat, color: UIColor) {
    super.init()
    let lineVector = SCNVector3(x: endPoint.x-startPoint.x,
                                y: endPoint.y-startPoint.y,
                                z: endPoint.z-startPoint.z)
    let distanceBetweenPoints = CGFloat(sqrt(lineVector.x * lineVector.x + lineVector.y * lineVector.y + lineVector.z * lineVector.z))
    
    if distanceBetweenPoints == 0.0 {
      // two points together.
      let sphere = SCNSphere(radius: radius)
      sphere.firstMaterial?.diffuse.contents = color
      self.geometry = sphere
      self.position = startPoint
      return
    }
    
    let cylinder = SCNCylinder(radius: radius, height: distanceBetweenPoints)
    cylinder.firstMaterial?.diffuse.contents = color
    self.geometry = cylinder
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init()
  }
}
