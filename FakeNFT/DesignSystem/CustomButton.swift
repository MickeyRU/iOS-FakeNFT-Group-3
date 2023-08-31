import UIKit

final class CustomButton: UIButton {
    init(title: String, action: Selector) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = .unBlack
        titleLabel?.font = .sfBold17
        layer.cornerRadius = 16
        layer.masksToBounds = true
        addTarget(Any?.self, action: action, for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
