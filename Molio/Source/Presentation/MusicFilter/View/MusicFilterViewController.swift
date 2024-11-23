import SwiftUI

// MARK: - Implementation

final class MusicFilterViewController: UIHostingController<MusicFilterView> {
    typealias PopCompletion = (MusicFilter) -> Void // 필터 화면 pop이후 수행할 동작
    
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
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
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
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: PretendardFontName.Regular, size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.main
        ]
        let attributedTitle = NSAttributedString(string: "저장", attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .background
        
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Event
    
    @objc func didTapSaveButton() {
        print(#fileID, #function)
        Task {
            do {
                guard let delegate = delegate else { return }
                let updatedFilter = try await delegate.didSaveButtonTapped()
                showAlertWithOKButton(title: "필터 수정이 완료되었습니다.") { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                    self?.onPopCompletion(updatedFilter)
                }
            } catch {
                // TODO: - 에러 처리
            }
        }
    }
}

// MARK: - Delegate

protocol MusicFilterViewControllerDelegate: AnyObject {
    func didSaveButtonTapped() async throws -> MusicFilter
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
