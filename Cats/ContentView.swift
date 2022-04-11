//
//  ContentView.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(){
            CatsMain()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            CatsFavorite()
                .tabItem {
                    Image(systemName: "heart")
                    Text("My offline cats")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
