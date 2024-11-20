import UIKit
import Combine

final class SwipeMusicViewController: UIViewController {
    private let viewModel: SwipeMusicViewModel
    private var input: SwipeMusicViewModel.Input
    private var output: SwipeMusicViewModel.Output
    private let musicPlayer: AudioPlayer = SwipeMusicPlayer()

    private let musicCardDidChangeSwipePublisher = PassthroughSubject<CGFloat, Never>()
    private let musicCardDidFinishSwipePublisher = PassthroughSubject<CGFloat, Never>()
    private let likeButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    private let dislikeButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var isMusicCardAnimating = false
    private var pendingMusic: (currentMusic: SwipeMusicTrackModel?, nextMusic: SwipeMusicTrackModel?)
    private let basicBackgroundColor = UIColor(resource: .background)
    private var impactFeedBack = UIImpactFeedbackGenerator(style: .medium)
    private var hasProvidedImpactFeedback: Bool = false

    private let playlistSelectButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let selectedPlaylistTitleLabel: UILabel = {
        let label = UILabel()
        label.molioMedium(text: "🎧카공할 때 듣는 플리", size: 16) // TODO: 서버 연결시 text 제거
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playlistSelectArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc func showActionSheet() {
        let playlistView = CreatePlaylistView( onConfirm: {
            print("확인 버튼 눌림") // TODO: 확인 버튼 동작 추가
        })
        self.presentCustomSheet(
            content: playlistView
        )
    }
    
   
    private let currentCardView = MusicCardView()
    
    private let nextCardView: MusicCardView = {
        let nextCardView = MusicCardView()
        nextCardView.isUserInteractionEnabled = false
        return nextCardView
    }()
    
    private let filterButton = CircleMenuButton(backgroundColor: .black.withAlphaComponent(0.51),
                                                highlightColor: .white.withAlphaComponent(0.51),
                                                buttonSize: 58.0,
                                                tintColor: .white,
                                                buttonImage: UIImage(systemName: "slider.horizontal.3"),
                                                buttonImageSize: CGSize(width: 21.0, height: 19.0))
    
    private let dislikeButton = CircleMenuButton(backgroundColor: .black.withAlphaComponent(0.51),
                                                 highlightColor: .white.withAlphaComponent(0.51),
                                                 buttonSize: 66.0,
                                                 tintColor: UIColor(hex: "#FF3D3D"),
                                                 buttonImage: UIImage(systemName: "xmark"),
                                                 buttonImageSize: CGSize(width: 25.0, height: 29.0))
    
    private let likeButton = CircleMenuButton(backgroundColor: .black.withAlphaComponent(0.51),
                                              highlightColor: .white.withAlphaComponent(0.51),
                                              buttonSize: 66.0,
                                              tintColor: UIColor(resource: .main),
                                              buttonImage: UIImage(systemName: "heart.fill"),
                                              buttonImageSize: CGSize(width: 30.0, height: 29.0))
    
    private let myMolioButton = CircleMenuButton(backgroundColor: .black.withAlphaComponent(0.51),
                                                 highlightColor: .white.withAlphaComponent(0.51),
                                                 buttonSize: 58.0,
                                                 tintColor: UIColor(hex: "#FFFAFA"),
                                                 buttonImage: UIImage(systemName: "music.note"),
                                                 buttonImageSize: CGSize(width: 18.0, height: 24.0))
    
    init(viewModel: SwipeMusicViewModel) {
        self.viewModel = viewModel
        self.input = SwipeMusicViewModel.Input(
            musicCardDidChangeSwipe: musicCardDidChangeSwipePublisher.eraseToAnyPublisher(),
            musicCardDidFinishSwipe: musicCardDidFinishSwipePublisher.eraseToAnyPublisher(),
            likeButtonDidTap: likeButtonDidTapPublisher.eraseToAnyPublisher(),
            dislikeButtonDidTap: dislikeButtonDidTapPublisher.eraseToAnyPublisher()
        )
        self.output = viewModel.transform(from: input)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SwipeMusicViewModel()
        self.input = SwipeMusicViewModel.Input(
            musicCardDidChangeSwipe: musicCardDidChangeSwipePublisher.eraseToAnyPublisher(),
            musicCardDidFinishSwipe: musicCardDidFinishSwipePublisher.eraseToAnyPublisher(),
            likeButtonDidTap: likeButtonDidTapPublisher.eraseToAnyPublisher(),
            dislikeButtonDidTap: dislikeButtonDidTapPublisher.eraseToAnyPublisher()
        )
        self.output = viewModel.transform(from: input)

        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = basicBackgroundColor
        setupSelectPlaylistView()
        setupMusicTrackView()
        setupMenuButtonView()
        
        setupBindings()
        setupButtonTarget()
        addPanGestureToMusicTrack()
    }
    
    private func setupBindings() {
        output.currentMusicTrack
            .receive(on: RunLoop.main)
            .sink { [weak self] music in
                guard let self else { return }
                if isMusicCardAnimating {
                    self.pendingMusic.currentMusic = music
                } else {
                    self.updateCurrentCard(with: music)
                }
            }
            .store(in: &cancellables)
        
        output.nextMusicTrack
            .receive(on: RunLoop.main)
            .sink { [weak self] music in
                guard let self else { return }
                if isMusicCardAnimating {
                    self.pendingMusic.nextMusic = music
                } else {
                    nextCardView.configure(music: music)
                }
            }
            .store(in: &cancellables)
        
        output.buttonHighlight
            .receive(on: RunLoop.main)
            .sink { [weak self] buttonHighlight in
                guard let self else { return }
                self.likeButton.isHighlighted = buttonHighlight.isLikeHighlighted
                self.dislikeButton.isHighlighted = buttonHighlight.isDislikeHighlighted
            }
            .store(in: &cancellables)

        output.musicCardSwipeAnimation
            .receive(on: RunLoop.main)
            .sink { [weak self] swipeDirection in
                guard let self else { return }
                self.animateMusicCard(direction: swipeDirection)
            }
            .store(in: &cancellables)
    }
    
    private func loadAndPlaySongs(url: URL) {
        musicPlayer.loadSong(with: url)
        musicPlayer.play()
    }
    
    /// Swipe 동작이 끝나고 MusicCard가 animation되는 메서드
    private func animateMusicCard(direction: SwipeMusicViewModel.SwipeDirection) {
        let currentCenter = currentCardView.center
        let frameWidth = view.frame.width

        switch direction {
        case .left, .right:
            self.isMusicCardAnimating = true
            let movedCenterX = currentCenter.x + direction.rawValue * frameWidth
            UIView.animate(
                withDuration: 0.3,
                animations: { [weak self] in
                    self?.currentCardView.center = CGPoint(x: movedCenterX, y: currentCenter.y)
                },
                completion: { [weak self] _ in
                    guard let self else { return }
                    if let currentMusic = self.pendingMusic.currentMusic {
                        self.updateCurrentCard(with: currentMusic)
                        self.pendingMusic.currentMusic = nil
                    }
                    
                    if let nextMusic = self.pendingMusic.nextMusic {
                        self.nextCardView.configure(music: nextMusic)
                        self.pendingMusic.nextMusic = nil
                    }
                    
                    self.isMusicCardAnimating = false
            })
        case .none:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.currentCardView.center = self.nextCardView.center
            }
        }
    }
    
