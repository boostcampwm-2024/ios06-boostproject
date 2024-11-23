import SwiftUI

struct ExportPlaylistView: View {
    @ObservedObject private var viewModel: ExportPlaylistViewModel
    
    init(viewModel: ExportPlaylistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    TabView(selection: $viewModel.selectedTab) {
                        ForEach(0..<viewModel.numberOfPages, id: \.self) { pageIndex in
                            ZStack {
                                VStack {
                                    Rectangle()
                                        .fill(.white)
                                        .cornerRadius(22)
                                        .frame(maxHeight: .infinity)
                                    Spacer(minLength: 57)
                                }
                                .padding(EdgeInsets(
                                    top: 34,
                                    leading: 22,
                                    bottom: 15,
                                    trailing: 22)
                                )
                                GeometryReader { geometry in
                                    ExportMusicListPage(
                                        musicItems: viewModel.paginatedMusicItems.isEmpty ? [] : viewModel.paginatedMusicItems[pageIndex]
                                    )
                                    .cornerRadius(22)
                                    .padding(EdgeInsets(
                                        top: viewModel.exportMusicListPageTopPadding,
                                        leading: 22,
                                        bottom: 72,
                                        trailing: viewModel.exportMusicListPageBottomPadding)
                                    )
                                    .onAppear {
                                        Task {
                                            await viewModel.updateExportMolioMusics(height: geometry.size.height)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    
                    HStack(spacing: 15) {
                        BasicButton(type: .saveImage) {
                            Task {
                                await exportPlaylistToAlbum()
                            }
                        }
                        BasicButton(type: .shareInstagram) { }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(StringLiterals.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: 뒤로가기 action 추가.
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.main)
                    }
                }
            }
        }
    }
    
    /// 플레이리스트를 사진 앨범에 내보내는 메서드
    @MainActor private func exportPlaylistToAlbum() async {
        guard await !viewModel.isPhotoLibraryDenied() else {
            // TODO: 설정에서 다시 세팅하는 알림창 구현
            return
        }
        
        guard !viewModel.paginatedMusicItems.isEmpty else {
            // TODO: 저장될 사진이 없습니다. 알림창 구현
            return
        }
        
        var saveImageCount: Int = 0
        for page in 0..<viewModel.numberOfPages {
            let render = ImageRenderer(
                content: ExportMusicListPage(musicItems: viewModel.paginatedMusicItems[page])
                    .frame(width: UIScreen.main.bounds.width - 44)
            )
            render.scale = 3.0
            
            if let image = render.uiImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                saveImageCount += 1
            }
        }
        
        if saveImageCount == viewModel.numberOfPages {
            // TODO: 이미지 저장 성공 알림
        } else {
            // TODO: 이미지 저장 실패 알림
        }
    }
}

extension ExportPlaylistView {
    enum StringLiterals {
        static let navigationTitle: String = "molio 내보내기"
    }
}
