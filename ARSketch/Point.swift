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

class Point: NSObject, NSSecureCoding {
  var x: Float
  var y: Float
  var z: Float
  
  public static var supportsSecureCoding: Bool {
    get{
      return true
    }
  }
  
  public enum CodingKeys: String {
    case x = "x"
    case y = "y"
    case z = "z"
  }
  
  public init(x: Float, y: Float, z: Float) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.x = aDecoder.decodeFloat(forKey: CodingKeys.x.rawValue)
    self.y = aDecoder.decodeFloat(forKey: CodingKeys.y.rawValue)
    self.z = aDecoder.decodeFloat(forKey: CodingKeys.z.rawValue)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.x, forKey: CodingKeys.x.rawValue)
    aCoder.encode(self.y, forKey: CodingKeys.y.rawValue)
    aCoder.encode(self.z, forKey: CodingKeys.z.rawValue)
  }
}
