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
                                if viewModel.isLoadingMusic {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .background))
                                        .scaleEffect(1.0, anchor: .center)
                                }
                                GeometryReader { geometry in
                                    ExportPlaylistPageView(
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
        .alert(
            viewModel.alertState.title,
            isPresented: $viewModel.showAlert) {
                Button("확인") { }
            } message: {
                Text(viewModel.alertState.message)
            }
    }
    
    /// 플레이리스트를 사진 앨범에 내보내는 메서드
    @MainActor private func exportPlaylistToAlbum() async {
        guard await !viewModel.isPhotoLibraryDenied() else {
            viewModel.alertState = .deniedPhotoLibrary
            viewModel.showAlert = true
            return
        }
        
        guard !viewModel.paginatedMusicItems.isEmpty else {
            viewModel.alertState = .emptyMusicItems
            viewModel.showAlert = true
            return
        }
        
        var saveImageCount: Int = 0
        for page in 0..<viewModel.numberOfPages {
            let render = ImageRenderer(
                content: ExportPlaylistPageView(musicItems: viewModel.paginatedMusicItems[page])
                    .frame(width: UIScreen.main.bounds.width - 44)
            )
            render.scale = 3.0
            
            if let image = render.uiImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                saveImageCount += 1
            }
        }
        
        if saveImageCount == viewModel.numberOfPages {
            viewModel.alertState = .successSaveImage
            viewModel.showAlert = true
        } else {
            viewModel.alertState = .failureSaveImage
            viewModel.showAlert = true
        }
    }
}

extension ExportPlaylistView {
    enum StringLiterals {
        static let navigationTitle: String = "molio 내보내기"
    }
}
