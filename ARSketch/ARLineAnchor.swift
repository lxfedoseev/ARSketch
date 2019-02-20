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

import Foundation
import ARKit
import SceneKit

class ARLineAnchor : ARAnchor {
  
  var sourcePoint : SCNVector3?
  var destinationPoint : SCNVector3?
  
  override static var supportsSecureCoding: Bool {
    get{
      return true
    }
  }
  
  enum CodingKeys: String {
    case source = "source"
    case destination = "destination"
  }
  
  init(name: String, transform: simd_float4x4, sourcePoint: SCNVector3?, destinationPoint: SCNVector3?) {
    super.init(name: name, transform: transform)
    self.sourcePoint = sourcePoint
    self.destinationPoint = destinationPoint
  }
  
  required init(anchor: ARAnchor) {
    super.init(anchor: anchor)
    
    let lineAnchor = anchor as? ARLineAnchor
    self.sourcePoint = lineAnchor?.sourcePoint
    self.destinationPoint = lineAnchor?.destinationPoint
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    if let source: Point = aDecoder.decodeObject(of: Point.self, forKey: CodingKeys.source.rawValue) {
      self.sourcePoint = SCNVector3.init(x: source.x, y: source.y, z: source.z)
    }
    
    if let destination: Point = aDecoder.decodeObject(of: Point.self, forKey: CodingKeys.destination.rawValue) {
      self.destinationPoint = SCNVector3(destination.x, destination.y, destination.z)
    }
    
  }
  
  override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(Point(x: sourcePoint!.x, y: sourcePoint!.y, z: sourcePoint!.z), forKey: CodingKeys.source.rawValue)
    aCoder.encode(Point(x: destinationPoint!.x, y: destinationPoint!.y, z: destinationPoint!.z), forKey: CodingKeys.destination.rawValue)
  }
}
