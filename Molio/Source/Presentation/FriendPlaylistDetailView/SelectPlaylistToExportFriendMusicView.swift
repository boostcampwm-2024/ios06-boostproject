import Combine
import SwiftUI

struct SelectPlaylistToExportFriendMusicView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectPlaylistToExportFriendMusicViewModel
    @State private var showConfirmationAlert = false
    
    init(viewModel: SelectPlaylistToExportFriendMusicViewModel) {
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
                
                Button{
                    showConfirmationAlert.toggle()
                } label: {
                    Text("추가하기")
                        .font(.custom(PretendardFontName.Medium, size: 18))
                        .foregroundStyle(.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.mainLighter, in: .rect(cornerRadius: 15))
                }
                .padding()
                .alert("내 플레이리스트에 노래 추가", isPresented: $showConfirmationAlert) {
                    Button("아니요", role: .cancel) {
                        
                    }

                    Button("네", role: .destructive) {
                        let selectedMusic = viewModel.selectedMusic
                        viewModel.exportMusicToMyPlaylist(music: selectedMusic)
                        dismiss()
                    }
                } message: {
                    Text("몰리오올리오님의 노래를 내 플레이리스트에 추가할까요?")
                }

                
                Spacer()
                    .frame(height: 1)
            }
        }
    }
}
