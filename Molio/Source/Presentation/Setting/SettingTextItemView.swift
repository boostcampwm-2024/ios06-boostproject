import SwiftUI

struct SettingTextItemView: View {
    private let titleText: String
    
    init(titleText: String) {
        self.titleText = titleText
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(titleText)
                    .font(.pretendardRegular(size: 16))
                    .foregroundStyle(.white)
                    .padding(.leading, 16)
                    .padding(.top, 11)
                    .padding(.bottom, 11)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            Divider()
                .background(Color(UIColor.darkGray))
                .padding(.leading, 16)
                .padding(.bottom, 1)
        }
        .background(Color(uiColor: UIColor(resource: .background)))
    }
}
