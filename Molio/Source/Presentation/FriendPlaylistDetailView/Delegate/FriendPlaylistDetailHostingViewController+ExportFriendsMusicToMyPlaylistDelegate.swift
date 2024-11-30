extension FriendPlaylistDetailHostingViewController: ExportFriendsMusicToMyPlaylistDelegate {
    func exportFriendsMusicToMyPlaylist(molioMusic: MolioMusic) {
        // 친구의 음악을 내 플레이리스트에 추가하는 시트 생성
        let viewModel = SelectPlaylistToExportFriendMusicViewModel(selectedMusic: molioMusic)
        let selectPlaylistView = SelectPlaylistToExportFriendMusicView(viewModel: viewModel)
        self.presentCustomSheet(content: selectPlaylistView)
    }
}
