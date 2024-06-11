//
//  ViewController.swift
//  OS13_HW12
//
//  Created by Евгений Сушков on 10.06.2024.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, CAAnimationDelegate {
    private var isWorkTime = true
    private var isStarted = false
    private var isAnimationStarted = false
    private var timer = Timer()
    private let workTime = 25
    private let restTime = 10
    private var time = 25
    
    private let foregroundProgressLayer = CAShapeLayer()
    private let backgroundProgressLayer = CAShapeLayer()
    
    // MARK: - Outlets
    
    private lazy var modeLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private var startPauseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(startPausePressed), for: .touchUpInside)
        button.setImage(getImage("play"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        drawBackgroundLayer()
        setupStackView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(modeLabel)
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(startPauseButton)
    }
    
    private func setupHierarchy() {
        view.addSubviews(stackView)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalToSuperview().offset (100)
            make.bottom.equalToSuperview() .offset(-100)
        }
    }
    
    private func drawBackgroundLayer() {
        backgroundProgressLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
            radius: 150, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true
        ).cgPath
        backgroundProgressLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundProgressLayer.fillColor = UIColor.clear.cgColor
        backgroundProgressLayer.lineWidth = 10
        view.layer.addSublayer(backgroundProgressLayer)
    }
}
