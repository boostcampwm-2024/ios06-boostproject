import Combine
import Foundation
import SwiftUI

struct SelectPlaylistToExportFriendMusicView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectPlaylistToExportFriendMusicViewModel
    
    init(
        viewModel: SelectPlaylistToExportFriendMusicViewModel
    ) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        ZStack {
            Color(.clear)
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                Text.molioBold("나의 플레이리스트로 내보내기", size: 36)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 22)
                
                Spacer()
                    .frame(height: 5)
                
                List(viewModel.playlists, id: \.id) { playlist in
                    Button(action: {
                        viewModel.selectPlaylist(playlist)
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
               
                
                Spacer()
                
                Button(action: {
                    let selectedMusic = viewModel.selectedMusic
                    
                    viewModel.exportMusicToMyPlaylist(music: selectedMusic)
                    
                    dismiss()
                }) {
                    Text("확인")
                        .font(.custom(PretendardFontName.Medium, size: 18))
                        .tint(.white)
                        .frame(height: 50)
                }
            }
        }
    }
}
