import SwiftUI

struct PlaylistImagePage: View {
    let musicItems: [ExportMusicItem]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(musicItems, id: \.uuid) { item in
                PlaylistImageMusicItem(musicItems: item)
                    .background(Color.white)
                    .foregroundStyle(.black)
                Divider()
                    .padding(.leading, 74)
            }
        }
        .background(Color.white)
    }
}
