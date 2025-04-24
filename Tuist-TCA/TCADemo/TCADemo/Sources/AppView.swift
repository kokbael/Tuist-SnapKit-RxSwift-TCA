//
//  AppView.swift
//  TCADemo
//
//  Created by 김동영 on 4/24/25.
//

import ComposableArchitecture
import SwiftUI


struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.aModuleState, action: \.aModuleAction))
                .tabItem {
                    Text("Counter 1")
                }
            
            CounterView(store: store.scope(state: \.bModuleState, action: \.bModuleAction))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
