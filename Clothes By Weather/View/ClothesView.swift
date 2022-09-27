//
//  ClothesView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import SwiftUI

struct ClothesView: View {
    let temperature: Double
    
    @State var currentPage: Int
    
    @State var todayIndex = 0
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if currentPage == todayIndex {
                        Text("Today")
                            .foregroundColor(Color("Point"))
                    }
                    Text(Temperature.allCases[currentPage].rawValue)
                        .foregroundColor(Color("Serve1"))
                }
                .font(.custom(FontManager.Pretendard.bold, size: 17))
                
                Text(properClothes(for: Temperature.allCases[currentPage]))
                    .foregroundColor(currentPage == todayIndex ? Color("Main") : Color("Serve1"))
                    .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                    .padding(.top, -4)
                
                Image(imageName(for: Temperature.allCases[currentPage]))
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .offset(x: -10)
                    .opacity(currentPage == todayIndex ? 1.0 : 0.55)
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            
            VStack {
                Image(systemName: "chevron.up")
                    .opacity(currentPage != 7 ? 1.0 : 0.3)
                    .onTapGesture {
                        // Higher
//                        withAnimation {
                            currentPage += 1
//                        }
                    }
                    .disabled(currentPage != 7 ? false : true)
                Spacer()
                Image(systemName: "chevron.down")
                    .opacity(currentPage != 0 ? 1.0 : 0.3)
                    .onTapGesture {
                        // Lower
//                        withAnimation {
                            currentPage -= 1
//                        }
                    }
                    .disabled(currentPage != 0 ? false : true)
            }
            .padding(16)
            .font(.custom(FontManager.Pretendard.regular, size: 20))
            .foregroundColor(Color("Serve2"))
        }
        .background(RoundedRectangle(cornerRadius: 19).foregroundColor(Color("Box")))
        .onAppear {
            currentPage = temperatureIndex(for: Int(temperature))
            todayIndex = currentPage
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation {
                        if value.translation.height > 30 {
                            // Swipe up
                            if currentPage != 7 {
                                currentPage += 1
                            }
                        } else if value.translation.height < -30 {
                            // Swipe down
                            if currentPage != 0 {
                                currentPage -= 1
                            }
                        }
                    }
                }
        )
    }
}
