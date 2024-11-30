import SwiftUI

final class SearchUserViewController: UIHostingController<SearchUserView> {
    // MARK: - Initializer
    
    init() {
        let viewModel = SearchUserViewModel()
        let view = SearchUserView(viewModel: viewModel)
        super.init(rootView: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
}
