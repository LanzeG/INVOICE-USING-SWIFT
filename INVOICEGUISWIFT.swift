import UIKit

class InvoiceGUI: UIViewController {
    private var invoiceData: [String: [Int]] = [:]
    private var previousValues: [String: Int] = [:]
    private var totalSum: Int = 0
    
    private let outputArea: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let numberField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = createButton("Add")
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var undoButton: UIButton = {
        let button = createButton("Undo")
        button.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearNameButton: UIButton = {
        let button = createButton("Clear Name")
        button.addTarget(self, action: #selector(clearNameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = createButton("Calculate")
        button.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var invoiceButton: UIButton = {
        let button = createButton("Invoice")
        button.addTarget(self, action: #selector(invoiceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var printButton: UIButton = {
        let button = createButton("Print")
        button.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = createButton("Save")
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var invoiceDatasButton: UIButton = {
        let button = createButton("InvoiceDatas")
        // Add action for InvoiceDatas button
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        invoiceData = [:]
        previousValues = [:]
        totalSum = 0
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let nameLabel = UILabel()
        nameLabel.text = "Customer's Name:"
        
        let numberLabel = UILabel()
        numberLabel.text = "Undefined Price:"
        
        let formStackView = UIStackView(arrangedSubviews: [nameLabel, nameField, numberLabel, numberField])
        formStackView.axis = .vertical
        formStackView.spacing = 10
        
        let buttonsStackView = UIStackView(arrangedSubviews: [undoButton, addButton, clearNameButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        
        let predefinedButtonsStackView = UIStackView()
        predefinedButtonsStackView.axis = .horizontal
        predefinedButtonsStackView.spacing = 10
        
        let buttonValues = [50, 100, 150, 180, 200, 250, 300, 350]
        for value in buttonValues {
            let numberButton = createButton(String(value))
            numberButton.addTarget(self, action: #selector(predefinedButtonTapped(_:)), for: .touchUpInside)
            predefinedButtonsStackView.addArrangedSubview(numberButton)
        }
        
        let buttonPanel = UIStackView(arrangedSubviews: [calculateButton, buttonsStackView, invoiceButton, printButton, saveButton])
        buttonPanel.axis = .vertical
        buttonPanel.spacing = 10
        
        let mainStackView = UIStackView(arrangedSubviews: [formStackView, predefinedButtonsStackView, buttonPanel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        
        let outputPanel = UIView()
        outputPanel.addSubview(outputArea)
        outputArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outputArea.topAnchor.constraint(equalTo: outputPanel.topAnchor),
            outputArea.leadingAnchor.constraint(equalTo: outputPanel.leadingAnchor),
            outputArea.trailingAnchor.constraint(equalTo: outputPanel.trailingAnchor),
            outputArea.bottomAnchor.constraint(equalTo: outputPanel.bottomAnchor)
        ])
        
        let scrollView = UIScrollView()
        scrollView.addSubview(outputPanel)
        outputPanel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outputPanel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            outputPanel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            outputPanel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            outputPanel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            outputPanel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        view.addSubview(mainStackView)
        view.addSubview(scrollView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func addButtonTapped() {
        guard let name = nameField.text, let numberText = numberField.text, let number = Int(numberText) else {
            return
        }
        
        if !invoiceData.keys.contains(name) {
            invoiceData[name] = []
        }
        
        invoiceData[name]?.append(number)
        totalSum += number
        previousValues[name] = number
        
        numberField.text = ""
        
        let quantity = invoiceData[name]?.count ?? 0
        outputArea.text += "\(name) (Quantity: \(quantity)): \(number)\n"
    }
    
    @objc private func undoButtonTapped() {
        guard let name = nameField.text else {
            return
        }
        
        if var numbers = invoiceData[name], !numbers.isEmpty {
            let lastValue = numbers.removeLast()
            totalSum -= lastValue
            previousValues[name] = lastValue
        }
    }
    
    @objc private func clearNameButtonTapped() {
        nameField.text = ""
    }
    
    @objc private func predefinedButtonTapped(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else {
            return
        }
        
        guard let numberText = sender.titleLabel?.text, let number = Int(numberText) else {
            return
        }
        
        if !invoiceData.keys.contains(name) {
            invoiceData[name] = []
        }
        
        invoiceData[name]?.append(number)
        totalSum += number
        previousValues[name] = number
        
        let quantity = invoiceData[name]?.count ?? 0
        outputArea.text += "\(name) (Quantity: \(quantity)): \(number)\n"
    }
    
    @objc private func calculateButtonTapped() {
        outputArea.text = ""
        
        for (name, numbers) in invoiceData {
            var sum = 0
            let quantity = numbers.count
            
            for number in numbers {
                sum += number
            }
            
            outputArea.text += "\(name) (Quantity: \(quantity)): \(numbers) = \(sum)\n"
        }
        
        outputArea.text += "\nTotal sum: \(totalSum)"
    }
    
    @objc private func invoiceButtonTapped() {
        let invoiceText = generateInvoiceText()
        
        let invoiceDialog = InvoiceDialog(invoiceText: invoiceText)
        invoiceDialog.modalPresentationStyle = .formSheet
        present(invoiceDialog, animated: true, completion: nil)
    }
    
    @objc private func printButtonTapped() {
        let invoiceText = generateInvoiceText()
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = "Invoice"
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = false
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: invoiceText)
        printController.printFormatter = printFormatter
        
        printController.present(animated: true, completionHandler: nil)
    }
    
    @objc private func saveButtonTapped() {
        let invoiceText = generateInvoiceText()
        saveInvoiceData(invoiceText)
    }
    
    private func generateInvoiceText() -> String {
        var invoiceText = "Love What to Wear PH\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        invoiceText += "Date: \(dateFormatter.string(from: Date()))\n\n"
        
        for (name, numbers) in invoiceData {
            var sum = 0
            let quantity = numbers.count
            
            for number in numbers {
                sum += number
            }
            
            invoiceText += "\(name) (Quantity: \(quantity)): \(numbers) = \(sum)\n"
        }
        
        invoiceText += "\nTotal sum: \(totalSum)"
        return invoiceText
    }
    
    private func saveInvoiceData(_ invoiceText: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let fileName = "Invoice_" + dateFormatter.string(from: Date()) + ".txt"
        
        guard let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else {
            return
        }
        
        do {
            try invoiceText.write(to: filePath, atomically: true, encoding: .utf8)
            let alert = UIAlertController(title: "Success", message: "Invoice data saved successfully as \(fileName)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Error", message: "Failed to save invoice data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func invoiceDatasButtonTapped() {
        let invoiceDatasVC = InvoiceDatasViewController(invoiceDatas: invoiceData)
        navigationController?.pushViewController(invoiceDatasVC, animated: true)
    }
}

class InvoiceDialog: UIViewController {
    private let invoiceText: String
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(invoiceText: String) {
        self.invoiceText = invoiceText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        textView.text = invoiceText
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(textView)
        view.addSubview(closeButton)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

class InvoiceDatasViewController: UIViewController {
    private let invoiceDatas: [String: [Int]]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    init(invoiceDatas: [String: [Int]]) {
        self.invoiceDatas = invoiceDatas
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension InvoiceDatasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let names = Array(invoiceDatas.keys)
        let name = names[indexPath.row]
        let numbers = invoiceDatas[name]
        let quantity = numbers?.count ?? 0
        let totalSum = numbers?.reduce(0, +) ?? 0
        
        cell.textLabel?.text = "\(name) (Quantity: \(quantity)), Total Sum: \(totalSum)"
        
        return cell
    }
}
