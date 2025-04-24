import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCADemoApp.store)
        }
    }
}
