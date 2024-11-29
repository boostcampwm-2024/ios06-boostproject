import SwiftUI

struct ExportPlaylistImageView: View {
    @ObservedObject private var viewModel: ExportPlaylistImageViewModel
    
    var doneButtonTapAction: (() -> Void)?
    
    init(viewModel: ExportPlaylistImageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text.molioSemiBold(StringLiterals.navigationTitle, size: 17)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                Button {
                    doneButtonTapAction?()
                } label: {
                    Text.molioSemiBold("완료", size: 17)
                        .foregroundColor(.main)
                }
            }
            .frame(height: 44)
            .padding(EdgeInsets(top: 11, leading: 18, bottom: 11, trailing: 18))
            
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
                            PlaylistImagePage(
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
                content: PlaylistImagePage(musicItems: viewModel.paginatedMusicItems[page])
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

extension ExportPlaylistImageView {
    enum StringLiterals {
        static let navigationTitle: String = "이미지로 플레이리스트 내보내기"
    }
}

#Preview {
    ZStack {
        Color.background
        ExportPlaylistImageView(viewModel: ExportPlaylistImageViewModel(musics: MolioMusic.all))
    }
}
