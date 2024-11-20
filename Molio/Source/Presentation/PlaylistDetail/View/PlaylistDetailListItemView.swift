import SwiftUI

struct PlaylistDetailListItemView: View {
    var music: MolioMusic

    init(music: MolioMusic) {
        self.music = music
    }

    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: music.artworkImageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                case .failure:
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 56, height: 56)
                        .cornerRadius(3)

                @unknown default:
                    EmptyView()
                }
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
    PlaylistDetailListItemView(music: MolioMusic.apt)
        .background(Color.black)
        .foregroundStyle(.white)
}
#Preview {
    PlaylistDetailListItemView(music: MolioMusic.song2)
        .background(Color.black)
        .foregroundStyle(.white)
}
