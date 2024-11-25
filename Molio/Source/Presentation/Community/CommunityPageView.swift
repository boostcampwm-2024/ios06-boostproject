import SwiftUI

struct CommunityPageView: View {
    var userName: String
    var playlistCount: Int
    var musicCount: Int
    var followerCount: Int
    var profileImageURL: URL
    var userDescription: String
    
    var userPlaylists: [MolioPlaylist]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(userName)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink {
                        Text("설정")
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.main)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    AsyncImage(url: profileImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle())
                    .frame(width: 82, height: 82)
                    .background(.gray, in: .circle)

                    Spacer()
                    
                    VStack {
                        Text("플레이리스트")
                        
                        Text("\(playlistCount)")
                    }
                    .font(.pretendardSemiBold(size: 14))
                    
                    Spacer()
                    
                    VStack {
                        Text("팔로워")
                        
                        Text("\(followerCount)")
                    }
                    .font(.pretendardSemiBold(size: 14))
                }
                .frame(maxHeight: 80)
                .padding(30)
                .padding(.trailing)
                
                Text(userDescription)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .font(.pretendardRegular(size: 14))

                Spacer()
                
                // TODO: - 리스트 위치
                List {
                    ForEach(userPlaylists, id: \.id) { playlist in
                        NavigationLink {
                            Text("Playlist View")
                        } label: {
                            CommunityPagePlaylistCellView(playlist: playlist)
                        }
                        .listRowSeparatorTint(.gray)
                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .background(Color.background)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    CommunityPageView(
        userName: "John Doe",
        playlistCount: 12,
        musicCount: 300,
        followerCount: 1289,
        profileImageURL: URL(string: "https://via.placeholder.com/150")!,
        userDescription: "Music lover, playlist creator, and sound explorer!",
        userPlaylists: [
            MolioPlaylist(
                id: UUID(),
                name: "My Playlist",
                createdAt: Date(),
                musicISRCs: [],
                filters: ["팝", "힙합"]
            ),
            MolioPlaylist(
                id: UUID(),
                name: "My Playlist 2",
                createdAt: Date(),
                musicISRCs: [],
                filters: []
            ),
            MolioPlaylist(
                id: UUID(),
                name: "My Playlist 3",
                createdAt: Date(),
                musicISRCs: [],
                filters: []
            )
        ]
    )
}
