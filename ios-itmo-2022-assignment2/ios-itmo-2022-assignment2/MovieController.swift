import UIKit

class MovieController: UIViewController{
    private let whiteSmoke = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    private let greenDisabled = UIColor(red: 0.36, green: 0.69, blue: 0.46, alpha: 1.00)
    public static let dateFormat = "yyyy"
    var delegate: MovieControllerDelegate?
    
    private lazy var header: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(pageTitle)
        
        NSLayoutConstraint.activate([
            pageTitle.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: header.topAnchor),
            pageTitle.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        return header
    }()
    
    private lazy var body: UIView = {
        let body = UIView()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.addSubview(textFields)
        body.addSubview(rating)

        NSLayoutConstraint.activate([
            textFields.topAnchor.constraint(equalTo: body.topAnchor),
            textFields.trailingAnchor.constraint(equalTo: body.trailingAnchor),
            textFields.leadingAnchor.constraint(equalTo: body.leadingAnchor),
            
            rating.topAnchor.constraint(equalTo: textFields.bottomAnchor, constant: 40),
            rating.centerXAnchor.constraint(equalTo: body.centerXAnchor),
            rating.bottomAnchor.constraint(equalTo: body.bottomAnchor)
        ])
        return body
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = greenDisabled
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        saveButton.layer.cornerRadius = 25
        saveButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        saveButton.alpha = 0.4
        saveButton.isEnabled = false
        return saveButton
    }()
    
