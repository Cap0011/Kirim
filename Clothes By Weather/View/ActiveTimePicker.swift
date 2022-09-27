//
//  ActiveTimePicker.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import SwiftUI

struct ActiveTimePicker: View {
    @Binding var isShowingPickerView: Bool
    
    @Binding var startHour: Int
    @Binding var endHour: Int
    
    @State var selectedStartHour: Int
    @State var selectedEndHour: Int
        
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("나의 외출 시간대")
                    HStack(spacing: 0) {
                        Picker(selection: $selectedStartHour, label: Text("")) {
                            ForEach(0 ..< selectedEndHour, id: \.self) { hour in
                                Text("\(hour):00").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width / 5 * 2, alignment: .center)
                        .compositingGroup()
                        .clipped()
                        
                        Text("-")
                            .frame(width: geometry.size.width / 5, alignment: .center)
                        
                        Picker(selection: $selectedEndHour, label: Text("")) {
                            ForEach(selectedStartHour ... 24, id: \.self) { hour in
                                Text("\(hour):00").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width / 5 * 2, alignment: .center)
                        .compositingGroup()
                        .clipped()
                    }
                }
                .font(.custom(FontManager.Pretendard.bold, size: 18))
                .foregroundColor(Color("Serve1"))
                .background(Color("Box"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isShowingPickerView.toggle()
                        } label: {
                            Text("취소")
                                .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                                .foregroundColor(Color("Main"))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingPickerView.toggle()
                            startHour = selectedStartHour
                            endHour = selectedEndHour
                            if let groupUserDefaults = UserDefaults(suiteName: "group.HY8Y957QK3.com.jio.weatherwidget") {
                                groupUserDefaults.setValue(selectedStartHour, forKey: "startHour")
                                groupUserDefaults.setValue(selectedEndHour, forKey: "endHour")
                            } else {
                                print("Failed")
                            }
                        } label: {
                            Text("완료")
                                .font(.custom(FontManager.Pretendard.bold, size: 16))
                                .foregroundColor(Color("Main"))
                        }
                    }
                }
            }
        }
    }
}
