//
//  MovieControllerDelegate.swift
//  ios-itmo-2022-assignment2
//
//  Created by Andrey Karpenko on 15.12.2022.
//

import Foundation

protocol MovieControllerDelegate {
    func onSaveMovie(movie: Movie)
}
