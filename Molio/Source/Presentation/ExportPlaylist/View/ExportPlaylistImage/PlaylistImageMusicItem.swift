import SwiftUI

struct PlaylistImageMusicItem: View {
    var musicItems: ExportMusicItem
    
    init(musicItems: ExportMusicItem) {
        self.musicItems = musicItems
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if let imageData = musicItems.artworkImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .padding(.top, 6)
                    .padding(.bottom, 6)
                    .padding(.leading, 16)
            } else {
                Color.background
                    .frame(width: 42, height: 42)
                    .padding(.top, 6)
                    .padding(.bottom, 6)
                    .padding(.leading, 16)
            }
            VStack(alignment: .leading) {
                Text(musicItems.title)
                    .font(.body)
                Text(musicItems.artistName)
                    .font(.footnote)
                    .fontWeight(.ultraLight)
            }
            Spacer()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: 56
        )
    }
}
