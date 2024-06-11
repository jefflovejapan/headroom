//
//  ChartView.swift
//  FiltersNSliders
//
//  Created by Jeffrey Blagdon on 2024-06-11.
//

import Combine
import Foundation
import SwiftUI
import MetalKit
import UIKit

class ChartUIView: UIView {
    private let animationLayer = CAShapeLayer()
    var magnitudes: [Float] = [] {
        didSet {
            update(for: magnitudes)
        }
    }
    
    init() {
        super.init(frame: .zero)
        layer.addSublayer(animationLayer)
        animationLayer.strokeColor = UIColor.cyan.cgColor
        animationLayer.fillColor = UIColor.clear.cgColor
    }
    
    override func layoutSublayers(of layer: CALayer) {
        guard layer == self.layer else { return }
        animationLayer.frame = layer.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func update(for magnitudes: [Float]) {
        guard !magnitudes.isEmpty else {
            return
        }
        guard animationLayer.bounds.height > 0, animationLayer.bounds.width > 0 else {
            return
        }
        animationLayer.backgroundColor = UIColor.magenta.cgColor
        let path = UIBezierPath()
        path.lineWidth = 2
        path.move(to: CGPoint.zero)
        for (idx, mag) in magnitudes.enumerated() {
            path.addLine(to: CGPoint(
                x: (CGFloat(idx) / CGFloat(magnitudes.count) * animationLayer.bounds.width),
                y: animationLayer.bounds.height - (CGFloat(mag) * animationLayer.bounds.height)
            )
            )
        }
        
        animationLayer.path = path.cgPath
    }
}

struct ChartView: UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    
    class Coordinator {
        var cancellables: Set<AnyCancellable> = []
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ChartUIView {
        let chartView = ChartUIView()
        viewModel.$fftBins.sink { [weak chartView] magnitudes in
            chartView?.magnitudes = magnitudes
        }
        .store(in: &context.coordinator.cancellables)
        return chartView
    }
    
    func updateUIView(_ uiView: ChartUIView, context: Context) {}
}
