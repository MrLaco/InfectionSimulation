//
//  Item.swift
//  InfectionSimulation
//
//  Created by Данил Терлецкий on 06.05.2023.
//

import Foundation


class Item: Equatable {
    var isInfected: Bool
    var infectionProbability: Float
    var neighborItems: [Item]

    init(isInfected: Bool, infectionProbability: Float) {
        self.isInfected = isInfected
        self.infectionProbability = infectionProbability
        self.neighborItems = .init()
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.isInfected == rhs.isInfected && lhs.infectionProbability == rhs.infectionProbability
    }
}
