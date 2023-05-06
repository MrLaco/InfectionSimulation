//
//  GreetingController.swift
//  InfectionSimulation
//
//  Created by Данил Терлецкий on 06.05.2023.
//

import UIKit

class GreetingViewController: UIViewController {

    // MARK: -- Layout

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Infection Simulator"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()

    let groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter group size..."
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    let infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter infection factor..."
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    let recalculatePeriodTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter recalculate period..."
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    let startSimulatorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start simulator", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSimulate), for: .touchUpInside)
        return button
    }()

    // MARK: -- LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        groupSizeTextField.becomeFirstResponder()
    }

    // MARK: -- Setup Methods

    func setup() {
        view.addSubview(titleLabel)
        view.addSubview(groupSizeTextField)
        view.addSubview(infectionFactorTextField)
        view.addSubview(recalculatePeriodTextField)
        view.addSubview(startSimulatorButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            groupSizeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupSizeTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            groupSizeTextField.widthAnchor.constraint(equalToConstant: 280),

            infectionFactorTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionFactorTextField.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 10),
            infectionFactorTextField.widthAnchor.constraint(equalToConstant: 280),

            recalculatePeriodTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recalculatePeriodTextField.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 10),
            recalculatePeriodTextField.widthAnchor.constraint(equalToConstant: 280),

            startSimulatorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSimulatorButton.topAnchor.constraint(equalTo: recalculatePeriodTextField.bottomAnchor, constant: 20),
            startSimulatorButton.widthAnchor.constraint(equalToConstant: 280),
            startSimulatorButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }


    // MARK: -- @obc handlers
    
    @objc func didTapSimulate() {
        let alert = UIAlertController(title: nil, message: "Are you sure all provided data is correct?", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                guard
                    let self,
                    let groupSizeText = groupSizeTextField.text,
                    let infectionFactorText = infectionFactorTextField.text,
                    let tText = recalculatePeriodTextField.text,
                    let groupSize = Int(groupSizeText),
                    let infectionFactor = Int(infectionFactorText),
                    let t = Int(tText)
                else { return }

                var simulationVC = SimulationViewController()
                simulationVC.groupSize = Int(groupSize)
                simulationVC.infectionFactor = Int(infectionFactor)
                simulationVC.t = t

                navigationController?.pushViewController(simulationVC, animated: true)
            }
        )
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension GreetingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupSizeTextField.resignFirstResponder()
    }
}
