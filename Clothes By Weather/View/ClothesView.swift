//
//  ClothesView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import SwiftUI

struct ClothesView: View {
    @Binding var temperature: Double
    
    @State var currentPage: Int
    
    @State var todayIndex: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if currentPage == todayIndex {
                        Text("Today")
                            .foregroundColor(Color("Point"))
                    }
                    Text(Temperature.getStringFor(string: Temperature.allCases[currentPage]))
                        .foregroundColor(Color("Serve1"))
                }
                .font(.custom(FontManager.Pretendard.bold, size: 17))
                .offset(y: 1)
                
                Text(properClothes(for: Temperature.allCases[currentPage]))
                    .foregroundColor(currentPage == todayIndex ? Color("Main") : Color("Serve1"))
                    .font(.custom(FontManager.Pretendard.semiBold, size: 15))
                    .padding(.top, -5)
                
                Image(imageName(for: Temperature.allCases[currentPage]))
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .offset(x: -10)
                    .opacity(currentPage == todayIndex ? 1.0 : 0.4)
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            
            VStack {
                Image(systemName: "chevron.up")
                    .padding(3)
                    .opacity(currentPage != 7 ? 0.6 : 0.0)
                    .onTapGesture {
                        // Higher
                        currentPage += 1
                    }
                    .disabled(currentPage != 7 ? false : true)
                    .contentShape(Rectangle())
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(3)
                    .opacity(currentPage != 0 ? 0.6 : 0.0)
                    .onTapGesture {
                        // Lower
                        currentPage -= 1
                    }
                    .disabled(currentPage != 0 ? false : true)
                    .contentShape(Rectangle())
            }
            .padding(13)
            .font(.custom(FontManager.Pretendard.regular, size: 17))
            .foregroundColor(Color("Serve2"))
        }
        .background(RoundedRectangle(cornerRadius: 19).foregroundColor(Color("Box")))
        .onChange(of: temperature) { temperature in
            todayIndex = temperatureIndex(for: Int(temperature))
            currentPage = todayIndex
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
