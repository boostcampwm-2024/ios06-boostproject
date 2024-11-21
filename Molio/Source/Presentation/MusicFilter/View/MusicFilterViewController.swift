import SwiftUI

final class MusicFilterViewController: UIHostingController<MusicFilterView> {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .background
        
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func didTapSaveButton() {
        print("저장 버튼눌림")
    }
}

// MARK: - Preview

import SwiftUI

struct MusicFilterViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MusicFilterViewController {
        let musicFilterViewModel = MusicFilterViewModel()
        return MusicFilterViewController(rootView: MusicFilterView(viewModel: musicFilterViewModel))
    }
    
    func updateUIViewController(_ uiViewController: MusicFilterViewController, context: Context) {}
}

struct MusicFilterViewController_Previews: PreviewProvider {
    static var previews: some View {
        MusicFilterViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
