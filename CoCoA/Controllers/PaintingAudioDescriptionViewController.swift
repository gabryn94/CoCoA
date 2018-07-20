import UIKit
import AVFoundation
import Foundation

class PaintingAudioDescriptionViewController: PaintingViewController {
    
    @IBOutlet weak var paintingImageView: UIImageView!
    
    @IBOutlet weak var pictogramsStackView: UIStackView!
    
    @IBOutlet weak var labelsStackView: UIStackView!
    
    private var shouldStart = false
    
    private var timer: Timer?
    
    private var pictogramsImageViews: [UIImageView] = []
    
    private var labels: [UILabel] = []
    
    private var player: AVPlayer!
    
    private var currentIndex: CGFloat = 10
    
    private var speed: PlayerViewController.Speed = .normal {
        didSet {
            if player.isPlaying {
                switch speed {
                case .slow:
                    player.rate = 0.9
                case .verySlow:
                    player.rate = 0.8
                case .veryVerySlow:
                    player.rate = 0.7
                case .normal:
                    player.rate = 1.0
                }
            }
        }
    }
    
    private var playerViewController: PlayerViewController? {
        didSet {
            playerViewController?.delegate = self
        }
    }
    
    private var currentPictograms: [String] = [] {
        didSet {
            renderNewPictograms()
        }
    }
    
    private var currentHighlitedPictogram: (range: ClosedRange<Double>, name: String) = (0...0, "") {
        didSet {
            highlightNewPictogram()
        }
    }
    
    private var canShowPictograms = false
    
    private let pictogramsUpdateLock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintingImageView.image = UIImage(named: painting.imageFilename)
//        paintingImageView.defaultBorder()
        paintingImageView.clipsToBounds = true
        
        let url = Bundle.main.url(forResource: painting.audioFilename, withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: updatePictogram)
        
        pictogramsImageViews = (0..<painting.maxNumberOfPictogramsPerFrame).map { _ in UIImageView() }
        labels = (0..<painting.maxNumberOfPictogramsPerFrame).map { _ in UILabel() }
        
        pictogramsImageViews.forEach(setupPictogramsImageView)
        labels.forEach(setupLabel)
        
    }
    
    private func setupLabel(_ label: UILabel) {
        label.textAlignment = .center
        labelsStackView.addArrangedSubview(label)
    }
    
    private func setupPictogramsImageView(_ imageView: UIImageView) {
        imageView.backgroundColor = #colorLiteral(red: 0.9802865933, green: 0.9802865933, blue: 0.9802865933, alpha: 0.07498899648)
//        imageView.defaultBorder()
//        imageView.defaultShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let playerViewController as PlayerViewController:
            self.playerViewController = playerViewController
            
        default:
            break
        }
        
    }
    
    private func updatePictogram(_ timer: Timer) {
        pictogramsUpdateLock.lock()
        
        defer {
            pictogramsUpdateLock.unlock()
        }
        
        guard canShowPictograms else {
            currentPictograms = []
            return
        }
        
        setPictogramsIfNeeded()
    }
    
    private func setPictogramsIfNeeded() {
        
        let currentTime = player.currentTime().seconds.truncate
        
        setCurrentPictograms(at: currentTime)
        setCurrentHighlightedPictogram(at: currentTime)
    }
    
    private func setCurrentPictograms(at second: Double) {
        let pictograms = painting.pictograms(for: second)
        
        if currentPictograms != pictograms {
            currentPictograms = pictograms
        }
    }
    
    private func setCurrentHighlightedPictogram(at second: Double) {
        guard player.isPlaying else {
            return
        }
        
        let highligtedPictogram = painting.highlightedPictogram(for: second)
        
        if currentHighlitedPictogram != highligtedPictogram {
            currentHighlitedPictogram = highligtedPictogram
        }
    }
    
    private func renderNewPictograms() {
        for view in pictogramsStackView.subviews {
            pictogramsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for i in 0..<currentPictograms.count {
            pictogramsImageViews[i].accessibilityIdentifier = currentPictograms[i]
            pictogramsImageViews[i].image = UIImage(named: "pictograms/\(currentPictograms[i]).png")
            labels[i].text = currentPictograms[i]
            pictogramsStackView.addArrangedSubview(pictogramsImageViews[i])
        }
    }
    
    private func highlightNewPictogram() {
        for i in 0..<pictogramsStackView.arrangedSubviews.count {
            if pictogramsStackView.arrangedSubviews[i].accessibilityIdentifier == currentHighlitedPictogram.name {
                zoom(i)
            }
        }
    }
    
    private func zoom(_ index: Int) {
        let view = pictogramsImageViews[index]
        let label = labels[index]
        let oldMatrix = view.transform
        let animationTime = (currentHighlitedPictogram.range.upperBound - currentHighlitedPictogram.range.lowerBound) / 2
        let scaleValue: CGFloat = 1.35
        let transformationMatrix = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        view.layer.zPosition = currentIndex
        currentIndex += 1
        UIView.animate(withDuration: animationTime, animations: {
            view.transform = transformationMatrix
            view.backgroundColor = .white
            label.transform = transformationMatrix
        }, completion: { _ in
            UIView.animate(withDuration: animationTime) {
                view.transform = oldMatrix
                view.backgroundColor = #colorLiteral(red: 0.9802865933, green: 0.9802865933, blue: 0.9802865933, alpha: 0.07498899648)
                label.transform = oldMatrix
            }
        })
    }
    
}

extension PaintingAudioDescriptionViewController: PlayerViewControllerDelegate {
    func didPressPlay(_ playerViewController: PlayerViewController) {
        canShowPictograms = true
        shouldStart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard self.shouldStart else {
                return
            }
            self.player.play()
            switch self.speed {
            case .slow:
                self.player.rate = 0.9
            case .verySlow:
                self.player.rate = 0.8
            case .veryVerySlow:
                self.player.rate = 0.7
            case .normal:
                self.player.rate = 1.0
            }
        }
    }
    
    func didPressPause(_ playerViewController: PlayerViewController) {
        shouldStart = false
        player.pause()
    }
    
    func didPressForward(_ playerViewController: PlayerViewController) {
        let newTime = player.currentTime() + CMTime(seconds: 5, preferredTimescale: player.currentTime().timescale)
        player.seek(to: newTime)
        updatePictogram(timer!)
        
    }
    
    func didPressBack(_ playerViewController: PlayerViewController) {
        let newTime = player.currentTime() - CMTime(seconds: 5, preferredTimescale: player.currentTime().timescale)
        player.seek(to: newTime)
        updatePictogram(timer!)
        
    }
    
    func didPressRepeat(_ playerViewController: PlayerViewController) {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }
    
    func playerViewController(_ playerViewController: PlayerViewController, didSelect speed: PlayerViewController.Speed) {
        self.speed = speed
    }
}
