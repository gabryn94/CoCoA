import UIKit
import AVFoundation

class PaintingTextDescriptionViewController: PaintingViewController {
    
    @IBOutlet weak var paintingImageView: UIImageView!
    
    @IBOutlet weak var paintingTextView: UITextView!
    
    var player: AVPlayer!
    
    lazy var playerViewController = initPlayerViewController()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: painting.audioFilename, withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        paintingImageView.image = UIImage(named: painting.imageFilename)
        paintingImageView.defaultBorder()
        paintingImageView.clipsToBounds = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icons/QuickActions_Audio_2x.png"),
            style: .plain,
            target: self,
            action: #selector(presentPlayerController))
        
        paintingTextView.text = painting.description
        
        
    }
    
    @objc func presentPlayerController() {
        playerViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(playerViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    private func initPlayerViewController() -> PlayerViewController {
        let playerViewController = storyboard?.instantiateViewController(withIdentifier: PlayerViewController.storyboardIdentifier) as! PlayerViewController
        playerViewController.delegate = self
        playerViewController.modalPresentationStyle = .popover
        playerViewController.preferredContentSize = CGSize(width: 350, height: 70)
        return playerViewController
    }
}

extension PaintingTextDescriptionViewController: PlayerViewControllerDelegate {
    func didPressPlay(_ playerViewController: PlayerViewController) {
        player.play()
        switch self.speed {
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
    
    func didPressPause(_ playerViewController: PlayerViewController) {
        player.pause()
    }
    
    func didPressForward(_ playerViewController: PlayerViewController) {
        let newTime = player.currentTime() + CMTime(seconds: 5, preferredTimescale: player.currentTime().timescale)
        player.seek(to: newTime)
    }
    
    func didPressBack(_ playerViewController: PlayerViewController) {
        let newTime = player.currentTime() - CMTime(seconds: 5, preferredTimescale: player.currentTime().timescale)
        player.seek(to: newTime)
    }
    
    func didPressRepeat(_ playerViewController: PlayerViewController) {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }
    
    func playerViewController(_ playerViewController: PlayerViewController, didSelect speed: PlayerViewController.Speed) {
        self.speed = speed
    }
}
