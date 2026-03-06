//
//  RoomCreateView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/07.
//

import SwiftUI

struct RoomCreateView: View {
    
    @State private var roomName: String = ""
    @State private var isNumberRequired = false
    @State private var isPhotoRequired = false
    @State private var startDate = Date()
    @State private var isShowingStartDatePicker = false
    @State private var endDate: Date? = nil
    @State private var isShowingEndDatePicker = false
    @State private var selectedWeekdays: [Bool] = Array(repeating: false, count: 7)
    private let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private var endDateTextColor: Color {
        if isShowingEndDatePicker {
            return .accentColor
        } else if endDate == nil {
            return .gray
        } else {
            return .black
        }
    }

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.orange).opacity(0.1).ignoresSafeArea()
                ScrollView {
                    VStack {
                        TextField("ルーム名を入力", text: $roomName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        Button {
                            // あとで画面遷移の処理を書く
                        } label: {
                            HStack {
                                Text("習慣を選ぶ")
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Toggle(isOn: $isNumberRequired) {
                            Text("数値入力の義務化")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Toggle(isOn: $isPhotoRequired) {
                            Text("写真撮影の義務化")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(spacing: 0) {
                            Button {
                                withAnimation {
                                    isShowingStartDatePicker.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("開始日")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Text(formattedStartDate)
                                        .foregroundStyle(isShowingStartDatePicker ? .orange : .black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(20)
                                }
                                .frame(height: 28)
                                .padding()
                                .background(Color.white)
                            }
                            
                            if isShowingStartDatePicker {
                                Divider()
                                
                                DatePicker(
                                    "",
                                    selection: $startDate,
                                    in: today...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .tint(.orange)
                                .padding()
                                .background(Color.white)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(spacing: 0) {
                            Button {
                                withAnimation {
                                    isShowingEndDatePicker.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("終了日")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Text(formattedEndDate)
                                        .foregroundStyle(endDateTextColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(20)
                                }
                                .frame(height: 28)
                                .padding()
                                .background(Color.white)
                            }

                            if isShowingEndDatePicker {
                                Divider()

                                DatePicker(
                                    "",
                                    selection: Binding(
                                        get: { endDate ?? Date() },
                                        set: { endDate = $0 }
                                    ),
                                    in: startDate...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .tint(.orange)
                                .padding()
                                .background(Color.white)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("曜日の設定")
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                ForEach(0..<weekdaySymbols.count, id: \.self) { index in
                                    Button {
                                        selectedWeekdays[index].toggle()
                                    } label: {
                                        Text(weekdaySymbols[index])
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(selectedWeekdays[index] ? .white : .black)
                                            .frame(width: 36, height: 36)
                                            .background(
                                                selectedWeekdays[index]
                                                ? Color.orange
                                                : Color(.systemGray5)
                                            )
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .padding(.top)
                    
                    
                }
            }
            .navigationTitle("新規ルーム")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("作成")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            .onChange(of: startDate) {
                if let currentEndDate = endDate, currentEndDate < startDate {
                    endDate = startDate
                }
            }
        }
    }
    
    private var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: startDate)
    }
    
    private var formattedEndDate: String {
        guard let endDate else { return "未設定" }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        
        return formatter.string(from: endDate)
    }
}

#Preview {
    RoomCreateView()
}
