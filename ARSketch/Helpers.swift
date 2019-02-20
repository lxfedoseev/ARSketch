/**
 * Copyright © 2018 Apple Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions
 * of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS O
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import simd
import ARKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notAvailable:
      return "Not Available"
    case .limited:
      return "Limited"
    case .extending:
      return "Extending"
    case .mapped:
      return "Mapped"
    }
  }
}

extension ARCamera.TrackingState: CustomStringConvertible {
  public var description: String {
    switch self {
    case .normal:
      return "Normal"
    case .notAvailable:
      return "Not Available"
    case .limited(.initializing):
      return "Initializing"
    case .limited(.excessiveMotion):
      return "Excessive Motion"
    case .limited(.insufficientFeatures):
      return "Insufficient Features"
    case .limited(.relocalizing):
      return "Relocalizing"
    }
  }
  
}

extension ARCamera.TrackingState {
  var localizedFeedback: String {
    switch self {
    // 1
    case .normal:
      return "Move around to map the environment."
    // 2
    case .notAvailable:
      return "Tracking unavailable."
    // 3
    case .limited(.excessiveMotion):
      return "Move the device more slowly."
    // 4
    case .limited(.insufficientFeatures):
      return """
      Point the device at an area with visible surface detail,
      or improve lighting conditions.
      """
    // 5
    case .limited(.relocalizing):
      return """
      Resuming session — move to where you
      were when the session was interrupted.
      """
    // 6
    case .limited(.initializing):
      return "Initializing AR session."
    }
  }
}

extension UIViewController {
  func showAlert(title: String,
                 message: String,
                 buttonTitle: String = "OK",
                 showCancel: Bool = false,
                 buttonHandler: ((UIAlertAction) -> Void)? = nil) {
    print(title + "\n" + message)
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
    if showCancel {
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
}

extension CGImagePropertyOrientation {
  /// Preferred image presentation orientation respecting the native sensor orientation of iOS device camera.
  init(cameraOrientation: UIDeviceOrientation) {
    switch cameraOrientation {
    case .portrait:
      self = .right
    case .portraitUpsideDown:
      self = .left
    case .landscapeLeft:
      self = .up
    case .landscapeRight:
      self = .down
    default:
      self = .right
    }
  }
}

extension ARWorldMap {
  var snapshotAnchor: SnapshotAnchor? {
    return anchors.compactMap { $0 as? SnapshotAnchor }.first
  }
}
