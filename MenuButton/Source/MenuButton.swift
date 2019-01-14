import UIKit

private struct Defaults {
    struct Line {
        static let width: CGFloat = 28
        static let height: CGFloat = 2
        static let color: UIColor = .white
        static let duration: Double = 0.5
    }
    
    struct Circle {
        static let stokeStartOpen: CGFloat = 0.325
        static let stokeStartClose: CGFloat = 0.0
        static let stokeEndOpen: CGFloat = 1
        static let stokeEndClose: CGFloat = 0.109
    }
}

class MenuButton : UIButton {
    
    private let circlePath: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 27))
        path.addCurve(to: CGPoint(x: 40, y: 27), control1: CGPoint(x: 12, y: 27), control2: CGPoint(x: 28.02, y: 27))
        path.addCurve(to: CGPoint(x: 27, y: 02), control1: CGPoint(x: 55.92, y: 27), control2: CGPoint(x: 50.47, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        path.addCurve(to: CGPoint(x: 27, y: 52), control1: CGPoint(x: 2, y: 40.84), control2: CGPoint(x: 13.16, y: 52))
        path.addCurve(to: CGPoint(x: 52, y: 27), control1: CGPoint(x: 40.84, y: 52), control2: CGPoint(x: 52, y: 40.84))
        path.addCurve(to: CGPoint(x: 27, y: 2), control1: CGPoint(x: 52, y: 13.16), control2: CGPoint(x: 42.39, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        return path
    }()
    
    private let linePath: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: Defaults.Line.height))
        path.addLine(to: CGPoint(x: Defaults.Line.width, y: Defaults.Line.height))
        return path
    }()
    
    private var topLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    private var bottomLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    private var middleLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    private var isOpen: Bool = false
    private let timingFucntion = CAMediaTimingFunction(controlPoints: 0.5, -0.3, 0.8, 1.5)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        let padding: CGFloat = 10
        let x: CGFloat = (self.frame.width - Defaults.Line.width) * 1.7
        var y: CGFloat = padding
        
        [topLayer, middleLayer, bottomLayer].forEach {
            $0.path = linePath
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeColor = Defaults.Line.color.cgColor
            $0.lineWidth = Defaults.Line.height + 2
            $0.lineCap = .round
            $0.frame = $0.path!.bounds
            $0.position = CGPoint(x: x, y: y)
            y += padding
            self.layer.addSublayer($0)
        }
        
        self.topLayer.anchorPoint = CGPoint(x: 0.93, y: 0.5)
        self.bottomLayer.anchorPoint = self.topLayer.anchorPoint
        self.middleLayer.position.x = self.topLayer.frame.origin.x + 2
        self.middleLayer.position.y = -padding / 2
        self.middleLayer.path = circlePath
        self.middleLayer.strokeStart = Defaults.Circle.stokeStartClose
        self.middleLayer.strokeEnd = Defaults.Circle.stokeEndClose
    }
    
    private func startTopAnimation(_ isOpen: Bool) {
        self.animateLine(self.topLayer, angle: -CGFloat.pi/4, translation: CATransform3DMakeTranslation(-4, 3, 0))
    }
    
    private func startBottomAnimation(_ isOpen: Bool) {
        self.animateLine(self.bottomLayer, angle: CGFloat.pi/4, translation: CATransform3DMakeTranslation(-2, 0, 0))
    }
    
    private func animateLine(_ layer: CALayer, angle: CGFloat, translation: CATransform3D) {
        let bottomTransform = Init(CABasicAnimation(keyPath: "transform")) {
            $0.timingFunction = timingFucntion
            $0.duration = Defaults.Line.duration
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
            $0.beginTime = CACurrentMediaTime() + 0.35
            $0.toValue = isOpen ? NSValue(caTransform3D: CATransform3DIdentity) :
                NSValue(caTransform3D: CATransform3DRotate(translation, angle, 0, 0, 1))
        }
        
        layer.add(bottomTransform, forKey: "transform")
    }
    
    private func setupCircleAnimation(_ isOpen: Bool) {
        let strokeStart = Init(CABasicAnimation(keyPath: "strokeStart")) {
            $0.duration = 0.8
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
            $0.toValue = isOpen ? Defaults.Circle.stokeStartClose : Defaults.Circle.stokeStartOpen
            $0.timingFunction = timingFucntion
        }
        
        let strokeEnd = Init(CABasicAnimation(keyPath: "strokeEnd")) {
            $0.duration = 0.8
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards

            $0.toValue = isOpen ? Defaults.Circle.stokeEndClose : Defaults.Circle.stokeEndOpen
            $0.timingFunction = timingFucntion
        }
        
        middleLayer.add(strokeStart, forKey: "strokeStart")
        middleLayer.add(strokeEnd, forKey: "strokeEnd")
    }
    
    func toggle() {
        startTopAnimation(isOpen)
        startBottomAnimation(isOpen)
        setupCircleAnimation(isOpen)
        isOpen = !isOpen
    }
}

extension CGPath {
    var bounds: CGRect {
        return self.boundingBoxOfPath
    }
}

func Init<Type>(_ object: Type, block: (Type) -> ()) -> Type {
    block(object)
    return object
}
