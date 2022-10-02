//
//  LanguageView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/30.
//

import SwiftUI

struct LanguageView: View {
    @State var selectedLanguage = 0
    
    var body: some View {
        List {
            HStack {
                Text("한국어 (Korean)")
                Spacer()
                if selectedLanguage == 0 {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("Main"))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedLanguage = 0
            }
            
            HStack {
                Text("영어 (English)")
                Spacer()
                if selectedLanguage == 1 {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("Main"))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedLanguage = 1
            }
        }
        .navigationTitle(Text("language"))
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView()
    }
}
