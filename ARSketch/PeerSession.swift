//
//  PeerSession.swift
//  ARSketch
//
//  Created by Alex Fedoseev on 21.02.2019.
//  Copyright © 2019 Namrata Bandekar. All rights reserved.
//

// 1
import MultipeerConnectivity

class PeerSession: NSObject, MCAdvertiserAssistantDelegate {
  // 2
  private let peerID = MCPeerID(displayName: UIDevice.current.name)
  static let serviceType = "arsketchsession"
  // 3
  private(set) var mcSession: MCSession!
  // 4
  private var advertiserAssistant: MCAdvertiserAssistant!
  // 5
  private let receivedDataHandler: (Data, MCPeerID) -> Void
  
  //1
  init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void) {
    self.receivedDataHandler = receivedDataHandler
    super.init()
    //2
    mcSession = MCSession(peer: peerID,
                          securityIdentity: nil,
                          encryptionPreference: .required)
    mcSession.delegate = self
    //4
    advertiserAssistant =
      MCAdvertiserAssistant(serviceType: PeerSession.serviceType,
                            discoveryInfo: nil, session: self.mcSession)
    advertiserAssistant.delegate = self
    advertiserAssistant.start()
  }
  
  // 1
  func sendToAllPeers(_ data: Data) {
    do {
      try mcSession.send(data,
                         toPeers: mcSession.connectedPeers,
                         with: .reliable)
    } catch {
      print("""
        with: .reliable)
        error sending data to peers:
        \(error.localizedDescription)
        """) }
  }
  // 2
  var connectedPeers: [MCPeerID] {
    return mcSession.connectedPeers
  }
  
}

extension PeerSession: MCSessionDelegate {
  // 1
  func session(_ session: MCSession,
               peer peerID: MCPeerID,
               didChange state: MCSessionState) {
}
// 2
  func session(_ session: MCSession,
               didReceive data: Data,
               fromPeer peerID: MCPeerID) {
    receivedDataHandler(data, peerID)
  }
  // 3
  func session(_ session: MCSession,
               didReceive stream: InputStream,
               withName streamName: String,
               fromPeer peerID: MCPeerID) {
    fatalError("This service does not send/receive streams.")
  }
  // 4
  func session(_ session: MCSession,
               didStartReceivingResourceWithName resourceName: String,
               fromPeer peerID: MCPeerID,
               with progress: Progress) {
    fatalError("This service does not send/receive resources.")
  }
  // 5
  func session(_ session: MCSession,
               didFinishReceivingResourceWithName resourceName: String,
               fromPeer peerID: MCPeerID,
               at localURL: URL?,
               withError error: Error?) {
    fatalError("This service does not send/receive resources.")
  }
}
