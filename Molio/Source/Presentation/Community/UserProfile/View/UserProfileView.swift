import SwiftUI


enum UserInfoType: String {
    case playlist = "플레이리스트"
    case following = "팔로잉"
    case follower = "팔로워"
}


struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @State private var showAlert: Bool = false
    
    var didNotificationButtonTapped: (() -> Void)?
    var didSettingButtonTapped: (() -> Void)?
    var didFollowingButtonTapped: ((ProfileType) -> Void)?
    var didFollowerButtonTapped: ((ProfileType) -> Void)?
    var didPlaylistCellTapped: ((MolioPlaylist) -> Void)?
    
    init(
        viewModel: UserProfileViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else {
                VStack {
                    // MARK: - 상단 제목 및 기어 버튼
                    HStack {
                        Text(viewModel.user?.name ?? "로그인해야 닉네임을 입력할 수 있어요")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        
                        if case .me = viewModel.profileType {
                            Button(action: {
                                didNotificationButtonTapped?()
                            }) {
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(.main)
                            }
                            Spacer()
                                .frame(width: 14)
                            
                            Button(action: {
                                didSettingButtonTapped?()
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundStyle(.main)
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 20)

                    // MARK: - 유저 정보 HStack
                    HStack {
                        ProfileImageView(imageURL: viewModel.user?.profileImageURL, size: 56)
                        
                        GeometryReader { proxy in
                            HStack(spacing: 10) {
                                let size = CGSize(
                                    width: (proxy.size.width - 20) / 3,
                                    height: proxy.size.height
                                )
                                UserInfoView(type: .playlist, value: viewModel.playlists.count, size: size)
                                
                                Button(action: {
                                    didFollowerButtonTapped?(viewModel.profileType)
                                }) {
                                    UserInfoView(type: .follower, value: viewModel.followers.count, size: size)
                                }
                                
                                Button(action: {
                                    didFollowingButtonTapped?(viewModel.profileType)
                                }) {
                                    UserInfoView(type: .following, value: viewModel.followings.count, size: size)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 82)
                    .padding(.horizontal, 22)
                    .padding(.top, 16)
                                        
                    // MARK: - 유저 description
                    
                    if let description = viewModel.user?.description, description != "" {
                        Spacer().frame(height: 21)

                        Text(description)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 22)
                        
                        Spacer().frame(height: 13)
                        
                    }
                    
                    // MARK: - 팔로우 버튼
                    if case let .friend(_, isFollowing) = viewModel.profileType {
                        if let followRelation = viewModel.user?.followRelation {
                            FollowRelationButton(type: followRelation) {
                                if followRelation == .following {
                                    // 언팔로우 시 Alert 표시
                                    showAlert = true
                                } else {
                                    Task {
                                        await viewModel.updateFollowState(to: followRelation)
                                    }
                                }
                            }
                            .padding(.horizontal, 22)
                            .frame(height: 32)
                        }
                    }
                    
                    Spacer().frame(height: 13)
                    
                    Divider()
                        .background(Color.gray)
                    
                    // MARK: - 유저 플레이리스트
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack {
                            ForEach(viewModel.playlists, id: \.self) { playlist in
                                Button(action: {
                                    didPlaylistCellTapped?(playlist)
                                }) {
                                    UserPlaylistRowView(playlist: playlist)
                                }
                            }
                        }
                        .padding(.horizontal, 22)
                    }
                    
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("언팔로우 확인"),
                    message: Text("\(viewModel.user?.name ?? "")님을 언팔로우하시겠습니까?"),
                    primaryButton: .destructive(Text("언팔로우")) {
                        Task {
                            await viewModel.updateFollowState(to: .following)
                        }
                        
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                Task {
                    await viewModel.fetchData()
                }
            }
    }
}

struct UserPlaylistRowView: View {
    let playlist: MolioPlaylist
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(playlist.name)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                HStack {
                    ForEach(playlist.filter, id: \.self) { genre in
                        FilterTag(content: genre.description)
                            .lineLimit(1) 
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
                .allowsTightening(true)
                .clipped()
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(height: 70)
    }
    
}

struct UserInfoView: View {
    let type: UserInfoType
    let value: Int
    let size: CGSize
    
    var body: some View {
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
}
