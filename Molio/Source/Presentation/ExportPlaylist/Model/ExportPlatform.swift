import SwiftUI

/// 플레이리스트 내보내기 플랫폼 유형
enum ExportPlatform: String, CaseIterable, Identifiable {
    case appleMusic
    case image
    
    var id: String { rawValue }
    var image: Image {
        switch self {
        case .appleMusic:
            Image("appleMusicLogo")
        case .image:
            Image(systemName: "photo")
        }
    }
}
