//
//  ChartCandle.swift
//  My Portfolio
//
//  Created by Илья Андреев on 28.02.2022.
//

import Foundation

struct ChartCandle: Codable {
    let date: String
    let label: String
    let close: Double
    let high: Double
    let low: Double
    let open: Double
}
