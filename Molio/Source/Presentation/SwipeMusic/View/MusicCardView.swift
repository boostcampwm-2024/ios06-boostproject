import UIKit

final class MusicCardView: UIView {
    private let basicBackgroundColor = UIColor(resource: .background)
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .background
        return imageView
    }()
    
    private let gradientView: UIView = {
        let insideShadowView = UIView()
        insideShadowView.layer.cornerRadius = 22
        insideShadowView.layer.masksToBounds = true
        insideShadowView.translatesAutoresizingMaskIntoConstraints = false
        return insideShadowView
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupShadow()
        setupGradient()
        setupHierarchy()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
        setupGradient()
        setupHierarchy()
        setupConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃 변경 시 그라디언트 프레임 업데이트
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }
    
    func configure(music: SwipeMusicTrackModel) {
        songTitleLabel.molioExtraBold(text: music.title, size: 30)
        artistNameLabel.molioMedium(text: music.artistName, size: 20)
        setupGenre(music.gerneNames)
        
        let textColor = UIColor.white
        songTitleLabel.textColor = textColor
        artistNameLabel.textColor = textColor.withAlphaComponent(0.7)
        
        if let imageData = music.artworkImageData {
            albumImageView.image = UIImage(data: imageData)
        }
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 25
        layer.shadowOpacity = 0.25
    }
    
    private func setupGradient() {
        gradientView.alpha = 0.6
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.8).cgColor, // 아래쪽이 더 어두운 색상
            UIColor.black.withAlphaComponent(0.0).cgColor  // 위쪽으로 갈수록 투명
        ]
        gradientLayer.locations = [0.0, 1.0] // 색상 위치를 설정 (0% -> 100%)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0) // 아래쪽 중앙에서 시작
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)   // 위쪽 중앙에서 끝
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupGenre(_ genres: [String]) {
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        genres.forEach { genre in
            let genreTagView = MusicTagView(tagTitle: genre, backgroundColor: .black.withAlphaComponent(0.3))
            genreStackView.addArrangedSubview(genreTagView)
        }
    }
    
    private func setupHierarchy() {
        addSubview(albumImageView)
        addSubview(gradientView)
        addSubview(songTitleLabel)
        addSubview(artistNameLabel)
        addSubview(genreStackView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: self.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -121),
            songTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            songTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -92),
            artistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28)
        ])
        
        NSLayoutConstraint.activate([
            genreStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -34),
            genreStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28)
        ])
    }
}

import SwiftUI

// Preview용 UIViewRepresentable 구현
struct MusicCardViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> MusicCardView {
        let musicCardView = MusicCardView()
        let mockMusic = SwipeMusicTrackModel(
            randomMusic: MolioMusic(
                title: "Shape of You", // 곡 제목
                artistName: "Ed Sheeran", // 아티스트 이름
                gerneNames: ["Pop", "Dance"], // 장르
                isrc: "GBUM71705486", // ISRC 코드
                previewAsset: URL(string: "https://p.scdn.co/mp3-preview/a1b2c3d4e5f6g7h8i9j0k")!, // 미리듣기 URL
                artworkImageURL: URL(string: "https://i.scdn.co/image/ab67616d0000b273a2c3b4c5d6e7f8g9h0j1k2l3"), // 앨범 이미지 URL
                artworkBackgroundColor: RGBAColor(red: 34, green: 45, blue: 123, alpha: 1), // 배경색
                primaryTextColor: RGBAColor(red: 255, green: 255, blue: 255, alpha: 1) // 텍스트 색상
            ),
            imageData: UIImage(named: "AlbumCoverSample")?.pngData() ?? Data()
        )
        musicCardView.configure(music: mockMusic)
        return musicCardView
    }
    
    func updateUIView(_ uiView: MusicCardView, context: Context) {
        // 업데이트 로직 필요 시 추가
    }
}

// Preview 정의
struct MusicCardViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // 배경색 설정
            MusicCardViewPreview()
                .frame(width: 300, height: 400) // 적절한 크기 설정
                .previewLayout(.sizeThatFits) // 크기 자동 맞춤
                .padding() // 여백 추가
        }
    }
}
