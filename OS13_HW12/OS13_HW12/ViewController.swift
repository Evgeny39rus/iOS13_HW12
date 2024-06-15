import UIKit
import SnapKit

final class ViewController: UIViewController, CAAnimationDelegate {
    // MARK: - Properties
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        drawBackgroundLayer()
        setupStackView()
        setupHierarchy()
        setupLayout()
        updateUI()
    }
    
    // MARK: - Setup Methods
    
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
    
    private func drawBackgroundLayer() {
        let center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        backgroundProgressLayer.path = circularPath.cgPath
        backgroundProgressLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundProgressLayer.fillColor = UIColor.clear.cgColor
        backgroundProgressLayer.lineWidth = 10
        view.layer.addSublayer(backgroundProgressLayer)
    }
    
    private func drawForegroundLayer() {
        let center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let animationColor: UIColor = isWorkTime ? .red : .green
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        foregroundProgressLayer.path = circularPath.cgPath
        foregroundProgressLayer.strokeColor = animationColor.cgColor
        foregroundProgressLayer.fillColor = UIColor.clear.cgColor
        foregroundProgressLayer.lineWidth = 8
        foregroundProgressLayer.strokeEnd = 0
        view.layer.addSublayer(foregroundProgressLayer)
    }
    
    // MARK: - Timer Methods
    
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
            time -= 1
            updateUI()
        } else {
            timer.invalidate()
            switchMode()
        }
    }
    
    private func switchMode() {
        isWorkTime.toggle()
        time = isWorkTime ? workTime : restTime
        modeLabel.text = isWorkTime ? "Work" : "Rest"
        resetProgress()
        startTimer()
    }
    
    // MARK: - UI Updates
    
    private func updateUI() {
        let minutes = time / 60
        let seconds = time % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        if time <= 10 {
            foregroundProgressLayer.strokeColor = UIColor.systemGreen.cgColor
            startPauseButton.tintColor = .systemGreen
        } else {
            foregroundProgressLayer.strokeColor = UIColor.systemBlue.cgColor
            startPauseButton.tintColor = .systemBlue
        }
    }
    
    private func updateStartPauseButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .medium)
        let symbolName = isStarted ? "pause.fill" : "play.fill"
        startPauseButton.setImage(UIImage(systemName: symbolName, withConfiguration: config), for: .normal)
    }
    
    // MARK: - Animation Methods
    
    private func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        foregroundProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        foregroundProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    private func pauseAnimation() {
        let pausedTime = foregroundProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foregroundProgressLayer.speed = 0.0
        foregroundProgressLayer.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        let pausedTime = foregroundProgressLayer.timeOffset
        foregroundProgressLayer.speed = 1.0
        foregroundProgressLayer.timeOffset = 0.0
        foregroundProgressLayer.beginTime = 0.0
        let timeSincePause = foregroundProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foregroundProgressLayer.beginTime = timeSincePause
    }
    
    private func resetProgress() {
        isAnimationStarted = false
        foregroundProgressLayer.removeFromSuperlayer()
    }
}

// MARK: - Extensions

extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180.0
    }
}

