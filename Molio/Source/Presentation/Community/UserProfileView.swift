import SwiftUI

struct UserProfileView: View {
    private let playlistCount: Int = 2 // TODO: ViewModel 연결시 삭제
    private let followingCount: Int = 10 // TODO: ViewModel 연결시 삭제
    private let followerCount: Int = 20 // TODO: ViewModel 연결시 삭제
    
    let isMyProfile: Bool
    let followRelationType: FollowRelationType?
    
    @State var playlistsSample: [MolioPlaylist] = [
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz])),
        MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filter: MusicFilter(genres: [.pop, .rock, .jazz]))
        
    ]
    
    init(
        isMyProfile: Bool,
        followRelationType: FollowRelationType? = nil
    ) {
        self.isMyProfile = isMyProfile
        self.followRelationType = followRelationType
    }
    
    var body: some View {
        VStack {
            // MARK: - 상단 제목 및 기어 버튼
            HStack {
                Text("몰리오올리오")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                
                if isMyProfile {
                    Button(action: {
                        print("설정 버튼 클릭")
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.main)
                    }
                }
            }
            .padding(.horizontal, 22)
            
            // MARK: - 유저 정보 HStack
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 82, height: 82)
                
                GeometryReader { proxy in
                    HStack(spacing: 10) {
                        let size = CGSize(
                            width: (proxy.size.width - 20) / 3,
                            height: proxy.size.height
                        )
                        userInfoView(type: .playlist, value: playlistCount, size: size)
                        userInfoView(type: .following, value: followingCount, size: size)
                        userInfoView(type: .follower, value: followerCount, size: size)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: 82)
            .padding(.horizontal, 22)
            .padding(.top, 16)
            
            Spacer().frame(height: 21)
            
            // MARK: - 유저 description
            Text("몰리 덕후입니다. 플리 공유해요!")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
            
            Spacer().frame(height: 13)
            
            // MARK: - 팔로우 버튼
            if !isMyProfile, let followRelationType = followRelationType {
                FollowRelationButton(type: followRelationType)
                    .padding(.horizontal, 22)
                    .frame(height: 32)
            }
            
            Spacer().frame(height: 13)
            
            // MARK: - 유저 플레이리스트
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(playlistsSample, id: \.self) { playlist in
                        userPlaylistRowView(playlist: playlist)
                    }
                }
                .padding(.horizontal, 22)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    func userPlaylistRowView(playlist: MolioPlaylist) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(playlist.name)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                HStack {
                    ForEach(playlist.filter.genres, id: \.self) { genre in
                        FilterTag(content: genre.description)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(height: 70)
    }
    
    func userInfoView(type: UserInfoType, value: Int, size: CGSize) -> some View {
        VStack {
            Text(type.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Text("\(value)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: size.width, height: size.height)
    }
    
    enum UserInfoType: String {
        case playlist = "플레이리스트"
        case following = "팔로잉"
        case follower = "팔로워"
    }
}

#Preview {
    Group {
        UserProfileView(isMyProfile: true)
            .previewDisplayName("내 프로필")
        
        UserProfileView(isMyProfile: false, followRelationType: .following)
            .previewDisplayName("다른 사용자 (팔로우)")
        
        UserProfileView(isMyProfile: false, followRelationType: .unfollowing)
            .previewDisplayName("다른 사용자 (팔로우 안 함)")
    }
}
