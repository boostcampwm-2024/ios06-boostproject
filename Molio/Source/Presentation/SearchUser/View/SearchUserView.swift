import SwiftUI

struct SearchUserView: View {
    @State private var searchText: String = ""
    @State var searchedUser: [MolioUser] = [
        MolioUser.mock,
        MolioUser.mock,
        MolioUser.mock,
        MolioUser.mock,
        MolioUser.mock
    ]
    let followRelationType: FollowRelationType = .following
    
    var body: some View {
        VStack(spacing: 10) {
            SearchBar(searchText: $searchText, placeholder: "나의 몰리 찾기", tintColor: .gray)
                .padding(10)
            ScrollView {
                ForEach(searchedUser, id: \.id) { user in
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
    }
}

#Preview {
    ZStack {
        Color.background
        SearchUserView()
    }
}
