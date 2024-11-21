import SwiftUI
import Combine

struct MusicListView: View {
    @Binding private var musics: [MolioMusic]
    @Binding private var selectedIndex: Int?
    
    @State private var isAlertPresenting: Bool = false
    @State private var removeTargetMusic: MolioMusic?
    
    init(
        musics: Binding<[MolioMusic]>,
        selectedIndex: Binding<Int?>
    ) {
        self._musics = musics
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        List {
            ForEach(musics.indices, id: \.self) { index in
                let music = musics[index]
                
                MusicCellView(music: music)
                    .listRowBackground(selectedIndex == index ? .main.opacity(0.2) : Color.clear)
                    .listRowSeparatorTint(.gray)
                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                    .onTapGesture {
                        selectedIndex = index
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            removeTargetMusic = music
                            isAlertPresenting.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .alert("정말 삭제하시겠습니까?", isPresented: $isAlertPresenting, presenting: removeTargetMusic) { music in
            // 삭제 확인 버튼
            Button("삭제") {
                deleteMusic(music: music)
                removeTargetMusic = nil
            }
            .tint(.red)
            // 취소 버튼
            Button("취소", role: .cancel) {
                // 취소 시 추가 작업이 필요하다면 여기에 작성
                removeTargetMusic = nil
            }
        }
    }
    
    private func deleteMusic(music: MolioMusic) {
        print("Delete \(music.title)")
    }
    
    
}

#Preview {
    ZStack {
        Color.black
        MusicListView(musics: .constant(
                MolioMusic.all
            ),
            selectedIndex: .constant(0)
        )
        .foregroundStyle(.white)
        .background(Color.background)
    }
}
