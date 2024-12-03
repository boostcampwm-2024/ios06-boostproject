import SwiftUI

// MARK: - Implementation

final class MusicFilterViewController: UIHostingController<MusicFilterView> {
    typealias DismissCompletion = ([MusicGenre]?) -> Void // 필터 화면 pop이후 수행할 동작
    
    weak var delegate: MusicFilterViewControllerDelegate?
    private var onDismissCompletion: DismissCompletion?
    
    // MARK: - Initializer
    
    init(
        viewModel: MusicFilterViewModel,
        onDismissCompletion: DismissCompletion?
    ) {
        delegate = viewModel
        let musicFilterView = MusicFilterView(viewModel: viewModel)
        self.onDismissCompletion = onDismissCompletion
        super.init(rootView: musicFilterView)
        
        rootView.saveButtonTapAction = { [weak self] in
            self?.didTapSaveButton()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        onDismissCompletion = { _ in }
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onDismissCompletion?(nil)
    }
    
    // MARK: - Event
    
    private func didTapSaveButton() {
        Task {
            do {
                guard let delegate = delegate else { return }
                let updatedFilter = try await delegate.didSaveButtonTapped()
                showAlertWithOKButton(title: "필터 수정이 완료되었습니다.") { [weak self] _ in
                    self?.dismiss(animated: true)
                    self?.onDismissCompletion?(updatedFilter)
                }
            } catch {
                showAlertWithOKButton(title: "필터 수정에 실패했습니다", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Delegate

protocol MusicFilterViewControllerDelegate: AnyObject {
    func didSaveButtonTapped() async throws -> [MusicGenre]
}

// MARK: - Preview

struct MusicFilterViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MusicFilterViewController {
        let musicFilterViewModel = MusicFilterViewModel()
        return MusicFilterViewController(viewModel: musicFilterViewModel) { _ in }
    }
    
    func updateUIViewController(_ uiViewController: MusicFilterViewController, context: Context) {}
}

struct MusicFilterViewController_Previews: PreviewProvider {
    static var previews: some View {
        MusicFilterViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
