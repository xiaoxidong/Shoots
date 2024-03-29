//
//  SKProductDiscount+LocalizedPrice.swift
//  SwiftyStoreKit
//
//  Created by Sam Spencer on 5/29/20.
//  Copyright © 2020 Sam Spencer. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import StoreKit

@available(iOSApplicationExtension 11.2, iOS 11.2, OSX 10.13.2, tvOS 11.2, watchOS 4.2, macCatalyst 13.0, *)
public extension SKProductDiscount {
    /// The formatted discount price of the product using the local currency.
    var localizedPrice: String? {
        return priceFormatter(locale: priceLocale).string(from: price)
    }

    private func priceFormatter(locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter
    }

    /// The formatted, localized period / date for the product discount.
    /// - note: The subscription period for the discount is independent of the product's regular subscription period, and does not have to match in units or duration.
    var localizedSubscriptionPeriod: String {
        let dateComponents: DateComponents

        switch subscriptionPeriod.unit {
        case .day: dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits)
        case .week: dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits)
        case .month: dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
        case .year: dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits)
        @unknown default:
            print("WARNING: SwiftyStoreKit localizedSubscriptionPeriod does not handle all SKProduct.PeriodUnit cases.")
            // Default to month units in the unlikely event a different unit type is added to a future OS version
            dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
        }

        return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full) ?? ""
    }
}
