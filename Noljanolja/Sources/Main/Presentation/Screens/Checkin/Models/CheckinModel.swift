//
//  CheckinModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Foundation

struct CheckinModel: Equatable {
    let currentDate = Date()
    let weekdays = ["2", "3", "4", "5", "6", "7", "Sun"]
    let checkinProgresses: [CheckinProgress]
    let itemViewModels: [CheckinItemViewModel?]
    let isCheckinEnabled: Bool

    init(checkinProgresses: [CheckinProgress]) {
        self.checkinProgresses = checkinProgresses
        self.itemViewModels = {
            let weekdays = [2, 3, 4, 5, 6, 7, 1]
            let weekdayIndex = weekdays.firstIndex {
                checkinProgresses.first?.day.weekday == $0
            }
            let emptyItemViewModels = [CheckinItemViewModel?](repeating: nil, count: weekdayIndex ?? 0)
            let itemViewModels = checkinProgresses.map { CheckinItemViewModel(checkinProgress: $0) }
            return emptyItemViewModels + itemViewModels
        }()
        self.isCheckinEnabled = true // {
//            let todayCheckinProgress = checkinProgresses.first(where: { Calendar.current.isDateInToday($0.day) })
//            return todayCheckinProgress?.isCompleted ?? false
//        }()
    }

    var isEmpty: Bool {
        itemViewModels.isEmpty
    }
}
