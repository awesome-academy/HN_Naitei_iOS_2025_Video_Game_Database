//
//  FilterViewController.swift
//  VideoGameDatabase
//
//  Created by macbook on 20/8/25.
//

import UIKit

final class FilterViewController: UIViewController {
    
    @IBOutlet private weak var platformSegment: UISegmentedControl!
    @IBOutlet private weak var dateSegment: UISegmentedControl!
    @IBOutlet private weak var sortSegment: UISegmentedControl!
    @IBOutlet private weak var metacriticSlider: UISlider!
    @IBOutlet private weak var metacriticValueLabel: UILabel!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    // MARK: - Inputs/Outputs
    var current: FilterOptions = .default
    var onApply: ((FilterOptions)->Void)?
    var onClear: ((FilterOptions)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render(from: current)
    }
    
    private func configureUI() {
        title = "Filters"
    }
    
    private func render(from filters: FilterOptions) {
        platformSegment.selectedSegmentIndex = filters.platform.rawValue
        dateSegment.selectedSegmentIndex     = filters.dateRange.rawValue
        sortSegment.selectedSegmentIndex     = filters.sort.rawValue
        metacriticSlider.minimumValue = 0
        metacriticSlider.maximumValue = 100
        metacriticSlider.value = Float(filters.metacriticMin)
        metacriticValueLabel.text = "Metacritic ≥ \(filters.metacriticMin)"
    }
    
    // MARK: - Actions
    @IBAction private func sliderChanged(_ sender: UISlider) {
        let v = Int(sender.value.rounded())
        metacriticValueLabel.text = "Metacritic ≥ \(v)"
    }
    
    @IBAction private func clearTapped(_ sender: UIButton) {
        current = .default
        render(from: current)
        onClear?(current)
        dismiss(animated: true)
    }
    
    @IBAction private func applyTapped(_ sender: UIButton) {
        var f = FilterOptions()
        f.platform     = FilterOptions.Platform(rawValue: platformSegment.selectedSegmentIndex) ?? .all
        f.dateRange    = FilterOptions.DateRange(rawValue: dateSegment.selectedSegmentIndex) ?? .any
        f.sort         = FilterOptions.Sort(rawValue: sortSegment.selectedSegmentIndex) ?? (.relevance)
        f.metacriticMin = Int(metacriticSlider.value.rounded())
        
        onApply?(f)
        dismiss(animated: true)
    }
}
