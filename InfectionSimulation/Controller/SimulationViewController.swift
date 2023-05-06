//
//  ViewController.swift
//  InfectionSimulation
//
//  Created by Данил Терлецкий on 06.05.2023.
//

import UIKit

class SimulationViewController: UIViewController {

    // MARK: -- Variables

    var groupSize: Int = 100
    var t: Int = 3
    var infectionFactor: Int = 3

    var infectedCount: Int = 0
    var healthyCount: Int = 0

    var items: [Item] = []
    var selectedIndexPaths: [IndexPath] = []

    // MARK: -- Layout

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 40)
        return collectionView
    }()


    // MARK: -- LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.setupInitialItems()
        self.updateNeighborItems()
        self.setupPinchGestureRecognizer()

        // Пересчёт в фоновом потоке
        DispatchQueue.global(qos: .background).async {
            self.recalculateItems()
        }
    }

    // MARK: -- Setup Methods

    private func setup() {
        title = "Infection Simulation"
        view.addSubview(collectionView)

        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 20, bottom: 10, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InfectedCollectionViewCell.self, forCellWithReuseIdentifier: "InfectedCell")
        collectionView.register(HealthyCollectionViewCell.self, forCellWithReuseIdentifier: "HealthyCell")
        collectionView.register(StatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StatusHeaderView")

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupPinchGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))

        view.addGestureRecognizer(pinchGesture)
    }

    func setupInitialItems() {
        for _ in 0..<groupSize {
            let item = Item(
                isInfected: false,
                infectionProbability: 0.5
            )
            items.append(item)
        }
    }

    // MARK: -- Main functionality

    func recalculateItems() {
        self.updateNeighborItems()

        for indexPath in selectedIndexPaths {
            let item = items[indexPath.item]

            var localInfectionFactor = 0

            for neighborItem in item.neighborItems {
                if localInfectionFactor < infectionFactor && !neighborItem.isInfected && Float.random(in: 0..<1) <= neighborItem.infectionProbability {
                    neighborItem.isInfected = true

                    localInfectionFactor += 1

                    DispatchQueue.main.async {
                        if let index = self.items.firstIndex(of: neighborItem) {
                            let indexPath = IndexPath(item: index, section: 0)
                            _ = self.collectionView.cellForItem(at: indexPath) as? HealthyCollectionViewCell
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }

        infectedCount = items.filter { $0.isInfected }.count
        healthyCount = items.filter { !$0.isInfected }.count

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(t)) {
            self.collectionView.reloadData()
            self.recalculateItems()
        }
    }

    func updateNeighborItems() {
        for i in 0..<items.count {
            var neighbors: [Item] = []

            let x = i % 10
            let y = i / 10

            for dx in -1...1 {
                for dy in -1...1 {
                    let nx = x + dx
                    let ny = y + dy
                    guard
                        nx >= 0,
                        nx < 10,
                        ny >= 0,
                        ny < 10,
                        !(dx == 0 && dy == 0)
                    else { continue }

                    let nIndex = ny * 10 + nx
                    neighbors.append(items[nIndex])
                }
            }
            items[i].neighborItems = neighbors
        }
    }

// MARK: -- @objc handlers

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseOut]
            ) {
                self.view.transform = CGAffineTransform.identity
            }
        } else {
            let scale = gestureRecognizer.scale
            let minScale: CGFloat = 1.0

            if scale < minScale {
                self.view.transform = CGAffineTransform(scaleX: minScale, y: minScale)
            }
            else {
                self.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
}
