import SwiftUI

final class SearchUserViewController: UIHostingController<SearchUserView> {
    // MARK: - Initializer
    
    init() {
        let viewModel = SearchUserViewModel()
        let view = SearchUserView(viewModel: viewModel)
        super.init(rootView: view)
        
        rootView.didUserInfoCellTapped = { [weak self] selectedUser in
                    self?.navigateTofriendViewController(with: selectedUser)
                }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Present Sheet or Navigation
    
    private func navigateTofriendViewController(with user: MolioUser) {
            let friendProfileViewController = FriendProfileViewController(
                isMyProfile: false,
                followRelation: .following,
                friendUserID: user.id // 선택된 유저 ID 전달
            )
            navigationController?.pushViewController(friendProfileViewController, animated: true)
        }
}