    private lazy var validDataButton: UIButton = {
        let validDataButton = UIButton()
        validDataButton.translatesAutoresizingMaskIntoConstraints = false
        validDataButton.backgroundColor = greenDisabled
        validDataButton.setTitle("Заполнить поля", for: .normal)
        validDataButton.setTitleColor(.white, for: .normal)
        validDataButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        validDataButton.layer.cornerRadius = 25
        validDataButton.addTarget(self, action: #selector(didTapFillInForm), for: .touchUpInside)
        return validDataButton
    }()
    
    @objc
    private func didTapFillInForm() {
        if nameInputField.textField.text == "" {
            nameInputField.textField.text = randomString(length: 10)
            nameInputField.textFieldNeedValidation()
        }
        if directorInputField.textField.text == "" {
            directorInputField.textField.text = randomString(length: 10) + " " + randomString(length: 10)
            directorInputField.textFieldNeedValidation()
        }
        if yearInputField.textField.text == "" {
            let date1 = Date.parse("1000")
            let date2 = Date.parse("2022")
            yearInputField.textField.text = Date.randomBetween(start: date1, end: date2).dateString()
            yearInputField.textFieldNeedValidation()
        }
        if rating.curRating == 0 {
            rating.rateByIndex(index: Int.random(in: 0..<5))
        }
    }
    
    private func randomString(length: Int) -> String {
        let capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String(capitalLetters.randomElement()!) + String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private lazy var textFields: UIView = {
        let textFields = UIView()
        textFields.translatesAutoresizingMaskIntoConstraints = false
        textFields.addSubview(nameInputField)
        textFields.addSubview(directorInputField)
        textFields.addSubview(yearInputField)
        
        NSLayoutConstraint.activate([
            nameInputField.topAnchor.constraint(equalTo: textFields.topAnchor, constant: 8),
            nameInputField.trailingAnchor.constraint(equalTo: textFields.trailingAnchor, constant: -8),
            nameInputField.leadingAnchor.constraint(equalTo: textFields.leadingAnchor, constant: 8),
            
            directorInputField.topAnchor.constraint(equalTo: nameInputField.bottomAnchor, constant: 16),
            directorInputField.trailingAnchor.constraint(equalTo: textFields.trailingAnchor, constant: -8),
            directorInputField.leadingAnchor.constraint(equalTo: textFields.leadingAnchor, constant: 8),
            
            yearInputField.topAnchor.constraint(equalTo: directorInputField.bottomAnchor, constant: 16),
            yearInputField.trailingAnchor.constraint(equalTo: textFields.trailingAnchor, constant: -8),
            yearInputField.leadingAnchor.constraint(equalTo: textFields.leadingAnchor, constant: 8),
            yearInputField.bottomAnchor.constraint(equalTo: textFields.bottomAnchor, constant: -8),
        ])
        return textFields
    }()
    
    private lazy var pageTitle: UILabel = {
        let pageTitle = UILabel()
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.text = "Фильм"
        pageTitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.semibold)
        pageTitle.textAlignment = .center
        return pageTitle
    }()
    
    private lazy var nameInputField: InputField = {
        let nameInputField = InputField()
        nameInputField.configureView(title: "Название", placeholder: "Название фильма", checkActive)
        nameInputField.configureValidation(validationFunc: nameValidation)
        nameInputField.translatesAutoresizingMaskIntoConstraints = false
        return nameInputField
    }()
    
    private lazy var directorInputField: InputField = {
        let directorInputField = InputField()
        directorInputField.configureView(title: "Режисёр", placeholder: "Режисёр фильма", checkActive)
        directorInputField.configureValidation(validationFunc: directorValidation)
        directorInputField.translatesAutoresizingMaskIntoConstraints = false
        return directorInputField
    }()
    
    private lazy var yearInputField: InputField = {
        let date = InputField()
        date.configureView(title: "Год", placeholder: "Год выпуска", checkActive)
        date.textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        date.configureValidation(validationFunc: dateValidation)
        date.translatesAutoresizingMaskIntoConstraints = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapOnDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        date.textField.inputAccessoryView = toolBar
        return date
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = TimeZone.current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var rating: StarsRating = {
        var ratingStars = StarsRating()
        ratingStars.translatesAutoresizingMaskIntoConstraints = false
        ratingStars.configureView(checkActive)
        return ratingStars
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(body)
        view.addSubview(saveButton)
        view.addSubview(validDataButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            body.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.bottomAnchor, constant: 32),
            body.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            body.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 51),
            
            validDataButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),
            validDataButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            validDataButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            validDataButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
    
    @objc func didTapButton(_ sender:UIButton!) {
        navigationController?.popViewController(animated: true)
        delegate?.onSaveMovie(movie: Movie(name: nameInputField.textField.text ?? "",
                                           director: directorInputField.textField.text ?? "",
                                           year: Int(yearInputField.textField.text ?? "") ?? 0,
                                           rating: rating.curRating))
    }
    
    private func checkActive() {
        if nameInputField.isValid
            && directorInputField.isValid
            && yearInputField.isValid
            && rating.curRating != 0 {
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        } else {
            saveButton.isEnabled = false
            saveButton.alpha = 0.4
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkActive()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkActive()
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameInputField.textField.resignFirstResponder()
        directorInputField.textField.resignFirstResponder()
        yearInputField.textField.resignFirstResponder()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = MovieController.dateFormat
        yearInputField.textField.text = dateFormatter.string(from: sender.date)
        yearInputField.textFieldNeedValidation()
     }
    
    @objc func tapOnDoneButton(sender: UIDatePicker) {
        yearInputField.textField.resignFirstResponder()
    }
    
    func nameValidation(name: String) -> Bool {
        return name.count <= 300 && name.count >= 1
    }
    
    func directorValidation(directorField: String) -> Bool {
        let names = directorField.components(separatedBy: " ")
        for n in names {
            if (n.isEmpty) {
                continue
            }
            if !(n.latinCharactersOnly || n.cyrillicCharactersOnly) {
                return false
            }
        }
        return directorField.count <= 300 && directorField.count >= 3 && directorField.capitalized == directorField
    }
    
    func dateValidation(date: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = MovieController.dateFormat
        
        return dateFormatterGet.date(from: date) != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = greenDisabled
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

extension String {
    var latinCharactersOnly: Bool {
        return self.range(of: "\\P{Latin}", options: .regularExpression) == nil
    }
    var cyrillicCharactersOnly: Bool {
        return self.range(of: "\\P{Cyrillic}", options: .regularExpression) == nil
    }
}


extension Date {
    
    static func randomBetween(start: String, end: String, format: String = "dd.MM.yyyy") -> String {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2).dateString(format)
    }

    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    func dateString(_ format: String = MovieController.dateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func parse(_ string: String, format: String = MovieController.dateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
}
