//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayDownImageName = "downImg1"
private let overlayUpImageName = "perfectImg"
private let overlayRightImageName = "double_heart"

class CustomOverlayView: OverlayView {
    
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var customImageView1: UIImageView!
    @IBOutlet weak var customImageView2: UIImageView!
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .up? :
                overlayImageView.image = UIImage(named: overlayUpImageName)
                customImageView1.image = nil
                customImageView2.image = nil
            case .down? :
                customImageView1.image = UIImage(named: overlayDownImageName)
                overlayImageView.image = nil
                customImageView2.image = nil
            case .right? :
                customImageView2.image = UIImage(named: overlayRightImageName)
                overlayImageView.image = nil
                customImageView1.image = nil
            default:
                overlayImageView.image = nil
                customImageView1.image = nil
                customImageView2.image = nil
            }
            
        }
    }
    
}
