import SwiftUI

struct SelectPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectPlaylistViewModel
    
    var placeholder: String = "00님의 몰리오"
    
    var body: some View {
        ZStack {
            Color(.clear)
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                Text("그냥님의 몰리오")
                    .font(.custom(PretendardFontName.Bold, size: 36))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 22)
                
                Spacer()
                    .frame(height: 5)
                
                List(viewModel.playlists) { playlist in
                    Button(action: {
                        viewModel.selectedPlaylist = playlist
                    }) {
                        HStack {
                            Text(playlist.name)
                                .font(.custom(PretendardFontName.Medium, size: 18))
                                .tint(.white)
                                .opacity(0.8)
                                .frame(height: 50)

                            Spacer()
                            if viewModel.selectedPlaylist?.id == playlist.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.main)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)

                }
                .frame(minHeight: 200)
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
                .scrollContentBackground(.hidden)

                HStack (alignment: .center, content: {
                    Spacer()
                    
                    Button(action: {
                    }) {
                        Image.molioBlack(systemName: "plus", size: 20, color: .white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                })
                .padding(.top, 20)
        
                Spacer()
            }
        }
    }
}

#Preview {
    SelectPlaylistView(viewModel: SelectPlaylistViewModel())
        .background(Color.background)
}
