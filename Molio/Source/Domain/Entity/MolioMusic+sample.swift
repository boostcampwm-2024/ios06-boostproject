import Foundation

extension MolioMusic {
    static let apt = MolioMusic(
        title: "APT",
        artistName: "Rose",
        gerneNames: ["라틴"],
        isrc: "USRC17607839",
        previewAsset: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/QRQhWNWl7N2_1Nifa62gO1usmiRxQJr2wNaxvoJtaBdmOeAtJSuXnmwxswfsRPlIOTKvufvevDvbLrDfSGHGkw.webp")!,
        artworkBackgroundColor: RGBAColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    )
    
    static let song2 = MolioMusic(
        title: "Summer Breeze",
        artistName: "KAI",
        gerneNames: ["Pop", "Dance"],
        isrc: "USRC17607840",
        previewAsset: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/3H3PSttC8IdgX2VxErVvTRhcnVpKyDKznhR4_Hn68bf_qhxIRebfFMXwFm-NQ8PLvRo3SiHyRo0xsUj2Emjr9A.webp")!,
        artworkBackgroundColor: RGBAColor(red: 0.1, green: 0.6, blue: 0.8, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    )
    
    static let song3 = MolioMusic(
        title: "Moonlight",
        artistName: "Luna",
        gerneNames: ["K-Pop"],
        isrc: "USRC17607841",
        previewAsset: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/x47V8tpsYu-DHOhztcKML0xhxYbxTpPG3GXS-oyEypMK6IbVguYv0wz-1SLYqlyOFS4cFl3mXZOdPnvKfU76Vg.webp")!,
        artworkBackgroundColor: RGBAColor(red: 0.5, green: 0.2, blue: 0.7, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    )
    
    static let song4 = MolioMusic(
        title: "Eclipse",
        artistName: "Solar",
        gerneNames: ["R&B", "Soul"],
        isrc: "USRC17607842",
        previewAsset: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/9DT_WDb58c2KFTYs4KeQl2J3p24QxPt96gREfYyTxeUrXmCL2XgNrTtEKPC_GYqgJvDPbyppCl_2jG8HR3Vo0w.webp")!,
        artworkBackgroundColor: RGBAColor(red: 0.4, green: 0.3, blue: 0.6, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    )
    
    static let song5 = MolioMusic(
        title: "Golden Hour",
        artistName: "IU",
        gerneNames: ["Ballad", "Acoustic"],
        isrc: "USRC17607843",
        previewAsset: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3")!,
        artworkImageURL: URL(string: "https://i.namu.wiki/i/SZ8KOkdYXoP2Y_GzR6B5Y5W9Pqcm4_Hwzx4yXNcuVimQ8Uqg9SO02x9fqx59N2rTpD8JKHdZxLxPHm4TBJEMXQ.webp")!,
        artworkBackgroundColor: RGBAColor(red: 0.9, green: 0.8, blue: 0.3, alpha: 1.0),
        primaryTextColor: RGBAColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    )
    
    static let all: [MolioMusic] = [apt, song2, song3, song4, song5]
}
