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
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .medium)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemBlue
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
        updateUI()
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(modeLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(startPauseButton)
    }
    
    private func setupHierarchy() {
        view.addSubview(stackView)
    }
    
    private func setupLayout() {
           stackView.snp.makeConstraints { make in
               make.centerX.equalTo(view)
               make.centerY.equalTo(view)
           }
       }
    
    
    
    @objc private func startPausePressed() {
           if isStarted {
               pauseTimer()
           } else {
               startTimer()
           }
       }
       
       private func startTimer() {
           isStarted = true
           updateStartPauseButton()
           
           if !isAnimationStarted {
               drawForegroundLayer()
               startAnimation()
           } else {
               resumeAnimation()
           }
           
           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
       }
       
       private func pauseTimer() {
           isStarted = false
           updateStartPauseButton()
           timer.invalidate()
           pauseAnimation()
       }
       
       @objc private func timerFired() {
           if time > 0 {
