import SwiftUI

struct PlaylistDetailViewList: View {
    var musics: [RandomMusic]
    
    var body: some View {
        List(musics, id: \.isrc) { _ in
            PlaylistDetailListItemView(music: .apt)
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(.gray)
                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
        }
    }
}

#Preview {
    PlaylistDetailViewList(musics: RandomMusic.samples)
}
