import SwiftUI

struct ExportPlaylistView: View {
    @State private var selectedTab = 0
    var pageCount = 3
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    TabView(selection: $selectedTab) {
                        ForEach(0..<pageCount, id: \.self) { index in
                            VStack {
                                Rectangle()
                                    .fill(.white)
                                    .cornerRadius(22)
                                    .frame(maxHeight: .infinity)
                                Spacer(minLength: 57)
                            }
                            .padding(EdgeInsets(top: 34, leading: 22, bottom: 15, trailing: 22))
                        }
                    }
                    .tabViewStyle(.page)
                    
                    HStack(spacing: 15) {
                        BasicButton(type: .saveImage) { }
                        BasicButton(type: .shareInstagram) { }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(StringLiterals.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {  }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.main)
                    }
                }
            }
        }
    }
}

extension ExportPlaylistView {
    enum StringLiterals {
        static let navigationTitle: String = "molio 내보내기"
    }
}

#Preview {
    ExportPlaylistView()
}
