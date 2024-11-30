import SwiftUI

struct SelectPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ManagePlaylistViewModel
    @State private var isModalPresented = false
    private let isCreatable: Bool
    
    init(viewModel: ManagePlaylistViewModel, isCreatable: Bool = true) {
        self.viewModel = viewModel
        self.isCreatable = isCreatable
    }
        
    var body: some View {
        ZStack {
            Color(.clear)
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                Text.molioBold("내 몰리오", size: 36) // TODO: 로그인 정보 불러와 적용하기
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 22)
                
                Spacer()
                    .frame(height: 5)
                
                List(viewModel.playlists, id: \.id) { playlist in
                    Button(action: {
                        viewModel.setCurrentPlaylist(playlist)
                    }) {
                        HStack {
                            Text.molioMedium(playlist.name, size: 18)
                                .tint(.white)
                                .opacity(0.8)
                                .frame(height: 50)
                            
                            Spacer()
                            if viewModel.currentPlaylist?.id == playlist.id {
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
               
                HStack(alignment: .center, content: {
                    Spacer()
                    
                    if isCreatable {
                        Button(action: {
                            isModalPresented.toggle()
                        }) {
                            Image.molioBlack(systemName: "plus", size: 20, color: .white)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .sheet(isPresented: $isModalPresented) {
                            CreatePlaylistView(viewModel: viewModel)
                                .presentationDetents([.fraction(0.5)])
                                .presentationDragIndicator(.visible)
                        }
                        .onChange(of: isModalPresented) { newValue in
                            if !newValue {
                                viewModel.fetchPlaylists()
                            }
                        }
                    }
                    
                    Spacer()
                })
                .padding(.top, 20)
                
                Spacer()
            }
        }.onDisappear {
            viewModel.changeCurrentPlaylist()
        }
    }
}

#Preview {
    SelectPlaylistView(viewModel: ManagePlaylistViewModel())
        .background(Color.background)
}
