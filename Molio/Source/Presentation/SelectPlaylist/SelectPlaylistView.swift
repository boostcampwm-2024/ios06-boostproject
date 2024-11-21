import SwiftUI

struct SelectPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    var playlists: [MolioPlaylist] = [MolioPlaylist(id: UUID(), name: "플레이리스트 1", createdAt: Date(), musicISRCs: [], filters: []), MolioPlaylist(id: UUID(), name: "플레이리스트 2", createdAt: Date(), musicISRCs: [], filters: [])]
    
    //@ObservedObject var viewModel: CreatePlaylistViewModel
    
    var placeholder: String = "00님의 몰리오"
    
    var body: some View {
        ZStack {
            Color(.clear)
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                    .frame(height: 40)
                
                Text("그냥님의 몰리오")
                    .font(.custom(PretendardFontName.Bold, size: 28))
                    .foregroundStyle(Color.white)
                
                List(playlists) { playlist in
                    Button(action: {
                    }) {
                        HStack {
                            Text(playlist.name)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .background(Color.clear)
                Spacer()
            }
            .padding(.horizontal, 22)
            
        }.ignoresSafeArea()
    }
}

#Preview {
    SelectPlaylistView()
        .background(Color.background)
}
