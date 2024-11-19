import SwiftUI

struct PlaylistDetailViewList: View {
    var musics: [RandomMusic]
    
    var body: some View {
        List(musics, id: \.isrc) { music in
            PlaylistDetailListItemView(music: music)
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(.gray)
                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
        }
    }
}

#Preview {
    PlaylistDetailViewList(musics: RandomMusic.samples)
}
