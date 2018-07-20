import UIKit

protocol PlayerViewControllerDelegate: class {
    func didPressPlay(_ playerViewController: PlayerViewController)
    func didPressPause(_ playerViewController: PlayerViewController)
    func didPressForward(_ playerViewController: PlayerViewController)
    func didPressBack(_ playerViewController: PlayerViewController)
    func didPressRepeat(_ playerViewController: PlayerViewController)
    func playerViewController(_ playerViewController: PlayerViewController, didSelect speed: PlayerViewController.Speed)
}

class PlayerViewController: UIViewController {

    static let storyboardIdentifier = "PlayerViewController"
    
    enum Speed {
        case normal
        case slow
        case verySlow
        case veryVerySlow
    }
    
    static private let refreshButtonSymbol = UIImage(named: "icons/Navigation_Refresh_2x.png")!
    
    static private let rewindButtonSymbol = UIImage(named: "icons/Navigation_Rewind_2x.png")!
    
    static private let playButtonSymbol = UIImage(named: "icons/Navigation_Play_2x.png")!
    
    static private let pauseButtonSymbol = UIImage(named: "icons/Navigation_Pause_2x.png")!
    
    static private let speedButtonSymbol = UIImage(named: "icons/QuickActions_Time_2x.png")!
    
    static private let forwardButtonSymbol = UIImage(named: "icons/Navigation_FastForward_2x.png")!
    
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    weak var delegate: PlayerViewControllerDelegate?
    
    var isPlaying = false {
        didSet {
            if isPlaying {
                playPauseButton.setImage(PlayerViewController.pauseButtonSymbol, for: .normal)
            } else {
                playPauseButton.setImage(PlayerViewController.playButtonSymbol, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.setImage(PlayerViewController.refreshButtonSymbol, for: .normal)
        rewindButton.setImage(PlayerViewController.rewindButtonSymbol, for: .normal)
        playPauseButton.setImage(PlayerViewController.playButtonSymbol, for: .normal)
        forwardButton.setImage(PlayerViewController.forwardButtonSymbol, for: .normal)
        speedButton.setImage(PlayerViewController.speedButtonSymbol, for: .normal)
//        refreshButton.defaultShadow()
//        rewindButton.defaultShadow()
//        playPauseButton.defaultShadow()
//        forwardButton.defaultShadow()
//        speedButton.defaultShadow()
        refreshButton.tintColor = UIColor.black
        rewindButton.tintColor = UIColor.black
        playPauseButton.tintColor = UIColor.black
        forwardButton.tintColor = UIColor.black
        speedButton.tintColor = UIColor.black
    }
    
    @IBAction func didPressPlayPause(_ sender: UIButton) {
        if isPlaying {
            delegate?.didPressPause(self)
        } else {
            delegate?.didPressPlay(self)
        }
        isPlaying.toggle()
    }
    
    @IBAction func didPressForward(_ sender: UIButton) {
        delegate?.didPressForward(self)
    }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        delegate?.didPressBack(self)
    }
    
    @IBAction func didPressRepeat(_ sender: UIButton) {
        delegate?.didPressRepeat(self)
        delegate?.didPressPause(self)
        
        if isPlaying {
            isPlaying.toggle()
        }
    }
    
    @IBAction func didPressSpeed(_ sender: UIButton) {
        presentSpeedSelectionAlert()
    }
    
    private func presentSpeedSelectionAlert() {
        let alertController = UIAlertController(title: "Seleziona velocità", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Normal", style: .default) { _ in
            self.delegate?.playerViewController(self, didSelect: .normal)
        })
        alertController.addAction(UIAlertAction(title: "Slow", style: .default) { _ in
            self.delegate?.playerViewController(self, didSelect: .slow)
        })
        alertController.addAction(UIAlertAction(title: "Very slow", style: .default) { _ in
            self.delegate?.playerViewController(self, didSelect: .verySlow)
        })
        alertController.addAction(UIAlertAction(title: "Very very slow", style: .default) { _ in
            self.delegate?.playerViewController(self, didSelect: .veryVerySlow)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
