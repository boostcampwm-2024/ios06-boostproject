import SwiftUI

struct SearchUserView: View {
    @StateObject var viewModel: SearchUserViewModel
    var didUserInfoCellTapped: ((MolioFollower) -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            SearchBar(
                searchText: $viewModel.searchText,
                placeholder: "나의 몰리 찾기",
                tintColor: .gray
            )
            .padding(10)
            
            ScrollView {
                ForEach(viewModel.searchedUser, id: \.id) { user in
                    
                    Button(action: {
                        didUserInfoCellTapped?(user)
                    }) {
                        UserInfoCell(
                            user: user,
                            followRelationType: user.state ? .following : .unfollowing,
                            isDescriptionVisible: false
                        ) { followType in
                            print(followType)
                        }
                    }
                }
            }
        }
        .background(Color.background)
        .onAppear {
            viewModel.fetchAllUsers()
        }
    }
}

#Preview {
    ZStack {
        Color.background
        SearchUserView(viewModel: SearchUserViewModel())
    }
}
