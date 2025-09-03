import UIKit
import AVFoundation

final class TrailerPlayerView: UIView {
    @IBOutlet private weak var activity: UIActivityIndicatorView!
    @IBOutlet private weak var playFullButton: UIButton!
    @IBOutlet private weak var muteButton: UIButton!
    
    var onTapPlayFull: (() -> Void)?
    var maxPreviewSeconds: Double = 20
    
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    private var avPlayer: AVPlayer?
    private var currentPlayerItem: AVPlayerItem?
    private var boundaryTimeObserver: Any?
    
    func configure(url: URL, autoplay: Bool = true, muted: Bool = true, previewSeconds: Double = 20) {
        cleanup()
        maxPreviewSeconds = previewSeconds
        
        let playerItem = AVPlayerItem(url: url)
        currentPlayerItem = playerItem
        
        let player = AVPlayer(playerItem: playerItem)
        player.isMuted = muted
        playerLayer.player = player
        avPlayer = player
        
        let boundaryTimes = [NSValue(time: CMTime(seconds: previewSeconds, preferredTimescale: 600))]
        boundaryTimeObserver = player.addBoundaryTimeObserver(forTimes: boundaryTimes, queue: .main) { [weak self] in
            self?.avPlayer?.pause()
        }
        
        activity.startAnimating()
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPlayToEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        if autoplay {
            player.play()
        }
        updateMuteIcon()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: TrailerPlayerView.self)
        let nib = UINib(nibName: "TrailerPlayerView", bundle: bundle)
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        else {
            return
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .black
        contentView.backgroundColor = .clear
        playerLayer.backgroundColor = UIColor.black.cgColor
        
        playFullButton.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        playFullButton.layer.cornerRadius = 12
        activity.hidesWhenStopped = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.videoGravity = .resizeAspectFill
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "status", let playerItem = object as? AVPlayerItem else { return }
        if playerItem.status == .readyToPlay {
            activity.stopAnimating()
        }
    }
    
    @objc private func didPlayToEnd() {
        avPlayer?.seek(to: .zero)
        avPlayer?.pause()
    }
    
    func stop() {
        avPlayer?.pause()
        avPlayer?.seek(to: .zero)
    }
    
    private func cleanup() {
        activity?.stopAnimating()
        
        if let observer = boundaryTimeObserver, let player = avPlayer {
            player.removeTimeObserver(observer)
        }
        boundaryTimeObserver = nil
        
        if let playerItem = currentPlayerItem {
            playerItem.removeObserver(self, forKeyPath: "status", context: nil)
        }
        currentPlayerItem = nil
        
        NotificationCenter.default.removeObserver(self)
        
        playerLayer.player = nil
        avPlayer = nil
    }
    
    deinit { cleanup() }
    
    @IBAction private func tapPlayFull(_: UIButton) {
        onTapPlayFull?()
    }
    
    @IBAction private func tapMute(_: UIButton) {
        avPlayer?.isMuted.toggle()
        updateMuteIcon()
    }
    
    private func updateMuteIcon() {
        muteButton.setTitle((avPlayer?.isMuted ?? true) ? "🔇" : "🔊", for: .normal)
    }
}
