import SwiftUI

struct FollowRelationListView: View {
    private let viewModel: FollowRelationViewModel
    private let followRelationType: FollowRelationType
    private let friendUserID: String?

    init(
        viewModel: FollowRelationViewModel,
        followRelationType: FollowRelationType,
        friendUserID: String?
    ) {
        self.viewModel = viewModel
        self.followRelationType = followRelationType
        self.friendUserID = friendUserID
    }
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                switch followRelationType {
                case .unfollowing:
                    ForEach(viewModel.followerUsers) { user in
                        userIntfoRowView(userName: user.name, description: user.description, imageURL: user.profileImageURL)
                            .padding(.vertical, 4)
                    }
                case .following:
                    ForEach(viewModel.followerUsers) { user in
                        userIntfoRowView(userName: user.name, description: user.description, imageURL: user.profileImageURL)
                            .padding(.vertical, 4)
                    }
                }
              
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        
    }
    
    func userIntfoRowView(userName: String, description: String?, imageURL: URL?) -> some View {
        HStack {
            ProfileImageView(imageURL: imageURL)
            VStack(alignment: .leading, spacing: 2) {
                Text.molioMedium(userName, size: 17)
                    .foregroundStyle(.white)
                Text.molioRegular(description ?? "", size: 14)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack {
                switch followRelationType {
                case .unfollowing:
                    FollowRelationButton(type: .unfollowing) {
                        print("언팔로우 해야 함.")
                    }
                    
                case .following:
                    FollowRelationButton(type: .following) {
                        print("언팔로우 해야 함.")
                    }
                }
            }
            .frame(width: 59)
            .padding(.vertical, 8)
        }
        .frame(height: 50)
        .padding(.horizontal, 22)
        .onAppear {
            Task {
                guard let friendUserID else {
                    try await viewModel.fecthMydData(followRelationType: followRelationType)
                    return
                }
                
                try await viewModel.fecthFreindData(followRelationType: followRelationType, friendUserID: friendUserID)
                
            }
        }
    }

}

// Preview에서 활용 가능
final class MockFollowRelationViewModel: ObservableObject {
    @Published var users: [MolioUser] = [
        MolioUser(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다."),
        MolioUser(id: UUID().uuidString, name: "이영희", description: "인디 아티스트이자 싱어송라이터입니다."),
        MolioUser(id: UUID().uuidString, name: "박민준", description: "DJ와 일렉트로닉 음악 프로듀서입니다."),
        MolioUser(id: UUID().uuidString, name: "최은지", description: "록 밴드 기타리스트입니다."),
        MolioUser(id: UUID().uuidString, name: "정수현", description: "영화 사운드트랙 제작을 즐깁니다."),
        MolioUser(id: UUID().uuidString, name: "한지민", description: "보컬 코치이자 합창단원입니다."),
        MolioUser(id: UUID().uuidString, name: "윤재호", description: "K-POP 열성팬입니다."),
        MolioUser(id: UUID().uuidString, name: "오서연", description: "힙합과 알앤비를 즐겨 듣는 음악 애호가입니다."),
        MolioUser(id: UUID().uuidString, name: "배성훈", description: "피아노와 기타 연주를 좋아합니다.")
    ]
}
