//
//  DayCellView.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/06.
//

import SwiftUI

struct DayCellView: View {
    let day: Int
    let date: Date
    let status: DayStatus?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text("\(day)")
                .foregroundStyle(Calendar.current.isDateInToday(date) ? .white : .primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Group {
                            if Calendar.current.isDateInToday(date) {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 28, height: 28)
                            }
                        }
                    )

            if status == .done {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white, .green)
                    .font(.caption2)
                    .padding(.top, 8)
                    .padding(.trailing, 2)
            } else if status == .notDone {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white, .red)
                    .font(.caption2)
                    .padding(.top, 8)
                    .padding(.trailing, 2)
            }
        }
        .frame(width: 44, height: 44)
    }
}

#Preview {
    DayCellView(day: 15, date: Date(), status: .done)
}
