import SwiftUI

struct ExportPlaylistItemView: View {
    var music: MolioMusic

    init(music: MolioMusic) {
        self.music = music
    }

    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: music.artworkImageURL) { phase in
                phase.image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .padding(.top, 6)
                    .padding(.bottom, 6)
                    .padding(.leading, 16)
            }

            VStack(alignment: .leading) {
                Text(music.title)
                    .font(.body)
                Text(music.artistName)
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

#Preview {
    ExportPlaylistItemView(music: MolioMusic.apt)
        .background(Color.white)
        .foregroundStyle(.black)
}
