//
//  MovieTableViewCell.swift
//  ios-itmo-2022-assignment2
//
//  Created by Andrey Karpenko on 15.12.2022.
//

import UIKit


class MovieTableViewCell: UITableViewCell {
    var movie: Movie? {
        didSet {
            guard let movieItem = movie else {return}
            self.name.text = movieItem.name
            self.director.text = movieItem.director
            self.ratingStars.updateStars(movieItem.rating - 1)
        }
    }
    
    private lazy var nameContainer: UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.layer.borderWidth = 1
        container.clipsToBounds = true
        container.addSubview(name)
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            name.topAnchor.constraint(equalTo: container.topAnchor),
            name.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }()
    
    private lazy var name: UILabel = {
        var name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var directorContainer: UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.layer.borderWidth = 1
        container.clipsToBounds = true
        container.addSubview(director)
        NSLayoutConstraint.activate([
            director.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            director.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            director.topAnchor.constraint(equalTo: container.topAnchor),
            director.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }()
    
    private lazy var director: UILabel = {
        var director = UILabel()
        director.translatesAutoresizingMaskIntoConstraints = false
        return director
    }()
    
    lazy var ratingStars: MovieStars = {
        var stars = MovieStars()
        stars.translatesAutoresizingMaskIntoConstraints = false
        return stars
    }()
    
    
    
    private lazy var ratingContainer: UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.layer.borderWidth = 1
        container.addSubview(ratingStars)
        NSLayoutConstraint.activate([
            ratingStars.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            ratingStars.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        return container
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(nameContainer)
        contentView.addSubview(directorContainer)
        contentView.addSubview(ratingContainer)
        
        NSLayoutConstraint.activate([
            nameContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            directorContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            directorContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            directorContainer.leadingAnchor.constraint(equalTo: nameContainer.trailingAnchor),
            directorContainer.trailingAnchor.constraint(equalTo: ratingContainer.leadingAnchor),
            directorContainer.widthAnchor.constraint(equalTo: nameContainer.widthAnchor),
            
            ratingContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            ratingContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ratingContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingContainer.widthAnchor.constraint(equalTo: directorContainer.widthAnchor, constant: CGFloat(30))
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
