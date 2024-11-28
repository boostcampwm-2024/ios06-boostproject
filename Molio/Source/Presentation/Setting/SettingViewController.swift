import SwiftUI

final class SettingViewController: UIHostingController<SettingView> {
    // MARK: - Initializer
    
    init(viewModel: SettingViewModel) {
        let settingView = SettingView(viewModel: viewModel)
        super.init(rootView: settingView)
        
        setupButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "설정"
    }
    
    // MARK: - Private func
    
    private func setupButtonAction() {
        rootView.didTapMyInfoView = { [weak self] in
            let myInfoViewModel = MyInfoViewModel()
            let myInfoViewController = MyInfoViewController(viewModel: myInfoViewModel)
            self?.navigationController?.pushViewController(myInfoViewController, animated: true)
        }
    }
}
