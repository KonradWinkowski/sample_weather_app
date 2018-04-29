//
//  View.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/29/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import UIKit

extension UIView {
    
    func loadFromNib(_ name: String, bundle: Bundle? = nil) -> UIView! {
        return UINib(
            nibName: name,
            bundle: bundle
            ).instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
    }
}
