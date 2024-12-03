import SwiftUI

// MARK: - Implementation

final class MusicFilterViewController: UIHostingController<MusicFilterView> {
    typealias PopCompletion = ([MusicGenre]) -> Void // 필터 화면 pop이후 수행할 동작
    
    weak var delegate: MusicFilterViewControllerDelegate?
    private var onPopCompletion: PopCompletion
    
    // MARK: - Initializer
    
    init(
        viewModel: MusicFilterViewModel,
        onPopCompletion: @escaping PopCompletion
    ) {
        delegate = viewModel
        let musicFilterView = MusicFilterView(viewModel: viewModel)
        self.onPopCompletion = onPopCompletion
        super.init(rootView: musicFilterView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        onPopCompletion = { _ in }
        super.init(coder: aDecoder)
    }
    
    // MARK: - Navigation Bar Item
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.molioSemiBold(text: "내 필터 편집", size: 17)
        label.textColor = .white
        return label
    }()
    
    private let saveButton = UIButton.molioRegular(text: "저장",
                                                   size: 17,
                                                   foregroundColor: .main)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Event
    
    @objc func didTapSaveButton() {
        Task {
            do {
                guard let delegate = delegate else { return }
                let updatedFilter = try await delegate.didSaveButtonTapped()
                showAlertWithOKButton(title: "필터 수정이 완료되었습니다.") { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                    self?.onPopCompletion(updatedFilter)
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
