import SwiftUI

struct FollowRelationListView: View {
    @StateObject private var viewModel: FollowRelationViewModel
    private let followRelationType: FollowRelationType
    private let friendUserID: String?
    @State private var showAlert: Bool = false
    @State private var selectedUser: MolioFollower?
    
    var didUserInfoCellTapped: ((MolioFollower) -> Void)?

    init(
        viewModel: FollowRelationViewModel,
        followRelationType: FollowRelationType,
        friendUserID: String? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.followRelationType = followRelationType
        self.friendUserID = friendUserID
    }
    
    var body: some View {
        VStack {
            if viewModel.users.isEmpty {
                Text("사용자가 없습니다.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(viewModel.users, id: \.id) { user in
                        Button(action: {
                            didUserInfoCellTapped?(user)
                        }) {
                            UserInfoCell(
                                user: user,
                                followRelationType: user.followRelation
                            ) { followType in
                                if followType == .following {
                                    // 언팔로우 시 Alert 표시
                                    selectedUser = user
                                    showAlert = true
                                } else {
                                    Task {
                                        await viewModel.updateFollowState(for: user, to: followType, friendUserID: friendUserID)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("언팔로우 확인"),
                message: Text("\(selectedUser?.name ?? "")님을 언팔로우하시겠습니까?"),
                primaryButton: .destructive(Text("언팔로우")) {
                    if let user = selectedUser {
                        Task {
                            await viewModel.updateFollowState(for: user, to: user.followRelation, friendUserID: friendUserID)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchData(followRelationType: followRelationType, friendUserID: friendUserID)
                } catch {
                    print("Error fetching data: \(error.localizedDescription)")
                }
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
