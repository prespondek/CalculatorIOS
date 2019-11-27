import Foundation
import UIKit

extension StringProtocol {
    subscript(_ offset: Int) -> Element
    { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>) -> SubSequence
    { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>) -> SubSequence
    { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence
    { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence
    { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence
    { suffix(Swift.max(0, count-range.lowerBound)) }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

extension UILabel {

    var isTruncated: Bool {

        guard let labelText = text else { return false }
        
        let maxWidth = bounds.size.width
        let labelWidth = (labelText as NSString).size(withAttributes: [NSAttributedString.Key.font:font!]).width

        return labelWidth > maxWidth
    }
}
