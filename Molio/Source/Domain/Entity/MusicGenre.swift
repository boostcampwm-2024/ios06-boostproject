//enum MusicGenre: String, CaseIterable, Decodable {
//    case acoustic
//    case afrobeat
//    case altRock = "alt-rock"
//    case alternative
//    case ambient
//    case anime
//    case blackMetal = "black-metal"
//    case bluegrass
//    case blues
//    case bossanova
//    case brazil
//    case breakbeat
//    case british
//    case cantopop
//    case chicagoHouse = "chicago-house"
//    case children
//    case chill
//    case classical
//    case club
//    case comedy
//    case country
//    case dance
//    case dancehall
//    case deathMetal = "death-metal"
//    case deepHouse = "deep-house"
//    case detroitTechno = "detroit-techno"
//    case disco
//    case disney
//    case drumAndBass = "drum-and-bass"
//    case dub
//    case dubstep
//    case edm
//    case electro
//    case electronic
//    case emo
//    case folk
//    case forro
//    case french
//    case funk
//    case garage
//    case german
//    case gospel
//    case goth
//    case grindcore
//    case groove
//    case grunge
//    case guitar
//    case happy
//    case hardRock = "hard-rock"
//    case hardcore
//    case hardstyle
//    case heavyMetal = "heavy-metal"
//    case hipHop = "hip-hop"
//    case holidays
//    case honkyTonk = "honky-tonk"
//    case house
//    case idm
//    case indian
//    case indie
//    case indiePop = "indie-pop"
//    case industrial
//    case iranian
//    case jDance = "j-dance"
//    case jIdol = "j-idol"
//    case jPop = "j-pop"
//    case jRock = "j-rock"
//    case jazz
//    case kPop = "k-pop"
//    case kids
//    case latin
//    case latino
//    case malay
//    case mandopop
//    case metal
//    case metalMisc = "metal-misc"
//    case metalcore
//    case minimalTechno = "minimal-techno"
//    case movies
//    case mpb
//    case newAge = "new-age"
//    case newRelease = "new-release"
//    case opera
//    case pagode
//    case party
//    case philippinesOpm = "philippines-opm"
//    case piano
//    case pop
//    case popFilm = "pop-film"
//    case postDubstep = "post-dubstep"
//    case powerPop = "power-pop"
//    case progressiveHouse = "progressive-house"
//    case psychRock = "psych-rock"
//    case punk
//    case punkRock = "punk-rock"
//    case rNB = "r-n-b"
//    case rainyDay = "rainy-day"
//    case reggae
//    case reggaeton
//    case roadTrip = "road-trip"
//    case rock
//    case rockNRoll = "rock-n-roll"
//    case rockabilly
//    case romance
//    case sad
//    case salsa
//    case samba
//    case sertanejo
//    case showTunes = "show-tunes"
//    case singerSongwriter = "singer-songwriter"
//    case ska
//    case sleep
//    case songwriter
//    case soul
//    case soundtracks
//    case spanish
//    case study
//    case summer
//    case swedish
//    case synthPop = "synth-pop"
//    case tango
//    case techno
//    case trance
//    case tripHop = "trip-hop"
//    case turkish
//    case workOut = "work-out"
//    case worldMusic = "world-music"
//}
//
//extension MusicGenre: CustomStringConvertible {
//    var description: String {
//        switch self {
//        case .acoustic: return "어쿠스틱"
//        case .afrobeat: return "아프로비트"
//        case .altRock: return "얼터너티브 락"
//        case .alternative: return "얼터너티브"
//        case .ambient: return "앰비언트"
//        case .anime: return "애니메이션"
//        case .blackMetal: return "블랙 메탈"
//        case .bluegrass: return "블루그래스"
//        case .blues: return "블루스"
//        case .bossanova: return "보사노바"
//        case .brazil: return "브라질 음악"
//        case .breakbeat: return "브레이크비트"
//        case .british: return "브리티시"
//        case .cantopop: return "캔토팝"
//        case .chicagoHouse: return "시카고 하우스"
//        case .children: return "동요"
//        case .chill: return "칠 음악"
//        case .classical: return "클래식"
//        case .club: return "클럽 음악"
//        case .comedy: return "코미디"
//        case .country: return "컨트리"
//        case .dance: return "댄스"
//        case .dancehall: return "댄스홀"
//        case .deathMetal: return "데스 메탈"
//        case .deepHouse: return "딥 하우스"
//        case .detroitTechno: return "디트로이트 테크노"
//        case .disco: return "디스코"
//        case .disney: return "디즈니"
//        case .drumAndBass: return "드럼 앤 베이스"
//        case .dub: return "덥 음악"
//        case .dubstep: return "덥스텝"
//        case .edm: return "EDM"
//        case .electro: return "일렉트로"
//        case .electronic: return "전자 음악"
//        case .emo: return "이모"
//        case .folk: return "포크"
//        case .forro: return "포호"
//        case .french: return "프렌치"
//        case .funk: return "펑크"
//        case .garage: return "개러지"
//        case .german: return "독일 음악"
//        case .gospel: return "가스펠"
//        case .goth: return "고딕"
//        case .grindcore: return "그라인드코어"
//        case .groove: return "그루브"
//        case .grunge: return "그런지"
//        case .guitar: return "기타 음악"
//        case .happy: return "행복한 음악"
//        case .hardRock: return "하드 록"
//        case .hardcore: return "하드코어"
//        case .hardstyle: return "하드스타일"
//        case .heavyMetal: return "헤비 메탈"
//        case .hipHop: return "힙합"
//        case .holidays: return "홀리데이 음악"
//        case .honkyTonk: return "홍키통크"
//        case .house: return "하우스"
//        case .idm: return "IDM"
//        case .indian: return "인도 음악"
//        case .indie: return "인디"
//        case .indiePop: return "인디 팝"
//        case .industrial: return "인더스트리얼"
//        case .iranian: return "이란 음악"
//        case .jDance: return "J-댄스"
//        case .jIdol: return "J-아이돌"
//        case .jPop: return "J-팝"
//        case .jRock: return "J-록"
//        case .jazz: return "재즈"
//        case .kPop: return "K-팝"
//        case .kids: return "키즈 음악"
//        case .latin: return "라틴 음악"
//        case .latino: return "라티노"
//        case .malay: return "말레이 음악"
//        case .mandopop: return "만다린 팝"
//        case .metal: return "메탈"
//        case .metalMisc: return "기타 메탈"
//        case .metalcore: return "메탈코어"
//        case .minimalTechno: return "미니멀 테크노"
//        case .movies: return "영화 음악"
//        case .mpb: return "MPB"
//        case .newAge: return "뉴에이지"
//        case .newRelease: return "신작"
//        case .opera: return "오페라"
//        case .pagode: return "파고지"
//        case .party: return "파티 음악"
//        case .philippinesOpm: return "필리핀 음악"
//        case .piano: return "피아노 음악"
//        case .pop: return "팝"
//        case .popFilm: return "영화 OST"
//        case .postDubstep: return "포스트 덥스텝"
//        case .powerPop: return "파워 팝"
//        case .progressiveHouse: return "프로그레시브 하우스"
//        case .psychRock: return "사이키델릭 록"
//        case .punk: return "펑크"
//        case .punkRock: return "펑크 록"
//        case .rNB: return "R&B"
//        case .rainyDay: return "비 오는 날 음악"
//        case .reggae: return "레게"
//        case .reggaeton: return "레게톤"
//        case .roadTrip: return "로드 트립 음악"
//        case .rock: return "록"
//        case .rockNRoll: return "록앤롤"
//        case .rockabilly: return "로커빌리"
//        case .romance: return "로맨스 음악"
//        case .sad: return "슬픈 음악"
//        case .salsa: return "살사"
//        case .samba: return "삼바"
//        case .sertanejo: return "세르타네조"
//        case .showTunes: return "쇼튠"
//        case .singerSongwriter: return "싱어송라이터"
//        case .ska: return "스카"
//        case .sleep: return "수면 음악"
//        case .songwriter: return "송라이터 음악"
//        case .soul: return "소울"
//        case .soundtracks: return "사운드트랙"
//        case .spanish: return "스페인 음악"
//        case .study: return "공부 음악"
//        case .summer: return "여름 음악"
//        case .swedish: return "스웨덴 음악"
//        case .synthPop: return "신스 팝"
//        case .tango: return "탱고"
//        case .techno: return "테크노"
//        case .trance: return "트랜스"
//        case .tripHop: return "트립합"
//        case .turkish: return "터키 음악"
//        case .workOut: return "운동 음악"
//        case .worldMusic: return "월드 뮤직"
//        }
//    }
//}

typealias MusicGenre = String
