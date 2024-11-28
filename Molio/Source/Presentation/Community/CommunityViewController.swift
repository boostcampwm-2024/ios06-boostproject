import UIKit

final class CommunityViewController: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    // MARK: - Private func
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapSettingButton)
        )
    }
    
    // MARK: - objc func
    
    @objc private func didTapSettingButton() {
        let settingViewModel = SettingViewModel()
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}
