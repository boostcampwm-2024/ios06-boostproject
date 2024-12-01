import SwiftUI

/// 유저 정보를 표시할 수 있는 셀
/// - `user` : 표시할 유저 정보
/// - `followRelationType` : 팔로잉 상태
/// - `isDescriptionVisible` : description 표시 여부
/// - `followTapAction` : 팔로잉 버튼 탭 액션
struct UserInfoCell: View {
    let user: MolioUser
    let followRelationType: FollowRelationType
    let isDescriptionVisible: Bool
    let followTapAction: ((FollowRelationType) -> Void)?
    
    init(
        user: MolioUser,
        followRelationType: FollowRelationType,
        isDescriptionVisible: Bool = true,
        followTapAction: ((FollowRelationType) -> Void)? = nil
    ) {
        self.user = user
        self.followRelationType = followRelationType
        self.isDescriptionVisible = isDescriptionVisible
        self.followTapAction = followTapAction
    }
    
    var body: some View {
        HStack {
            // MARK: - 이미지
            // TODO: 공통 컴포넌트로 수정해야 함. - ProfileImageView
            if let imageURL = user.profileImageURL {
                 AsyncImage(url: imageURL) { phase in
                     switch phase {
                     case .empty:
                         ProgressView()
                             .foregroundColor(.mainLighter)
                     case .success(let image):
                         image
                             .resizable()
                             .scaledToFill()
                             .clipShape(Circle())
                     case .failure(_):
                         DefaultProfile()
                     @unknown default:
                         EmptyView()
                     }
                 }
                 .frame(width: 50, height: 50)
             } else {
                 DefaultProfile()
             }
            // MARK: - 이름/설명
            VStack(alignment: .leading, spacing: 2) {
                Text.molioMedium(user.name, size: 17)
                    .foregroundStyle(.white)
                if isDescriptionVisible {
                    Text.molioRegular(user.description ?? "", size: 14)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // MARK: - 팔로잉 버튼
            VStack {
                switch followRelationType {
                case .unfollowing:
                    FollowRelationButton(type: .unfollowing) {
                        followTapAction?(.unfollowing)
                        print("팔로우 해야 함.")
                    }
                    
                case .following:
                    FollowRelationButton(type: .following) {
                        followTapAction?(.following)
                        print("언팔로우 해야 함.")
                    }
                }
            }
            .frame(width: 59)
            .padding(.vertical, 12)
        }
        .frame(height: 56)
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color.background
        VStack {
            // 팔로잉 버튼
            UserInfoCell(
                user: MolioUser.mock,
                followRelationType: .following,
                isDescriptionVisible: true // description 보임
            )
            UserInfoCell(
                user: MolioUser.mock,
                followRelationType: .following,
                isDescriptionVisible: false// description 보이지 x
            )
            // 언팔로잉 버튼
            UserInfoCell(
                user: MolioUser.mock,
                followRelationType: .unfollowing,
                isDescriptionVisible: true
            )
            UserInfoCell(
                user: MolioUser.mock,
                followRelationType: .unfollowing,
                isDescriptionVisible: false
            )
        }
    }
}
