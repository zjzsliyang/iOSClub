import UIKit

public protocol VAMonthHeaderViewDelegate: class {
    func didTapNextMonth()
    func didTapPreviousMonth()
    func didTapAdd()
}

public struct VAMonthHeaderViewAppearance {
    
    let monthFont: UIFont
    let monthTextColor: UIColor
    let monthTextWidth: CGFloat
    let previousButtonImage: UIImage
    let nextButtonImage: UIImage
    let addEventButtonImage: UIImage
    let dateFormatter: DateFormatter
    
    static public let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    public init(
        monthFont: UIFont = UIFont.systemFont(ofSize: 21),
        monthTextColor: UIColor = UIColor.black,
        monthTextWidth: CGFloat = 150,
        previousButtonImage: UIImage = UIImage(),
        nextButtonImage: UIImage = UIImage(),
        addEventButtonImage: UIImage = UIImage(),
        
        dateFormatter: DateFormatter = VAMonthHeaderViewAppearance.defaultFormatter) {
        self.monthFont = monthFont
        self.monthTextColor = monthTextColor
        self.monthTextWidth = monthTextWidth
        self.previousButtonImage = previousButtonImage
        self.nextButtonImage = nextButtonImage
        self.addEventButtonImage = addEventButtonImage
        self.dateFormatter = dateFormatter
    }
    
}

public class VAMonthHeaderView: UIView {
    
    public var appearance = VAMonthHeaderViewAppearance() {
        didSet {
            dateFormatter = appearance.dateFormatter
            setupView()
        }
    }
    
    public weak var delegate: VAMonthHeaderViewDelegate?
    
    private var dateFormatter = DateFormatter()
    private let monthLabel = UILabel()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private let addEventButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = 50.0
        monthLabel.frame = CGRect(x: 0, y: 0, width: appearance.monthTextWidth, height: frame.height)
        monthLabel.center.x = center.x
        previousButton.frame = CGRect(x: monthLabel.frame.minX - buttonWidth, y: 0, width: buttonWidth, height: frame.height)
        nextButton.frame = CGRect(x: monthLabel.frame.maxX, y: 0, width: buttonWidth, height: frame.height)
        addEventButton.frame = CGRect(x: monthLabel.frame.maxX + buttonWidth, y: 0, width: frame.height, height: frame.height)
    }
    
    private func setupView() {
        subviews.forEach{ $0.removeFromSuperview() }
        
        backgroundColor = .white
        monthLabel.font = appearance.monthFont
        monthLabel.textAlignment = .center
        monthLabel.textColor = appearance.monthTextColor
        
        previousButton.setImage(appearance.previousButtonImage, for: .normal)
        previousButton.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        
        nextButton.setImage(appearance.nextButtonImage, for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        
        addEventButton.setImage(appearance.addEventButtonImage, for: .normal)
        addEventButton.addTarget(self, action: #selector(didTapAdd(_:)), for: .touchUpInside)
        
        addSubview(monthLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        addSubview(addEventButton)
        
        layoutSubviews()
    }
    
    @objc
    private func didTapAdd(_ sender: UIButton) {
        delegate?.didTapAdd()
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        delegate?.didTapNextMonth()
    }
    
    @objc
    private func didTapPrevious(_ sender: UIButton) {
        delegate?.didTapPreviousMonth()
    }
    
}

extension VAMonthHeaderView: VACalendarMonthDelegate {
    
    public func monthDidChange(_ currentMonth: Date) {
        monthLabel.text = dateFormatter.string(from: currentMonth)
    }
    
}
