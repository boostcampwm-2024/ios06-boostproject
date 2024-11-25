protocol AuthStateRepository {
   var authMode: AuthMode { get }
   var authSelection: AuthSelection { get }
   func setAuthMode(_ mode: AuthMode)
   func setAuthSelection(_ selection: AuthSelection)
}
