import SwiftUI

struct MusicCellView: View {
    private let music: MolioMusic

    init(music: MolioMusic) {
        self.music = music
    }

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: music.artworkImageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                case .failure:
                    Rectangle()
                        .fill(.tag)

                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text.molioRegular(music.title, size: 17)
                Text.molioRegular(music.artistName, size: 13)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 56)
        .contentShape(Rectangle())
    }
}

#Preview {
    MusicCellView(music: MolioMusic.apt)
        .background(Color.black)
        .foregroundStyle(.white)
}
#Preview {
    MusicCellView(music: MolioMusic.song2)
        .background(Color.black)
        .foregroundStyle(.white)
}
