import SwiftUI

struct SearchUserView: View {
    @StateObject var viewModel: SearchUserViewModel
    let followRelationType: FollowRelationType = .following
    
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
                    UserInfoCell(
                        user: user,
                        followRelationType: followRelationType,
                        isDescriptionVisible: false
                    ) { followType in
                        print(followType)
                    }
                }
            }
        }
        .background(Color.background)
    }
}

#Preview {
    ZStack {
        Color.background
        SearchUserView(viewModel: SearchUserViewModel())
    }
}
