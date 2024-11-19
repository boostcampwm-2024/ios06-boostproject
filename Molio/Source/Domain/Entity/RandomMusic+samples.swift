import Foundation

extension RandomMusic {
    static let apt = RandomMusic(
        title: "APT",
        artistName: "Rose",
        gerneNames: ["라틴"],
        isrc: "USRC17607839", // 예시 ISRC 코드
        previewAsset: URL(string: "https://naver.com")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/QRQhWNWl7N2_1Nifa62gO1usmiRxQJr2wNaxvoJtaBdmOeAtJSuXnmwxswfsRPlIOTKvufvevDvbLrDfSGHGkw.webp"),
        artworkBackgroundColor: RGBAColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    )
    
    static let ppt = RandomMusic(
        title: "PPT",
        artistName: "Rose",
        gerneNames: ["라틴"],
        isrc: "USRC17607839", // 예시 ISRC 코드
        previewAsset: URL(string: "https://naver.com")!,
        artworkImageURL: URL(string: "https://example.com/artwork.jpg"),
        artworkBackgroundColor: RGBAColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    )

    static let samples: [RandomMusic] = [
        RandomMusic.apt,
        RandomMusic.apt,
        RandomMusic.apt,
        RandomMusic.apt,
        RandomMusic.apt,
        RandomMusic.apt
    ]
}
