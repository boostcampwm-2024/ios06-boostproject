import SwiftUI

struct SearchUserView: View {
    @StateObject var viewModel: SearchUserViewModel
    @State private var showAlert: Bool = false
    @State private var selectedUser: MolioFollower?
    
    var didUserInfoCellTapped: ((MolioFollower) -> Void)?
    var didTabLoginRequiredButton: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchBar(
                    searchText: $viewModel.searchText,
                    placeholder: "나의 몰리 찾기",
                    tintColor: .gray
                )
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                
                ScrollView {
                    ForEach(viewModel.searchedUser, id: \.id) { user in
                        
                        Button(action: {
                            didUserInfoCellTapped?(user)
                        }) {
                            UserInfoCell(
                                user: user,
                                followRelationType: user.followRelation,
                                isDescriptionVisible: false
                            ) { followType in
                                if followType == .following {
                                    // 언팔로우 시 Alert 표시
                                    selectedUser = user
                                    showAlert = true
                                } else {
                                    Task {
                                        await viewModel.updateFollowState(for: user, to: followType)

                                    }
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.background)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("언팔로우 확인"),
                    message: Text("\(selectedUser?.name ?? "")님을 언팔로우하시겠습니까?"),
                    primaryButton: .destructive(Text("언팔로우")) {
                        if let user = selectedUser {
                            Task {
                                await viewModel.updateFollowState(for: user, to: .following)
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                Task {
                    await viewModel.fetchAllUsers()
                }
            }
            if viewModel.shouldShowLoginRequired() {
                LoginRequiredView {
                    didTabLoginRequiredButton?()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.background
        SearchUserView(viewModel: SearchUserViewModel())
    }
}
