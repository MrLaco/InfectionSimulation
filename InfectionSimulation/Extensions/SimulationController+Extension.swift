//
//  SimulationController+Extension.swift
//  InfectionSimulation
//
//  Created by Данил Терлецкий on 06.05.2023.
//

import UIKit

// MARK: -- UICollectionViewDataSource

extension SimulationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard
                let statusHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StatusHeaderView", for: indexPath) as? StatusHeaderView
            else { return UICollectionReusableView() }

            statusHeaderView.setHealthy(healthyCount: healthyCount)
            statusHeaderView.setInfected(infectedCount: infectedCount)

            return statusHeaderView
        }

        return UICollectionReusableView()
    }
}

// MARK: -- UICollectionViewDelegate

extension SimulationViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        if item.isInfected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfectedCell", for: indexPath) as! InfectedCollectionViewCell
            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthyCell", for: indexPath) as! HealthyCollectionViewCell
            cell.configure(with: item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]

        if !item.isInfected {
            item.isInfected = true
            selectedIndexPaths.append(indexPath)

            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let scaleFactor: CGFloat = 1.2
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }

    func getInfectedIndexPaths(for indexPath: IndexPath) -> [IndexPath] {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfItemsPerRow = Int(collectionView.frame.width / layout.itemSize.width)
        var infectedIndexPaths = [IndexPath]()
        let indexesToCheck = [indexPath.item - 1, indexPath.item + 1, indexPath.item - numberOfItemsPerRow, indexPath.item + numberOfItemsPerRow]
        for index in indexesToCheck {
            if index >= 0 && index < items.count {
                infectedIndexPaths.append(IndexPath(item: index, section: 0))
            }
        }
        return infectedIndexPaths
    }
}
