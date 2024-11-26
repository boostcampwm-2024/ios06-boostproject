struct MockSpotifyAPIService: SpotifyAPIService {
    var isrcsToReturn1: [String] = [
        "USRC11300369", "USAT21702430", "GBUM71101813", "QZ45A1600041", "USSUB0771012",
        "QMSAL1200001", "KRA401800096", "USAT21502909", "USUG11700631", "USA371627635",
        "USVI20400540", "USSUB0877710", "USA371382531", "USEP41227004", "USVR91379302",
        "DEE861400019", "GBUM71204769", "USIR10211291", "USUM71703085", "USSUB1408301"
    ]
    var isrcsToReturn2: [String] = [
        "USMTD0144406", "USMC10346123", "IEACJ1300031", "USUM71504407",
        "USRC11501051", "GBAYE0000566", "USDW10021712", "USUG11400503",
        "USSM19100626", "USSM19911010", "USSM11300889", "USUM71413252",
        "USSM19100674", "GBBKS0700574", "GBHMU1600074", "USWB11304681",
        "USJI11000232", "USJAY1100058", "GBHMU1200372", "USDMG1260801",
        "US4L80804610", "USAT20401588", "USUM70918596", "GBK3W1000200",
        "KRA401800096", "GBCRL0800302", "USIR29400443", "USCN39600066",
        "GBAYE0201595", "QZ45A1600041", "USUM71312880", "USAT21601765",
        "USUM71300299", "GMM881200024", "GBAYE6400179", "QMFMK1400002",
        "USVI21200897", "USSM10602589", "GBCEL0500855", "USUM71616255",
        "USRC11200786", "GBAHT0200220", "USAT29200016", "USUM71302187",
        "USTJ21126105", "AUIYA1400002", "GBAAA7500006", "USVI21200910",
        "GBJPX0500005", "USUM71705267", "USAT21203287", "GBAHJ0900002",
        "GBUM71106250", "USRE19900154", "GBUM71705145", "USRC11700814",
        "USP6L1000053", "GBAJE6600005", "GBUM71406026", "US8WW2203908",
        "NLA321393034", "GBU4B1100007", "GBDVX1200008", "GBAMB9500072",
        "UK7PP1400002", "GBUM70604698", "GBAHS1500226", "USSM10804556",
        "USUM71406901", "USRC11801716", "USCA20300746", "GBA076600020",
        "GBARL1200671", "US5260507213", "GBAHS1100351", "USAT21405436",
        "GBUM70710049", "USCM51300762", "USSM10702131", "GBAHS1100203"
    ]
    var genreSeedsToReturn: SpotifyAvailableGenreSeedsDTO = SpotifyAvailableGenreSeedsDTO(
        genres: [
            "acoustic", "afrobeat", "alt-rock", "alternative",
            "ambient", "anime", "black-metal", "bluegrass",
            "blues", "bossanova", "brazil", "breakbeat",
            "british", "cantopop", "chicago-house", "children",
            "chill", "classical", "club", "comedy", "country",
            "dance", "dancehall", "death-metal"
        ]
    )
    
    func fetchRecommendedMusicISRCs(with filter: MusicFilter) async throws -> [String] {
        return isrcsToReturn2
    }
    
    func fetchAvailableGenreSeeds() async throws -> SpotifyAvailableGenreSeedsDTO {
        return genreSeedsToReturn
    }
}
