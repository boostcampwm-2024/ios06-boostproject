import SwiftUI

final class MusicFilterViewController: UIHostingController<MusicFilterView> {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.molioSemiBold(text: "내 필터 편집", size: 17)
        label.textColor = .white
        return label
    }()
    
    private let saveButtonItemLabel: UILabel = {
        let label = UILabel()
        label.molioRegular(text: "저장", size: 17)
        label.textColor = .main
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .background
        
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButtonItemLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
