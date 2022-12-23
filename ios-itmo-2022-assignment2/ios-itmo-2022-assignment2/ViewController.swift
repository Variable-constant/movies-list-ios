//
//  ViewController.swift
//  ios-itmo-2022-assignment2
//
//  Created by rv.aleksandrov on 29.09.2022.
//

import UIKit

class ViewController: UIViewController {
    private let orange = UIColor(red: 0.98, green: 0.67, blue: 0.20, alpha: 1.00)
    private let greenDisabled = UIColor(red: 0.36, green: 0.69, blue: 0.46, alpha: 1.00)
    private let red = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
    private let mintSection = UIColor(red: 0.80, green: 1.00, blue: 1.00, alpha: 1.00)
    
    private var moviesByYear: Dictionary<Int, [Movie]> = [
        1980: [
            Movie(name: "ios-vk-course", director: "vk", year: 1980, rating: 2),
            Movie(name: "1+1", director: "some-french-fellow", year: 1980, rating: 5),
            Movie(name: "meow", director: "meow", year: 1980, rating: 4),
            Movie(name: "kek", director: "lol", year: 1980, rating: 1),
        ],
        2000: [
            Movie(name: "controller", director: "scene", year: 2000, rating: 2),
            Movie(name: "xxx", director: "yyy", year: 2000, rating: 2),
        ],
        2020: [
            Movie(name: "123", director: "aaa", year: 2020, rating: 2),
        ],
    ]
    
    private var years: Array<Int> = [1980, 2000, 2020]
    
    lazy var moviesTableView: UITableView = {
        let moviesTableView = UITableView()
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.allowsSelection = false
        moviesTableView.separatorColor = moviesTableView.backgroundColor
        return moviesTableView
    }()
    
    private lazy var addMovieButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = greenDisabled
        saveButton.setTitle("Добавить фильм", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        saveButton.layer.cornerRadius = 25
        saveButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        saveButton.isEnabled = true
        return saveButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        
        view.backgroundColor = .white
        view.addSubview(addMovieButton)
        view.addSubview(moviesTableView)
        
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            moviesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: addMovieButton.topAnchor, constant: -12),
            
            addMovieButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            addMovieButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            addMovieButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            addMovieButton.heightAnchor.constraint(equalToConstant: 51),
        ])
    }
    
    func setUpNavigation() {
        navigationItem.title = "Фильмы"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = greenDisabled
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    @objc func didTapButton(_ sender:UIButton!) {
        let movieController = MovieController()
        movieController.delegate = self
        navigationController?.pushViewController(movieController, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = moviesByYear[years[section]] else {
            return 0
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        guard let movies = moviesByYear[years[indexPath.section]] else {
            return cell
        }
        cell.movie = movies[indexPath.row]
        let year = years[indexPath.section]
        cell.ratingStars.configureView{ [self] index in
            self.moviesByYear[year]?[indexPath.row].rating = index + 1
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = String(years[section])
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])
        return view
    }
}

extension ViewController: UITableViewDelegate {
    private func handleDeleteMovie(indexPath: IndexPath) {
        let year = years[indexPath.section]
        if moviesByYear[year]?.count == 1 {
            years.remove(at: indexPath.section)
            moviesByYear.removeValue(forKey: year)
            moviesTableView.performBatchUpdates({
                moviesTableView.deleteRows(at: [IndexPath(row:indexPath.row, section: indexPath.section)], with: .none)
                moviesTableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
            })
        } else {
            moviesByYear[year]?.remove(at: indexPath.row)
            moviesTableView.performBatchUpdates({
                moviesTableView.deleteRows(at: [IndexPath(row:indexPath.row, section: indexPath.section)], with: .none)
            })
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            self?.handleDeleteMovie(indexPath: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return years.map{ i in String(i) }
    }
    
    func tableView(
        _ tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        at index: Int
    ) -> Int {
        return index
    }
}

extension ViewController: MovieControllerDelegate {
    
    func onSaveMovie(movie: Movie) {
        let year = movie.year
        let sectionNumber = years.insertionIndex(of: year)
        if years.insertUnique(year) {
            moviesByYear[year] = [movie]
            moviesTableView.performBatchUpdates({
                moviesTableView.insertSections(IndexSet(integer: sectionNumber), with: .none)
                moviesTableView.insertRows(at: [IndexPath(row:0, section: sectionNumber)], with: .none)
            })
        } else {
            moviesByYear[year]?.append(movie)
            moviesTableView.performBatchUpdates({
                moviesTableView.insertRows(at: [IndexPath(row: moviesByYear[year]!.count - 1, section: sectionNumber)], with: .none)
            })
        }
    }
}

extension Array<Int> {
    func insertionIndex(of element: Int) -> Index {
        return firstIndex(where: { $0 == element || $0 > element }) ?? endIndex
    }
    
    mutating func insertUnique(_ elem: Int) -> Bool {
        let index = insertionIndex(of: elem)
        if index < self.count && self[index] == elem {
            return false
        }
        insert(elem, at: index)
        return true
    }
}
