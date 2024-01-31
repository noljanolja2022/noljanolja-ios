import Foundation

// MARK: - Dictionary+jsonString

extension Dictionary {
    /// Make JSON String
    /// - Parameter options: The JSONSerialization WritingOptions. Default value `.init()`
    func jsonString(options: JSONSerialization.WritingOptions = .init()) throws -> String {
        .init(
            decoding: try JSONSerialization.data(
                withJSONObject: self,
                options: options
            ),
            as: UTF8.self
        )
    }

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
