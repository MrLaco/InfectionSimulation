//
//  StatusHeaderView.swift
//  InfectionSimulation
//
//  Created by Данил Терлецкий on 06.05.2023.
//

import UIKit

class StatusHeaderView: UICollectionReusableView {

    let healthyLabel = UILabel()
    let infectedLabel = UILabel()

    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHealthy(healthyCount: Int) {
        healthyLabel.text = "Healthy: \(healthyCount)"
    }

    func setInfected(infectedCount: Int) {
        infectedLabel.text = "Infected: \(infectedCount)"
    }

    private func setup() {
        healthyLabel.textColor = .black
        healthyLabel.font = .boldSystemFont(ofSize: 20)

        infectedLabel.textColor = .black
        infectedLabel.font = .boldSystemFont(ofSize: 20)

        stackView.addArrangedSubview(healthyLabel)
        stackView.addArrangedSubview(infectedLabel)

        addSubview(healthyLabel)
        addSubview(infectedLabel)
        addSubview(stackView)

        stackView.axis = .horizontal
    }

    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        healthyLabel.translatesAutoresizingMaskIntoConstraints = false
        infectedLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            healthyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 30),
            infectedLabel.leadingAnchor.constraint(equalTo: healthyLabel.trailingAnchor, constant: 10),
            infectedLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30),
        ])
    }
}
