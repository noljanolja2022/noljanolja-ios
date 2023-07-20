//
//  Date+Format.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

extension Date {
    func relative(to date: Date = Date()) -> String? {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: date)
    }

    func relativeFormatForConversation() -> String {
        let dateFormatter = DateFormatter()

        if isInToday {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        } else if let relativeFormatted = relativeFormatForChat() {
            return relativeFormatted
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: self)
        }
    }

    func relativeFormatForMessage() -> String {
        let dateFormatter = DateFormatter()
        if let relativeFormatted = relativeFormatForChat() {
            return relativeFormatted
        } else {
            dateFormatter.dateFormat = "EEEE, yyyy, MMMM dd"
            return dateFormatter.string(from: self)
        }
    }
}

extension Date {
    private func relativeFormatForChat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")

        dateFormatter.dateStyle = .full
        dateFormatter.doesRelativeDateFormatting = true
        let relative = dateFormatter.string(from: self)
        dateFormatter.doesRelativeDateFormatting = false
        let absolute = dateFormatter.string(from: self)

        return relative != absolute ? relative : nil
    }
}
