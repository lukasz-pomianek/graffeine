import UIKit

extension GraffeineLayer {

    public struct DistributedLabelAlignment {
        public var horizontal: Horizontal
        public var vertical: Vertical

        public func graffeineLabelAlignment(for index: Int, count: Int) -> GraffeineLabel.Alignment {
            return GraffeineLabel.Alignment(
                horizontal: horizontal.labelAlignment(for: index, count: count),
                vertical: vertical.labelAlignment(for: index, count: count)
            )
        }

        public init(horizontal: Horizontal, vertical: Vertical) {
            self.horizontal = horizontal
            self.vertical = vertical
        }

        internal static let horizontalLabelAlignmentMap: [DistributedLabelAlignment.Horizontal: GraffeineLabel.Alignment.Horizontal] = [
            .left: .left,
            .right: .right,
            .center: .center
        ]

        internal static let verticalLabelAlignmentMap: [DistributedLabelAlignment.Vertical: GraffeineLabel.Alignment.Vertical] = [
            .top: .top,
            .center: .center,
            .bottom: .bottom
        ]


        public enum Horizontal {
            case left, right, center, centerLeftRight

            public func labelAlignment(for index: Int, count: Int) -> GraffeineLabel.Alignment.Horizontal {
                return DistributedLabelAlignment.horizontalLabelAlignmentMap[self]
                    ?? centerLeftRightLabelAlignment(for: index, count: count)
            }

            internal func centerLeftRightLabelAlignment(for index: Int, count: Int) -> GraffeineLabel.Alignment.Horizontal {
                switch true {
                case (index == 0):
                    return .left
                case (index == count - 1):
                    return .right
                default:
                    return .center
                }
            }
        }


        public enum Vertical {
            case top, bottom, center, centerTopBottom

            public func labelAlignment(for index: Int, count: Int) -> GraffeineLabel.Alignment.Vertical {
                return DistributedLabelAlignment.verticalLabelAlignmentMap[self]
                    ?? centerTopBottomLabelAlignment(for: index, count: count)
            }

            internal func centerTopBottomLabelAlignment(for index: Int, count: Int) -> GraffeineLabel.Alignment.Vertical {
                switch true {
                case (index == 0):
                    return .top
                case (index == count - 1):
                    return .bottom
                default:
                    return .center
                }
            }
        }
    }
}
