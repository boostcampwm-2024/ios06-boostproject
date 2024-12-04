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
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(maxWidth: .infinity)
                Text.molioSemiBold(StringLiterals.navigationTitle, size: 17)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: false)
                    .multilineTextAlignment(.center)
                Button {
                    doneButtonTapAction?()
                } label: {
                    Text.molioSemiBold("완료", size: 17)
                        .foregroundStyle(.mainLighter)
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                        await viewModel.exportPlaylistToAlbum()
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 30)
        }
        .alert(
            viewModel.alertState.title,
            isPresented: $viewModel.showAlert,
            actions: {
                Button("확인") {
                    print("버튼")
                }
            }, message: {
                Text(viewModel.alertState.message)
            })
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
