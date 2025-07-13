//
//  CurrencyConverter.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import Foundation

protocol CurrencyConverterProtocol {
    func convert(amount: Double, from fromCurrency: String, to toCurrency: String) -> Double?
}

final class CurrencyConverter: CurrencyConverterProtocol {
    
    private var ratesGraph: [String: [RateModel]] = [:]

    init(rates: [RateModel]) {
        buildGraph(from: rates)
    }
    
    func convert(amount: Double, from fromCurrency: String, to toCurrency: String) -> Double? {
        if fromCurrency == toCurrency {
            return amount
        }
        
        guard let conversionRate = findConversionRate(from: fromCurrency, to: toCurrency) else {
            return nil
        }
        
        return amount * conversionRate
    }
    
    private func buildGraph(from rates: [RateModel]) {
        var graph = [String: [RateModel]]()
        
        for rate in rates {
            guard rate.rate > 0 else {
                continue
            }
            
            graph[rate.from, default: []].append(rate)
            let inverseRate = RateModel(from: rate.to, to: rate.from, rate: 1.0 / rate.rate)
            graph[rate.to, default: []].append(inverseRate)
        }
        
        self.ratesGraph = graph
    }

    private func findConversionRate(from startCurrency: String, to endCurrency: String) -> Double? {
        guard ratesGraph[startCurrency] != nil else { return nil }
        
        var queue: [(currency: String, rate: Double)] = [(startCurrency, 1.0)]
        var visited: Set<String> = [startCurrency]
        
        var head = 0
        while head < queue.count {
            let (currentCurrency, currentRate) = queue[head]
            head += 1
            
            if currentCurrency == endCurrency {
                return currentRate
            }
            
            guard let neighbors = ratesGraph[currentCurrency] else { continue }
            
            for rate in neighbors {
                if !visited.contains(rate.to) {
                    visited.insert(rate.to)
                    let newRate = currentRate * rate.rate
                    queue.append((currency: rate.to, rate: newRate))
                }
            }
        }
        
        return nil
    }
}
