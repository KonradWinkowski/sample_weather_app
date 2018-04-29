//
//  AirportDetailViewController.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import UIKit

class AirportDetailViewController: UIViewController {

    @IBOutlet weak var infoSegmentControl: UISegmentedControl!
    
    public var station: Station? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func didChangeInfoType(_ sender: UISegmentedControl) {
        
    }

}
