import SwiftUI

/// 커스텀 검색 바
/// - `searchText` : 바인딩 텍스트
/// - `placeholder` : 플레이스홀더 텍스트
/// - `tintColor` : 검색,취소,플레이스홀더,입력 텍스트의 색상
struct SearchBar: View {
    @Binding var searchText: String
    
    let placeholder: String
    let tintColor: Color
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
 
                TextField(
                    "검색어 입력",
                    text: $searchText,
                    prompt: Text(placeholder).foregroundColor(tintColor)
                )
 
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 8)
            .foregroundColor(tintColor) // TODO: - 정확한 색상
            .background(.textFieldBackground)
            .cornerRadius(10)
        }
    }
}

#Preview {
    SearchBar(
        searchText: .constant("입력텍스트"),
        placeholder: "플레이스홀더",
        tintColor: .main
    )
}
