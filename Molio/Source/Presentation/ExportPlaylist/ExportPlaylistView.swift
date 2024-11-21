import SwiftUI

struct ExportPlaylistView: View {
    let itemHeight: CGFloat = 54.0
    let exportMusicListPageTopPadding: CGFloat = 50.0
    let exportMusicListPageBottomPadding: CGFloat = 72.0
    
    @State var selectedTab = 0
    let musics: [MolioMusic]
    @State private var exportMolioMusics: [[MolioMusic]] = []
    
    var numberOfPages: Int {
        return max(1, exportMolioMusics.count)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    TabView(selection: $selectedTab) {
                        ForEach(0..<numberOfPages, id: \.self) { pageIndex in
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
                                        musics: pageIndex < exportMolioMusics.count ? exportMolioMusics[pageIndex] : []
                                    )
                                    .cornerRadius(22)
                                    .padding(EdgeInsets(
                                        top: exportMusicListPageTopPadding,
                                        leading: 22,
                                        bottom: 72,
                                        trailing: exportMusicListPageBottomPadding)
                                    )
                                    .onAppear {
                                        updateExportMolioMusics(height: geometry.size.height)
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    
                    HStack(spacing: 15) {
                        BasicButton(type: .saveImage) { }
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
    
    /// 화면 크기에 맞게 Molio Music을 page에 맞는 모델로 변경하는 메서드
    func updateExportMolioMusics(height: CGFloat) {
        guard height > 0 else { return }
        let viewHeight = height - exportMusicListPageTopPadding - exportMusicListPageBottomPadding
        let itemMaxCountPerPage = Int(viewHeight / itemHeight)
        
        exportMolioMusics = musics.reduce(into: [[MolioMusic]]()) { result, element in
            if let last = result.last, last.count < itemMaxCountPerPage {
                result[result.count - 1].append(element)
            } else {
                result.append([element])
            }
        }
    }
}

extension ExportPlaylistView {
    enum StringLiterals {
        static let navigationTitle: String = "molio 내보내기"
    }
}

#Preview {
    ExportPlaylistView(musics: [MolioMusic.apt, MolioMusic.apt, MolioMusic.apt, MolioMusic.apt])
}
