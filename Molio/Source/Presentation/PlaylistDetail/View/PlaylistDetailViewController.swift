import SwiftUI

final class PlaylistDetailViewController: UIHostingController<PlaylistDetailView> {
    // MARK: - Initializer
    
    init(viewModel: PlaylistDetailViewModel) {
        let playlistDetailView = PlaylistDetailView(viewModel: viewModel)
        super.init(rootView: playlistDetailView)
        rootView.didPlaylistButtonTapped = { [weak self] in
            self?.presentPlaylistChangeSheet()
        }
        rootView.didExportButtonTapped = { [weak self] in
            self?.presentPlaylistExportSheet()
        }
    }

    required init?(coder aDecoder: NSCoder) {
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
        let platformSelectionView = PlatformSelectionView()
        self.presentCustomSheet(content: platformSelectionView)
    }
}
