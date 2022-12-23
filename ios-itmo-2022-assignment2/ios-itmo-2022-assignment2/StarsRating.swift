//
//  StarsRating.swift
//  ios-itmo-2022-assignment2
//
//  Created by Andrey Karpenko on 02.12.2022.
//

import UIKit


class StarsRating: UIView {
    private static var yellowStar: UIImage = UIImage(named: "yellow_star.png")!
    private static var greyStar: UIImage = UIImage(named: "grey_star.png")!
    private static var ratingNames: Array<String> = ["Ужасно", "Плохо", "Нормально", "Хорошо", "AMAZING!"]
    private static var starsSize: Int = 5
    
    private var stars: Array<UIButton> = []
    private var onEndEditing: () -> () = {}
    var curRating: Int = 0
    
    private lazy var yourRating: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = .systemGray2
        label.text = "Ваша оценка"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ onEndEditing: @escaping () -> ()) {
        self.onEndEditing = onEndEditing
    }
    
    private func setupView() {
        var starConstraints: Array<NSLayoutConstraint> = []
        for i in 0...StarsRating.starsSize - 1 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(StarsRating.greyStar, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            stars.append(button)
            addSubview(stars[i])
            starConstraints.append(stars[i].topAnchor.constraint(equalTo: topAnchor))
            if i == 0 {
                starConstraints.append(stars[i].leadingAnchor.constraint(equalTo: leadingAnchor))
            } else {
                starConstraints.append(stars[i].leadingAnchor.constraint(equalTo: stars[i - 1].trailingAnchor, constant: 12))
            }
            if i == StarsRating.starsSize - 1 {
                starConstraints.append(stars[i].trailingAnchor.constraint(equalTo: trailingAnchor))
            }
        }
        addSubview(yourRating)
        
        starConstraints.append(contentsOf: [
            yourRating.topAnchor.constraint(equalTo: stars[0].bottomAnchor, constant: 24),
            yourRating.centerXAnchor.constraint(equalTo: centerXAnchor),
            yourRating.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate(starConstraints)
    }
    
    func rateByIndex(index: Int) {
        self.curRating = index + 1
        yourRating.text = StarsRating.ratingNames[index]
        self.updateStars(index)
        self.onEndEditing()
    }
    
    @objc
    private func didTapStar(sender: UIButton) {
        rateByIndex(index: sender.tag)
    }
    
    private func updateStars(_ index: Int) {
        for (i, star) in stars.enumerated() {
            if (i <= index) {
                star.setImage(StarsRating.yellowStar, for: .normal)
            } else {
                star.setImage(StarsRating.greyStar, for: .normal)
            }
        }
    }
}
