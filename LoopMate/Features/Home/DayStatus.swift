//
//  DayStatus.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/05.
//

import Foundation

enum DayStatus {
    case done
    case notDone
}

func dayKey(_ date: Date) -> Date {
    return Calendar.current.startOfDay(for: date)
}

func makeStatusByDay() -> [Date: DayStatus] {
    var dict: [Date: DayStatus] = [:]

    let fmt = DateFormatter()
    fmt.locale = Locale(identifier: "ja_JP")
    fmt.dateFormat = "yyyy/MM/dd"

    if let d = fmt.date(from: "2026/03/05") {
        dict[dayKey(d)] = .done
    }
    if let d = fmt.date(from: "2026/03/12") {
        dict[dayKey(d)] = .notDone
    }

    return dict
}
