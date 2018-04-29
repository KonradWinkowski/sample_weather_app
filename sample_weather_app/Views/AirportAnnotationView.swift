//
//  AirportAnnotationView.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation
import MapKit

final class AirportAnnotationView: MKAnnotationView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        viewInit()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    private func viewInit() {
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        _ = loadFromNib("AirportAnnotationView")
        view.frame = bounds
        addSubview(view)
        view.bindFrameToSuperviewBounds()
    }
    
}
