import UIKit

extension GraffeineLayer {

    public struct SelectionResult {
        public let point: CGPoint
        public let data: GraffeineData
        public let layer: GraffeineLayer
        public init(point: CGPoint, data: GraffeineData, layer: GraffeineLayer) {
            self.point = point; self.data = data; self.layer = layer
        }
    }

    public struct Selection {
        public var isEnabled: Bool = false
        public var fill:   Fill   = Fill()
        public var line:   Line   = Line()
        public var text:   Text   = Text()
        public var radial: Radial = Radial()

        public struct Fill {
            public var color: UIColor? = nil
        }

        public struct Line {
            public var color: UIColor? = nil
            public var thickness: CGFloat? = nil
        }

        public struct Text {
            public var color: UIColor? = nil
        }

        public struct Radial {
            public var diameter: DimensionalUnit? = nil
            public var holeDiameter: DimensionalUnit? = nil
        }
    }

    public func applySelectionState(_ layer: CALayer, index: Int) {
        guard (data.selectedIndex == index) else { return }

        if let shape = layer as? CAShapeLayer {
            if let color = selection.fill.color { shape.fillColor = color.cgColor }
            if let color = selection.line.color { shape.strokeColor = color.cgColor }
            if let thickness = selection.line.thickness { shape.lineWidth = thickness }
        }

        if let text = layer as? CATextLayer {
            if let color = selection.fill.color { text.backgroundColor = color.cgColor }
            if let color = selection.line.color { text.borderColor = color.cgColor }
            if let color = selection.text.color { text.foregroundColor = color.cgColor }
            if let thickness = selection.line.thickness { text.borderWidth = thickness }
        }
    }

    public func findSelected(_ point: CGPoint) -> SelectionResult? {
        guard (self.selection.isEnabled),
            let foundIndex = findSublayerIndex(for: point),
            let layerCenter = centerPointForLayer(at: foundIndex)
            else { return nil }

        var selectionData = self.data
        selectionData.selectedIndex = foundIndex

        return SelectionResult(
            point: layerCenter,
            data: selectionData,
            layer: self
        )
    }

    internal func findSublayerIndex(for point: CGPoint) -> Int? {
        return (sublayers ?? []).enumerated().first(where: {
            (($0.element as? CAShapeLayer)?.path?.contains(point) ?? false)
                || (($0.element as? CATextLayer)?.frame.contains(point) ?? false)
            })?.offset
    }

    internal func centerPointForLayer(at index: Int) -> CGPoint? {
        guard let sublayers = self.sublayers,
            (index < sublayers.count) else { return nil }

        if let layer = sublayers[index] as? CAShapeLayer,
            let shapeFrame = layer.path?.boundingBoxOfPath {
            return CGPoint(x: shapeFrame.origin.x + (shapeFrame.size.width  / 2),
                           y: shapeFrame.origin.y + (shapeFrame.size.height / 2))
        }

        if let layer = sublayers[index] as? CATextLayer {
            return CGPoint(x: layer.frame.origin.x + (layer.frame.size.width  / 2),
                           y: layer.frame.origin.y + (layer.frame.size.height / 2))
        }

        return nil
    }
}
