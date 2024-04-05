//
//  ContentView.swift
//  Progetto Tesi
//
//  Created by Utente on 21/04/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene = SKScene(fileNamed: "MyScene")!
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
