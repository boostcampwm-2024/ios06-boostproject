import Foundation

/// Swipe 할 수 있는 카드 정보에 표시되는 음악 정보에 대한 Entity입니다.
struct MolioMusic {
    /// 노래 제목
    let title: String
    
    /// 아티스트 이름
    let artistName: String
    
    /// 장르 목록
    let gerneNames: [String]
    
    /// 국제 표준 녹음 자료 코드
    let isrc: String
    
    /// 음악 미리듣기 URL
    let previewAsset: URL
    
    /// 앨범 아트워크 이미지
    let artworkImageURL: URL?
    
    /// 앨범에 이미지에 따른 평균 배경색
    let artworkBackgroundColor: RGBAColor?
    
    /// 앨범에 이미지에 따른 primary 색상
    let primaryTextColor: RGBAColor?
}