    /// 현재 노래 카드 정보 변경 및 현재 노래 재생하는 메서드
    private func updateCurrentCard(with music: SwipeMusicTrackModel) {
        let artworkBackgroundColor = music.artworkBackgroundColor
            .flatMap { UIColor(rgbaColor: $0) } ?? self.basicBackgroundColor
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = artworkBackgroundColor
        })
        
        currentCardView.configure(music: music)
        self.loadAndPlaySongs(url: music.previewAsset)
    }
    
    private func addPanGestureToMusicTrack() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        currentCardView.addGestureRecognizer(panGesture)
    }
    
    private func setupButtonTarget() {
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(didTapDislikeButton), for: .touchUpInside)
        playlistSelectButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    }

    /// 사용자에게 진동 feedback을 주는 메서드
    private func providedImpactFeedback(translationX: CGFloat) {
        if abs(translationX) > viewModel.swipeThreshold && !hasProvidedImpactFeedback {
            impactFeedBack.impactOccurred()
            hasProvidedImpactFeedback = true
        } else if abs(translationX) <= viewModel.swipeThreshold {
            hasProvidedImpactFeedback = false
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        
        if gesture.state == .changed {
            musicCardDidChangeSwipePublisher.send(translation.x)
            providedImpactFeedback(translationX: translation.x)
        } else if gesture.state == .ended {
            musicCardDidFinishSwipePublisher.send(translation.x)
        }
    }
    
    @objc private func didTapLikeButton() {
        likeButtonDidTapPublisher.send()
    }

    @objc private func didTapDislikeButton() {
        dislikeButtonDidTapPublisher.send()
    }
    
    @objc private func didTapFilterButton() {
        // TODO: - 선택된 장르 넘기기
        let musicViewModel = MusicFilterViewModel(selectedGenres: [])
        
        let musicFilterVC = MusicFilterViewController(rootView: MusicFilterView(viewModel: musicViewModel))
        navigationController?.pushViewController(musicFilterVC, animated: true)
    }
    
    private func setupSelectPlaylistView() {
        view.addSubview(playlistSelectButton)
        view.addSubview(selectedPlaylistTitleLabel)
        view.addSubview(playlistSelectArrowImageView)
        
        NSLayoutConstraint.activate([
            playlistSelectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            playlistSelectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playlistSelectButton.heightAnchor.constraint(equalToConstant: 39)
        ])
        
        NSLayoutConstraint.activate([
            selectedPlaylistTitleLabel.leadingAnchor.constraint(
                equalTo: playlistSelectButton.leadingAnchor, constant: 15),
            selectedPlaylistTitleLabel.centerYAnchor.constraint(equalTo: playlistSelectButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playlistSelectArrowImageView.leadingAnchor.constraint(
                equalTo: selectedPlaylistTitleLabel.trailingAnchor, constant: 10),
            playlistSelectArrowImageView.trailingAnchor.constraint(
                equalTo: playlistSelectButton.trailingAnchor, constant: -15),
            playlistSelectArrowImageView.centerYAnchor.constraint(equalTo: playlistSelectButton.centerYAnchor),
            playlistSelectArrowImageView.widthAnchor.constraint(equalToConstant: 18),
            playlistSelectArrowImageView.heightAnchor.constraint(equalToConstant: 19)
        ])
    }
    
    private func refreshCurrentMusicTrackView() {
        currentCardView.removeFromSuperview()
        
        view.insertSubview(currentCardView, aboveSubview: nextCardView)
        
        NSLayoutConstraint.activate([
            currentCardView.topAnchor.constraint(equalTo: playlistSelectButton.bottomAnchor, constant: 12),
            currentCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            currentCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            currentCardView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -107)
        ])
    }
    
    private func setupMusicTrackView() {
        // MARK: 다음 노래 카드
        view.insertSubview(nextCardView, belowSubview: playlistSelectButton)
        NSLayoutConstraint.activate([
            nextCardView.topAnchor.constraint(equalTo: playlistSelectButton.bottomAnchor, constant: 12),
            nextCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            nextCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nextCardView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -107)
        ])
        
        // MARK: 현재 노래 카드
        view.insertSubview(currentCardView, belowSubview: playlistSelectButton)
        NSLayoutConstraint.activate([
            currentCardView.topAnchor.constraint(equalTo: playlistSelectButton.bottomAnchor, constant: 12),
            currentCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            currentCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            currentCardView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -107)
        ])
    }
    
    private func setupMenuButtonView() {
        view.addSubview(menuStackView)
        menuStackView.addArrangedSubview(filterButton)
        menuStackView.addArrangedSubview(dislikeButton)
        menuStackView.addArrangedSubview(likeButton)
        menuStackView.addArrangedSubview(myMolioButton)
        
        NSLayoutConstraint.activate([
            menuStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22)
        ])
    }
}

// SwiftUI에서 SwipeViewController 미리보기
import SwiftUI
struct SwipeViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SwipeMusicViewController {
        let swipeMusicViewModel = SwipeMusicViewModel()
        return SwipeMusicViewController(viewModel: swipeMusicViewModel)
    }
    
    func updateUIViewController(_ uiViewController: SwipeMusicViewController, context: Context) {
        
    }
}

struct SwipeViewController_Previews: PreviewProvider {
    static var previews: some View {
        SwipeViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
    }
}



