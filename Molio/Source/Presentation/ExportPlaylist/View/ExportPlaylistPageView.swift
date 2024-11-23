import SwiftUI

struct ExportPlaylistPageView: View {
    let musicItems: [ExportMusicItem]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(musicItems, id: \.uuid) { item in
                ExportPlaylistItemView(musicItems: item)
                    .background(Color.white)
                    .foregroundStyle(.black)
                Divider()
                    .padding(.leading, 74)
            }
        }
        .background(Color.white)
    }
}
