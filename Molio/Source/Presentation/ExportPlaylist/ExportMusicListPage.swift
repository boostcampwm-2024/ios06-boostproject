import SwiftUI

struct ExportMusicListPage: View {
    let musics: [MolioMusic]
    
    var body: some View {
        List {
            ForEach(musics, id: \.isrc) { item in
                ExportPlaylistItemView(music: item)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
    }
}

#Preview {
    ExportMusicListPage(musics: [MolioMusic.apt, MolioMusic.apt, MolioMusic.apt])
}
