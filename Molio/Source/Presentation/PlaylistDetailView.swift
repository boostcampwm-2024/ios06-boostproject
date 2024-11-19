//import SwiftUI
//import Combine
//
//struct PlaylistDetailView: View {
//    @ObservedObject private var viewModel = PlaylistDetailViewModel(
//        playlistRepository: MockCurrentPlaylistRepository(),
//        parallelMusicFetchForISRCsUseCase: DefaultParallelMusicFetchForISRCsUseCase()
//    )
//    
//    init(
//        playlistRepository: some CurrentPlaylistRepository,
//        parallelMusicFetchForISRCsUseCase: some ParallelMusicFetchForISRCsUseCase
//    ) {
//        self._viewModel = playlistRepository
//    }
//
//    @State private var isPlaylistChangeSheetPresented: Bool = false
//    
//    var body: some View {
//        List {
//            ForEach(viewModel.currentPlaylist?.musicISRCs, id: \.self) { _ in
//                PlaylistDetailListItemView(music: .apt)
//                    .foregroundStyle(.white)
//                    .backgroundStyle(.clear)
//                    .listRowBackground(Color.clear)
//                    .listRowSeparatorTint(.gray)
//                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
//            }
//        }
//        .listStyle(.plain)
//        .background(Color.background)
//        .scrollContentBackground(.hidden)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    isPlaylistChangeSheetPresented.toggle()
//                } label: {
//                    Text(viewModel.currentPlaylist?.name ?? "제목 없음")
//                        .foregroundStyle(.white)
//                        .font(.title)
//                        .bold()
//                        .padding()
//                        .padding(.bottom, 5)
//                }
//            }
//        }
//        .toolbarBackground(
//            Color.background,
//            for: .navigationBar
//        )
//        .sheet(isPresented: $isPlaylistChangeSheetPresented) {
//            Text("힝 속았지")
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        PlaylistDetailView()
//    }
//    .navigationBarBackButtonHidden(false)
//}
