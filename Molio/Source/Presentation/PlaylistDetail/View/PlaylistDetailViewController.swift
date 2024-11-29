import SwiftUI

final class PlaylistDetailViewController: UIHostingController<PlaylistDetailView> {
    private let viewModel: PlaylistDetailViewModel
    
    // MARK: - Initializer
    
    init(viewModel: PlaylistDetailViewModel) {
        self.viewModel = viewModel
        let playlistDetailView = PlaylistDetailView(viewModel: viewModel)
        super.init(rootView: playlistDetailView)
        
        rootView.didPlaylistButtonTapped = presentPlaylistExportSheet
        rootView.didExportButtonTapped = presentPlaylistExportSheet
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = PlaylistDetailViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Present Sheet
    
    private func presentPlaylistChangeSheet() {
        let selectPlaylistView = SelectPlaylistView(viewModel: SelectPlaylistViewModel(), isCreatable: false)
        self.presentCustomSheet(content: selectPlaylistView)
    }
    
    private func presentPlaylistExportSheet() {
        let platformSelectionVC = PlatformSelectionViewController(viewModel: viewModel)
        platformSelectionVC.delegate = self
        self.presentCustomSheet(platformSelectionVC)
    }
    
    private func presentExportAppleMusicPlaylistView() {
        let exportAppleMusicPlaylistVC = ExportAppleMusicPlaylistViewController(viewModel: viewModel)
        self.presentCustomSheet(exportAppleMusicPlaylistVC, isOverFullScreen: true)
    }
    
    private func presentExportPlaylistImageView(with musics: [MolioMusic]) {
        let exportPlaylistViewModel = ExportPlaylistImageViewModel(musics: musics)
        let exportPlaylistImageVC = ExportPlaylistImageViewController(viewModel: exportPlaylistViewModel)
        self.presentCustomSheet(exportPlaylistImageVC, isOverFullScreen: true)
    }
}

extension PlaylistDetailViewController: PlatformSelectionViewControllerDelegate {
    /// PlatformSelectionView에서 내보내기 버튼 탭 시 호출
    /// - 플랫폼 선택 화면 시트를 내리고 다음 화면을 present
    func didSelectPlatform(with platform: ExportPlatform) {
        dismiss(animated: true) { [weak self] in
            switch platform {
            case .appleMusic:
                self?.presentExportAppleMusicPlaylistView()
            case .image:
                guard let musics = self?.viewModel.currentPlaylistMusics else { return }
                self?.presentExportPlaylistImageView(with: musics)
            }
        }
    }
}
