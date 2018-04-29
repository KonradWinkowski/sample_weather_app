//
//  AirportDetailViewController.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import UIKit

enum DetailViewMode {
    case info
    case metar
}

class AirportDetailViewController: UIViewController {

    @IBOutlet weak var infoSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    public var viewMode: DetailViewMode = .info
    
    public var station: Station? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var metar: Metar? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 5.0
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Metar
    
    private func request(metarFor icao: String?) {
        
        guard let airportIcao = icao else {
            return
        }
        
        WeatherDataService.service.metar(for: airportIcao) { [weak self] (metar, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    self?.addBackroundViewToTableWith()
                    return
                }
                
                guard let mtar = metar else {
                    self?.addBackroundViewToTableWith()
                    return
                }
                
                self?.metar = mtar
            }
            
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func didChangeInfoType(_ sender: UISegmentedControl) {
        
        viewMode = sender.selectedSegmentIndex == 0 ? .info : .metar
        
        tableView.reloadData()
        
        if viewMode == .metar {
            
            if metar == nil {
                addBackroundViewToTableWith(text: "Getting METAR information...")
                request(metarFor: station?.icao)
            }
            
        }
        
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper
    
    private func removeBackgroundView() {
        tableView.backgroundView = nil
    }
    
    private func addBackroundViewToTableWith(text: String? = "Failed to get METAR information") {
        removeBackgroundView()
        
        let label = UILabel(frame: tableView.bounds)
        label.textColor = UIColor(red: 0.25, green: 0.61, blue: 0.71, alpha: 1.0)
        label.font = UIFont(name: "AvenirNext-Regular", size: 21.0)
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        tableView.backgroundView = label
        
    }
}

extension AirportDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewMode {
        case .info:
            return 76
        case.metar:
            return 76
        }
    }
    
}

extension AirportDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewMode {
        case .info:
            return 10
        case .metar:
            return metar != nil ? 9 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: InfoTableViewCell! = tableView.dequeueReusableCell(withIdentifier: K.TableViewCell.infoTableViewCell, for: indexPath) as? InfoTableViewCell
        
        if cell == nil {
            cell = InfoTableViewCell(style: .default, reuseIdentifier: K.TableViewCell.infoTableViewCell)
        }
        
        switch viewMode {
        case .info:
            return setup(cell: cell, forInfoViewAt: indexPath)
        case .metar:
            return setup(cell: cell, forMETARViewAt: indexPath)
        }
        
    }
    
    private func setup(cell: InfoTableViewCell, forInfoViewAt indexPath: IndexPath) -> InfoTableViewCell {
        
        switch indexPath.row {
        case 0:
            cell.itemNameLabel.text = "ICAO"
            cell.itemDetailLabel.text = station?.icao
        case 1:
            cell.itemNameLabel.text = "Name"
            cell.itemDetailLabel.text = station?.name
        case 2:
            cell.itemNameLabel.text = "Address"
            cell.itemDetailLabel.text = station?.address
        case 3:
            cell.itemNameLabel.text = "Type"
            cell.itemDetailLabel.text = station?.type
        case 4:
            cell.itemNameLabel.text = "Useage"
            cell.itemDetailLabel.text = station?.useage
        case 5:
            cell.itemNameLabel.text = "Status"
            cell.itemDetailLabel.text = station?.status
        case 6:
            cell.itemNameLabel.text = "Elevation"
            
            if let elevtion = station?.elevation.feet {
                cell.itemDetailLabel.text = "\(elevtion) ft"
            } else {
                cell.itemDetailLabel.text = "NA"
            }
            
        case 7:
            cell.itemNameLabel.text = "TimeZone"
            cell.itemDetailLabel.text = station?.timezone?.tzid
        case 8:
            cell.itemNameLabel.text = "Location"
            cell.itemDetailLabel.text = "\(station?.latitude.decimal ?? -1)\n\(station?.longitude.decimal ?? -1)"
        case 9:
            cell.itemNameLabel.text = "Magnetic Variation"
            
            if let mv = station?.magnetic_variation {
                cell.itemDetailLabel.text = mv
            } else {
                cell.itemDetailLabel.text = "NA"
            }
        default:
            break
        }
        
        return cell
    }
    
    private func setup(cell: InfoTableViewCell, forMETARViewAt indexPath: IndexPath) -> InfoTableViewCell {
        
        guard let metar = self.metar else {
            cell.itemNameLabel.text = "NA"
            cell.itemDetailLabel.text = "NA"
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.itemNameLabel.text = "Category"
            cell.itemDetailLabel.text = metar.flight_category
        case 1:
            cell.itemNameLabel.text = "Raw"
            cell.itemDetailLabel.text = metar.raw_text
        case 2:
            cell.itemNameLabel.text = "Date/Time"
            cell.itemDetailLabel.text = metar.observed
        case 3:
            cell.itemNameLabel.text = "Wind"
            
            var detailText = "\(metar.wind.degrees)˚ w/ wind speed of \(metar.wind.speed_kts) kts"
            if let gusts = metar.wind.gust_kts {
                detailText = detailText + " gusts up to \(gusts) kts"
            }
            cell.itemDetailLabel.text = detailText
        case 4:
            cell.itemNameLabel.text = "Visibility"
            cell.itemDetailLabel.text = "\(metar.visibility.miles) miles"
        case 5:
            cell.itemNameLabel.text = "Clouds"
            if let cloud = metar.clouds.first {
                cell.itemDetailLabel.text = "\(cloud.text) \(cloud.base_feet_agl)"
            } else {
                cell.itemDetailLabel.text = "N/A"
            }
        case 6:
            cell.itemNameLabel.text = "Temp : \(metar.temperature.fahrenheit)˚ F / \(metar.temperature.celsius)˚ C"
            cell.itemDetailLabel.text = "Dew : \(metar.dewpoint.fahrenheit)˚ F / \(metar.dewpoint.celsius)˚ C"
        case 7:
            cell.itemNameLabel.text = "Altimeter"
            cell.itemDetailLabel.text = "\(metar.barometer.hg)"
        case 8:
            cell.itemNameLabel.text = "Humidity"
            cell.itemDetailLabel.text = "\(metar.humidity_percent) %"
        default:
            break
        }
        
        return cell
        
    }
    
}
