import SwiftUI

struct ProfileImageView: View {
    let imageURL: URL?
    let placeholderIconName: String
    let size: CGFloat

    init(imageURL: URL?, placeholderIconName: String = "person.fill", size: CGFloat = 50) {
        self.imageURL = imageURL
        self.placeholderIconName = placeholderIconName
        self.size = size
    }

    var body: some View {
        if let imageURL = imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                case .failure(_):
                    DefaultProfile()
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            DefaultProfile()
        }
    }
}
