//
//  MoviesStars.swift
//  ios-itmo-2022-assignment2
//
//  Created by Andrey Karpenko on 17.12.2022.
//

import UIKit


class MovieStars: UIView {
    private static var yellowStar: UIImage = UIImage(named: "yellow_star.png")!.scale(3)
    private static var greyStar: UIImage = UIImage(named: "grey_star.png")!.scale(3)
    
    private static var starsSize: Int = 5
    
    private var stars: Array<UIButton> = []
    private var onTapStarWithIndex: (Int) -> () = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ onTapStarWithIndex: @escaping (Int) -> ()) {
        self.onTapStarWithIndex = onTapStarWithIndex
    }
    
    private func setupView() {
        var starConstraints: Array<NSLayoutConstraint> = []
        for i in 0...MovieStars.starsSize - 1 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(MovieStars.greyStar, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            stars.append(button)
            addSubview(stars[i])
            starConstraints.append(stars[i].topAnchor.constraint(equalTo: topAnchor))
            starConstraints.append(stars[i].bottomAnchor.constraint(equalTo: bottomAnchor))
            if i == 0 {
                starConstraints.append(stars[i].leadingAnchor.constraint(equalTo: leadingAnchor))
            } else {
                starConstraints.append(stars[i].leadingAnchor.constraint(equalTo: stars[i - 1].trailingAnchor, constant: 4))
            }
            if i == MovieStars.starsSize - 1 {
                starConstraints.append(stars[i].trailingAnchor.constraint(equalTo: trailingAnchor))
            }
        }
        
        NSLayoutConstraint.activate(starConstraints)
    }
    
    @objc
    private func didTapStar(sender: UIButton) {
        self.updateStars(sender.tag)
        self.onTapStarWithIndex(sender.tag)
    }
    
    func updateStars(_ index: Int) {
        for (i, star) in stars.enumerated() {
            if (i <= index) {
                star.setImage(MovieStars.yellowStar, for: .normal)
            } else {
                star.setImage(MovieStars.greyStar, for: .normal)
            }
        }
    }
}

extension UIImage {
    func scale(_ c: Int) -> UIImage {
        return resize(to: CGSize(width: size.width / CGFloat(c), height: size.height / CGFloat(c)))
    }
    
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
