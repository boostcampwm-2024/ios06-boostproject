import SwiftUI

struct DefaultProfile: View {
    let size: CGFloat
    
    init(size: CGFloat = 50) {
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(Color.gray)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
            )
            .frame(width: size, height: size)
    }
}

#Preview {
    DefaultProfile()
}
