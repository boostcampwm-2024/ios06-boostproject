import SwiftUI

struct PlaylistDetailListItemView: View {
    var music: RandomMusic
    
    init(music: RandomMusic) {
        self.music = music
    }
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: music.artworkImageURL) { phase in
                phase.image?
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))

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
    PlaylistDetailListItemView(music: RandomMusic.apt)
        .background(Color.black)
        .foregroundStyle(.white)
}

