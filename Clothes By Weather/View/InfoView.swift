//
//  InfoView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/28.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("The source of the weather information")
                .font(.system(size: 16, weight: .semibold))
                .padding(.bottom)
            HStack {
                Text(" Weather")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            Link("https://weatherkit.apple.com/legal-attribution.html", destination: URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                .multilineTextAlignment(.leading)
                .font(.system(size: 14, weight: .regular))
            Spacer()
        }
        .foregroundColor(Color("Main"))
        .padding(20)
        .navigationTitle("License")
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
