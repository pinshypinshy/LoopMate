//
//  RoomView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/05.
//

import SwiftUI

struct RoomView: View {
    
    let roomId: String
    
    @Environment(\.dismiss) private var dismiss
    var onBack: (() -> Void)? = nil
    var shouldShowCompletionOnAppear: Bool = false
    
    @State private var isShowingCompleteView = false
    @State private var room: Room?
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    
    private let roomService = RoomService()
    
    let statusByDay = makeStatusByDay()
    @State private var selectedDate: Date = .now
    @State private var displayYear = 2026
    @State private var displayMonth = 3
    let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]
    
    let rankingRow: [User] = [
        User(id: "user_003", name: "ユーザー3"),
        User(id: "user_001", name: "ユーザー1"),
        User(id: "user_002", name: "ユーザー2")
    ]
    
    var body: some View {
        
        ZStack {
            Color(.orange).opacity(0.1).ignoresSafeArea()
            VStack {
                if isLoading {
                    ProgressView("ルーム情報を読み込み中...")
                        .padding(.top)
                } else if let room {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(room.name)
                            .font(.headline)
                        
                        Text("ルームコード: \(room.code)")
                            .foregroundStyle(.secondary)
                        
                        Text("メンバー数: \(room.memberCount)")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.top)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(monthTitle(year: displayYear, month: displayMonth))
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("今日") {
                            let today = Date()
                            let calendar = Calendar.current
                            displayYear = calendar.component(.year, from: today)
                            displayMonth = calendar.component(.month, from: today)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing)
                        
                        Button {
                            displayMonth -= 1
                            if displayMonth == 0 {
                                displayMonth = 12
                                displayYear -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            displayMonth += 1
                            if displayMonth == 13 {
                                displayMonth = 1
                                displayYear += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(weekdaySymbols, id: \.self) { symbol in
                            Text(symbol)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    let emptyCellIDs = (0..<firstWeekdayOffset(year: displayYear, month: displayMonth)).map { "empty-\($0)" }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(emptyCellIDs, id: \.self) { _ in
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        
                        ForEach(daysInMonth(year: displayYear, month: displayMonth), id: \.self) { day in
                            let date = makeDate(year: displayYear, month: displayMonth, day: day)
                            
                            DayCellView(
                                day: day,
                                date: date,
                                status: statusByDay[dayKey(date)]
                            )
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color(.white))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("ランキング")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                    
                    ScrollView {
                        VStack {
                            ForEach(rankingRow.indices, id: \.self) { index in
                                let user = rankingRow[index]
                                
                                HStack(spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.title)
                                    
                                    FriendCellView(user: user)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                }
                
                Spacer()
            }
        }
        .navigationTitle(room?.name ?? "ルーム")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if let onBack {
                        print("use onBack")
                        onBack()
                    } else {
                        print("use dismiss")
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .onAppear {
            loadRoom()
            
            if shouldShowCompletionOnAppear && !isShowingCompleteView {
                isShowingCompleteView = true
            }
        }
        .fullScreenCover(isPresented: $isShowingCompleteView) {
            RoomCreateCompleteView(
                onClose: {
                    isShowingCompleteView = false
                }
            )
        }
        .alert("ルーム情報の取得に失敗しました", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        
        
    }
    
    func makeDate(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date()
    }
    
    func daysInMonth(year: Int, month: Int) -> [Int] {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        return Array(range)
    }
    
    func firstWeekdayOffset(year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        
        guard let date = calendar.date(from: components) else {
            return 0
        }
        
        let weekday = calendar.component(.weekday, from: date)
        return weekday - 1
    }
    
    func monthTitle(year: Int, month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年 M月"
        
        let date = makeDate(year: year, month: month, day: 1)
        return formatter.string(from: date)
    }
    
    private func loadRoom() {
        isLoading = true
        
        roomService.fetchRoom(roomId: roomId) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let fetchedRoom):
                    room = fetchedRoom
                    
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoomView(roomId: "preview_room_id", onBack: {})
    }
}
