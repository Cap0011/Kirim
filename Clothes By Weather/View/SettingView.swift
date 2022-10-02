//
//  SettingView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/30.
//

import SwiftUI

struct SettingRow: View {
    let title: String
    
    var body: some View {
        Text(title)
    }
}

struct SettingView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("bg").resizable().ignoresSafeArea()
            List {
//                NavigationLink(destination: LanguageView()) {
//                    SettingRow(title: "Language (언어)")
//                }
                NavigationLink(destination: InfoView()) {
                    SettingRow(title: "License")
                }
            }
        }
        .navigationTitle(Text("setting"))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
