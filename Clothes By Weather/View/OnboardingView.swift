//
//  OnboardingView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/27.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State var imageName = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 146, height: 44)
                    .foregroundColor(Color("Button"))
                
                Text("start")
                    .font(.custom(FontManager.Pretendard.bold, size: 17))
                    .foregroundColor(.white)
            }
            .offset(y: -25)
            .onTapGesture {
                shouldShowOnboarding = false
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .onAppear {
            let language = Locale.current.language.languageCode?.identifier
            if language == "ko" {
                imageName = "onboarding-ko"
            } else {
                imageName = "onboarding-en"
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowOnboarding: .constant(true))
    }
}
