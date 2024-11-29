import SwiftUI

struct FriendPlaylistDetailView: View {
    @ObservedObject var viewModel: FriendPlaylistDetailViewModel

    weak var exportFriendsMusicToMyPlaylistDelegate: ExportFriendsMusicToMyPlaylistDelegate?
    
    init(
        viewModel: FriendPlaylistDetailViewModel
    ) {
        self._viewModel = ObservedObject(initialValue: viewModel)
    }
    
    mutating func setDelegate(_ delegate: ExportFriendsMusicToMyPlaylistDelegate) {
        self.exportFriendsMusicToMyPlaylistDelegate = delegate
    }
    
    var body: some View {
        VStack {
            Text.molioBold(viewModel.friendPlaylist?.name ?? "제목 없음", size: 34)
                .tint(.white)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: - 장르

            List { 
                ForEach(viewModel.friendPlaylistMusics, id: \.isrc) { molioMusic in
                    MusicCellView(music: molioMusic)
                        .foregroundStyle(.white)
                        .backgroundStyle(.clear)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.gray)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 0))
                        .swipeActions {
                            Button {
                                exportFriendsMusicToMyPlaylistDelegate?.exportFriendsMusicToMyPlaylist(molioMusic: molioMusic)
                                //
                            } label: {
                                Image
                                    .molioSemiBold(
                                        systemName: "square.and.arrow.up",
                                        size: 20,
                                        color: .main
                                    )
                            }
                            .tint(.mainLighter)
                        }
                    
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .background(Color.background)
    }
}

#Preview {
    VStack {
        Button {
            let usecase = DefaultUserUseCase()
            
            Task {
                try? await usecase.createUser(userID: "창우", userName: "창우이름", imageURL: nil, description: nil)
            }
        } label: {
            Text("유저 추가")
        }
        
        Button {
            let dto = MolioPlaylistMapper.map(from: .mock2)
            let usecase = FirestorePlaylistService()
            Task {
                try? await usecase.createPlaylist(playlist: dto)
            }
        } label: {
            Text("창우 플레이리스트 추가")
        }

    }
}


