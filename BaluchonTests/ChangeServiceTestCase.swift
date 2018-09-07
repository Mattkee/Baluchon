//
//  ChangeServiceTestCase.swift
//  BaluchonTests
//
//  Created by Lei et Matthieu on 24/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import XCTest
@testable import Baluchon

class ChangeServiceTestCase: XCTestCase {
    
    func testGetChangeShouldPostFailedCallbackIfError() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil, response: nil, error: FakeChangeResponseData.error),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfNoData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil, response: nil, error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(change)
            XCTAssertNil(money)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeCorrectData,
                response: FakeChangeResponseData.responseKO,
                error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetChangeShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeIncorrectData,
                response: FakeChangeResponseData.responseOK,
                error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(change)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPosterrorCallbackIfNoErrorAndCorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeCorrectData,
                response: FakeChangeResponseData.responseOK,
                error: nil),
            moneySession: URLSessionFake(
                data: FakeMoneyResponseData.moneyCorrectData,
                response: FakeMoneyResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(change)
            XCTAssertNotNil(money)

            let base = "EUR"
            let rates = ["AED": 4.249966,
                         "AFN": 84.979225,
                         "ALL": 125.955356,
                         "AMD": 561.37486,
                         "ANG": 2.14334,
                         "AOA": 311.239421,
                         "ARS": 35.250799,
                         "AUD": 1.590019,
                         "AWG": 2.074089,
                         "AZN": 1.969953,
                         "BAM": 1.960636,
                         "BBD": 2.325293,
                         "BDT": 97.360678,
                         "BGN": 1.956622,
                         "BHD": 0.436454,
                         "BIF": 2055.517307,
                         "BMD": 1.157093,
                         "BND": 1.591116,
                         "BOB": 8.02762,
                         "BRL": 4.762366,
                         "BSD": 1.161756,
                         "BTC": 0.000178,
                         "BTN": 81.146008,
                         "BWP": 12.332266,
                         "BYN": 2.373949,
                         "BYR": 22679.016703,
                         "BZD": 2.335029,
                         "CAD": 1.514021,
                         "CDF": 1868.704834,
                         "CHF": 1.139927,
                         "CLF": 0.026155,
                         "CLP": 775.02111,
                         "CNY": 7.968433,
                         "COP": 3439.805146,
                         "CRC": 660.051624,
                         "CUC": 1.157093,
                         "CUP": 30.662956,
                         "CVE": 110.548516,
                         "CZK": 25.720092,
                         "DJF": 205.638516,
                         "DKK": 7.458585,
                         "DOP": 58.057125,
                         "DZD": 136.837598,
                         "EGP": 20.667414,
                         "ERN": 17.356387,
                         "ETB": 32.058992,
                         "EUR": 1,
                         "FJD": 2.445805,
                         "FKP": 0.902521,
                         "GBP": 0.902214,
                         "GEL": 2.985218,
                         "GGP": 0.902374,
                         "GHS": 5.599692,
                         "GIP": 0.902521,
                         "GMD": 55.517553,
                         "GNF": 10507.616765,
                         "GTQ": 8.723281,
                         "GYD": 242.005574,
                         "HKD": 9.083235,
                         "HNL": 27.838475,
                         "HRK": 7.436655,
                         "HTG": 80.583381,
                         "HUF": 324.094702,
                         "IDR": 16936.249978,
                         "ILS": 4.214027,
                         "IMP": 0.902374,
                         "INR": 81.141088,
                         "IQD": 1386.197041,
                         "IRR": 48719.387968,
                         "ISK": 124.98933,
                         "JEP": 0.902374,
                         "JMD": 159.094488,
                         "JOD": 0.820956,
                         "JPY": 128.867736,
                         "KES": 116.507544,
                         "KGS": 79.637023,
                         "KHR": 4733.955726,
                         "KMF": 494.021288,
                         "KPW": 1041.419456,
                         "KRW": 1295.064268,
                         "KWD": 0.350772,
                         "KYD": 0.96818,
                         "KZT": 419.527016,
                         "LAK": 9895.457144,
                         "LBP": 1757.566436,
                         "LKR": 186.691091,
                         "LRD": 178.481293,
                         "LSL": 16.702588,
                         "LTL": 3.527633,
                         "LVL": 0.718034,
                         "LYD": 1.618423,
                         "MAD": 10.9491,
                         "MDL": 19.411968,
                         "MGA": 3848.118886,
                         "MKD": 61.597861,
                         "MMK": 1768.730225,
                         "MNT": 2853.918529,
                         "MOP": 9.39299,
                         "MRO": 412.570871,
                         "MUR": 39.633929,
                         "MVR": 17.877135,
                         "MWK": 843.584181,
                         "MXN": 21.982736,
                         "MYR": 4.75507,
                         "MZN": 68.575072,
                         "NAD": 16.702627,
                         "NGN": 421.112245,
                         "NIO": 37.076146,
                         "NOK": 9.678328,
                         "NPR": 130.300421,
                         "NZD": 1.740354,
                         "OMR": 0.445452,
                         "PAB": 1.161773,
                         "PEN": 3.81632,
                         "PGK": 3.849066,
                         "PHP": 61.866267,
                         "PKR": 142.217851,
                         "PLN": 4.283615,
                         "PYG": 6730.28764,
                         "QAR": 4.212945,
                         "RON": 4.635662,
                         "RSD": 118.046243,
                         "RUB": 78.819763,
                         "RWF": 1022.106256,
                         "SAR": 4.340833,
                         "SBD": 9.197787,
                         "SCR": 15.724308,
                         "SDG": 20.987316,
                         "SEK": 10.55235,
                         "SGD": 1.587311,
                         "SHP": 1.528405,
                         "SLL": 10066.706993,
                         "SOS": 669.379046,
                         "SRD": 8.629596,
                         "STD": 24467.969439,
                         "SVC": 10.165002,
                         "SYP": 595.902899,
                         "SZL": 16.52675,
                         "THB": 37.929376,
                         "TJS": 10.948874,
                         "TMT": 4.061395,
                         "TND": 3.185823,
                         "TOP": 2.633083,
                         "TRY": 7.047158,
                         "TTD": 7.829988,
                         "TWD": 35.609561,
                         "TZS": 2646.507216,
                         "UAH": 32.356363,
                         "UGX": 4354.373643,
                         "USD": 1.157093,
                         "UYU": 36.997464,
                         "UZS": 9065.710597,
                         "VEF": 11.556462,
                         "VND": 27046.405202,
                         "VUV": 131.120287,
                         "WST": 3.020882,
                         "XAF": 657.578163,
                         "XAG": 0.07937,
                         "XAU": 0.000974,
                         "XCD": 3.127101,
                         "XDR": 0.82943,
                         "XOF": 657.564375,
                         "XPF": 119.55084,
                         "YER": 289.678378,
                         "ZAR": 16.593056,
                         "ZMK": 10415.22346,
                         "ZMW": 11.732747,
                         "ZWL": 372.994626]
            let symbols = ["AED": "United Arab Emirates Dirham",
                           "AFN": "Afghan Afghani",
                           "ALL": "Albanian Lek",
                           "AMD": "Armenian Dram",
                           "ANG": "Netherlands Antillean Guilder",
                           "AOA": "Angolan Kwanza",
                           "ARS": "Argentine Peso",
                           "AUD": "Australian Dollar",
                           "AWG": "Aruban Florin",
                           "AZN": "Azerbaijani Manat",
                           "BAM": "Bosnia-Herzegovina Convertible Mark",
                           "BBD": "Barbadian Dollar",
                           "BDT": "Bangladeshi Taka",
                           "BGN": "Bulgarian Lev",
                           "BHD": "Bahraini Dinar",
                           "BIF": "Burundian Franc",
                           "BMD": "Bermudan Dollar",
                           "BND": "Brunei Dollar",
                           "BOB": "Bolivian Boliviano",
                           "BRL": "Brazilian Real",
                           "BSD": "Bahamian Dollar",
                           "BTC": "Bitcoin",
                           "BTN": "Bhutanese Ngultrum",
                           "BWP": "Botswanan Pula",
                           "BYN": "New Belarusian Ruble",
                           "BYR": "Belarusian Ruble",
                           "BZD": "Belize Dollar",
                           "CAD": "Canadian Dollar",
                           "CDF": "Congolese Franc",
                           "CHF": "Swiss Franc",
                           "CLF": "Chilean Unit of Account (UF)",
                           "CLP": "Chilean Peso",
                           "CNY": "Chinese Yuan",
                           "COP": "Colombian Peso",
                           "CRC": "Costa Rican Colón",
                           "CUC": "Cuban Convertible Peso",
                           "CUP": "Cuban Peso",
                           "CVE": "Cape Verdean Escudo",
                           "CZK": "Czech Republic Koruna",
                           "DJF": "Djiboutian Franc",
                           "DKK": "Danish Krone",
                           "DOP": "Dominican Peso",
                           "DZD": "Algerian Dinar",
                           "EGP": "Egyptian Pound",
                           "ERN": "Eritrean Nakfa",
                           "ETB": "Ethiopian Birr",
                           "EUR": "Euro",
                           "FJD": "Fijian Dollar",
                           "FKP": "Falkland Islands Pound",
                           "GBP": "British Pound Sterling",
                           "GEL": "Georgian Lari",
                           "GGP": "Guernsey Pound",
                           "GHS": "Ghanaian Cedi",
                           "GIP": "Gibraltar Pound",
                           "GMD": "Gambian Dalasi",
                           "GNF": "Guinean Franc",
                           "GTQ": "Guatemalan Quetzal",
                           "GYD": "Guyanaese Dollar",
                           "HKD": "Hong Kong Dollar",
                           "HNL": "Honduran Lempira",
                           "HRK": "Croatian Kuna",
                           "HTG": "Haitian Gourde",
                           "HUF": "Hungarian Forint",
                           "IDR": "Indonesian Rupiah",
                           "ILS": "Israeli New Sheqel",
                           "IMP": "Manx pound",
                           "INR": "Indian Rupee",
                           "IQD": "Iraqi Dinar",
                           "IRR": "Iranian Rial",
                           "ISK": "Icelandic Króna",
                           "JEP": "Jersey Pound",
                           "JMD": "Jamaican Dollar",
                           "JOD": "Jordanian Dinar",
                           "JPY": "Japanese Yen",
                           "KES": "Kenyan Shilling",
                           "KGS": "Kyrgystani Som",
                           "KHR": "Cambodian Riel",
                           "KMF": "Comorian Franc",
                           "KPW": "North Korean Won",
                           "KRW": "South Korean Won",
                           "KWD": "Kuwaiti Dinar",
                           "KYD": "Cayman Islands Dollar",
                           "KZT": "Kazakhstani Tenge",
                           "LAK": "Laotian Kip",
                           "LBP": "Lebanese Pound",
                           "LKR": "Sri Lankan Rupee",
                           "LRD": "Liberian Dollar",
                           "LSL": "Lesotho Loti",
                           "LTL": "Lithuanian Litas",
                           "LVL": "Latvian Lats",
                           "LYD": "Libyan Dinar",
                           "MAD": "Moroccan Dirham",
                           "MDL": "Moldovan Leu",
                           "MGA": "Malagasy Ariary",
                           "MKD": "Macedonian Denar",
                           "MMK": "Myanma Kyat",
                           "MNT": "Mongolian Tugrik",
                           "MOP": "Macanese Pataca",
                           "MRO": "Mauritanian Ouguiya",
                           "MUR": "Mauritian Rupee",
                           "MVR": "Maldivian Rufiyaa",
                           "MWK": "Malawian Kwacha",
                           "MXN": "Mexican Peso",
                           "MYR": "Malaysian Ringgit",
                           "MZN": "Mozambican Metical",
                           "NAD": "Namibian Dollar",
                           "NGN": "Nigerian Naira",
                           "NIO": "Nicaraguan Córdoba",
                           "NOK": "Norwegian Krone",
                           "NPR": "Nepalese Rupee",
                           "NZD": "New Zealand Dollar",
                           "OMR": "Omani Rial",
                           "PAB": "Panamanian Balboa",
                           "PEN": "Peruvian Nuevo Sol",
                           "PGK": "Papua New Guinean Kina",
                           "PHP": "Philippine Peso",
                           "PKR": "Pakistani Rupee",
                           "PLN": "Polish Zloty",
                           "PYG": "Paraguayan Guarani",
                           "QAR": "Qatari Rial",
                           "RON": "Romanian Leu",
                           "RSD": "Serbian Dinar",
                           "RUB": "Russian Ruble",
                           "RWF": "Rwandan Franc",
                           "SAR": "Saudi Riyal",
                           "SBD": "Solomon Islands Dollar",
                           "SCR": "Seychellois Rupee",
                           "SDG": "Sudanese Pound",
                           "SEK": "Swedish Krona",
                           "SGD": "Singapore Dollar",
                           "SHP": "Saint Helena Pound",
                           "SLL": "Sierra Leonean Leone",
                           "SOS": "Somali Shilling",
                           "SRD": "Surinamese Dollar",
                           "STD": "São Tomé and Príncipe Dobra",
                           "SVC": "Salvadoran Colón",
                           "SYP": "Syrian Pound",
                           "SZL": "Swazi Lilangeni",
                           "THB": "Thai Baht",
                           "TJS": "Tajikistani Somoni",
                           "TMT": "Turkmenistani Manat",
                           "TND": "Tunisian Dinar",
                           "TOP": "Tongan Paʻanga",
                           "TRY": "Turkish Lira",
                           "TTD": "Trinidad and Tobago Dollar",
                           "TWD": "New Taiwan Dollar",
                           "TZS": "Tanzanian Shilling",
                           "UAH": "Ukrainian Hryvnia",
                           "UGX": "Ugandan Shilling",
                           "USD": "United States Dollar",
                           "UYU": "Uruguayan Peso",
                           "UZS": "Uzbekistan Som",
                           "VEF": "Venezuelan Bolívar Fuerte",
                           "VND": "Vietnamese Dong",
                           "VUV": "Vanuatu Vatu",
                           "WST": "Samoan Tala",
                           "XAF": "CFA Franc BEAC",
                           "XAG": "Silver (troy ounce)",
                           "XAU": "Gold (troy ounce)",
                           "XCD": "East Caribbean Dollar",
                           "XDR": "Special Drawing Rights",
                           "XOF": "CFA Franc BCEAO",
                           "XPF": "CFP Franc",
                           "YER": "Yemeni Rial",
                           "ZAR": "South African Rand",
                           "ZMK": "Zambian Kwacha (pre-2013)",
                           "ZMW": "Zambian Kwacha",
                           "ZWL": "Zimbabwean Dollar"]

            XCTAssertEqual(base, change!.base)
            XCTAssertEqual(rates, change!.rates)
            XCTAssertEqual(symbols, money!.symbols)
            expectation.fulfill()
        }
    }

    func testGetMoneyShouldPostFailedCallbackIfError() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: FakeChangeResponseData.changeCorrectData, response: FakeChangeResponseData.responseOK, error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: FakeMoneyResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(money)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetMoneyShouldPostFailedCallbackIfNoData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: FakeChangeResponseData.changeCorrectData, response: nil, error: nil),
            moneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(money)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetMoneyShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeCorrectData,
                response: FakeChangeResponseData.responseOK,
                error: nil),
            moneySession: URLSessionFake(data: FakeMoneyResponseData.moneyCorrectData, response: FakeMoneyResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(money)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetMoneyShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeChangeResponseData.changeCorrectData,
                response: FakeChangeResponseData.responseOK,
                error: nil),
            moneySession: URLSessionFake(data: FakeMoneyResponseData.moneyIncorrectData, response: FakeMoneyResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getChange { (error, change, money) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(money)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testChangeNeedIsTwoAndNumberNeedToConvertIsTwoAndMoneySelectedValueForOneEuroIsOneWhenCalculateThenResultIsFour() {
        let changeService = ChangeService()

        let result = changeService.changeMoney(changeNeed: 2.0, numberNeedToConvert: "2", moneySelectedValueForOneEuro: 1.0)

        XCTAssertEqual(result, 4.0)
    }
    func testChangeNeedIsTwoAndNumberNeedToConvertIsTwoPointAndMoneySelectedValueForOneEuroIsOneWhenCalculateThenResultIsFour() {
        let changeService = ChangeService()
        
        let result = changeService.changeMoney(changeNeed: 2.0, numberNeedToConvert: "2.", moneySelectedValueForOneEuro: 1.0)
        
        XCTAssertEqual(result, 4.0)
    }
    func testChangeNeedIsTwoAndNumberNeedToConvertIsNilAndMoneySelectedValueForOneEuroIsOneWhenCalculateThenResultIsFour() {
        let changeService = ChangeService()
        
        let result = changeService.changeMoney(changeNeed: 2.0, numberNeedToConvert: "", moneySelectedValueForOneEuro: 1.0)
        
        XCTAssertEqual(result, 0)
    }
    func testChangeNeedIsTwoAndNumberNeedToConvertIsTwoAndMoneySelectedValueForOneEuroIsTwoWhenCalculateThenResultIsFour() {
        let changeService = ChangeService()
        
        let result = changeService.changeMoney(changeNeed: 2.0, numberNeedToConvert: "2", moneySelectedValueForOneEuro: 2)
        
        XCTAssertEqual(result, 2)
    }
    func testSearchMoneyAbreviationForEuroWhenSearchThenResultIsEUR() {
        let changeService = ChangeService()
        let moneys = Money(symbols: ["AED": "United Arab Emirates Dirham",
                                    "AFN": "Afghan Afghani",
                                    "ALL": "Albanian Lek",
                                    "AMD": "Armenian Dram",
                                    "ANG": "Netherlands Antillean Guilder",
                                    "AOA": "Angolan Kwanza",
                                    "ARS": "Argentine Peso",
                                    "AUD": "Australian Dollar",
                                    "AWG": "Aruban Florin",
                                    "AZN": "Azerbaijani Manat",
                                    "BAM": "Bosnia-Herzegovina Convertible Mark",
                                    "BBD": "Barbadian Dollar",
                                    "BDT": "Bangladeshi Taka",
                                    "BGN": "Bulgarian Lev",
                                    "BHD": "Bahraini Dinar",
                                    "BIF": "Burundian Franc",
                                    "BMD": "Bermudan Dollar",
                                    "BND": "Brunei Dollar",
                                    "BOB": "Bolivian Boliviano",
                                    "BRL": "Brazilian Real",
                                    "BSD": "Bahamian Dollar",
                                    "BTC": "Bitcoin",
                                    "BTN": "Bhutanese Ngultrum",
                                    "BWP": "Botswanan Pula",
                                    "BYN": "New Belarusian Ruble",
                                    "BYR": "Belarusian Ruble",
                                    "BZD": "Belize Dollar",
                                    "CAD": "Canadian Dollar",
                                    "CDF": "Congolese Franc",
                                    "CHF": "Swiss Franc",
                                    "CLF": "Chilean Unit of Account (UF)",
                                    "CLP": "Chilean Peso",
                                    "CNY": "Chinese Yuan",
                                    "COP": "Colombian Peso",
                                    "CRC": "Costa Rican Colón",
                                    "CUC": "Cuban Convertible Peso",
                                    "CUP": "Cuban Peso",
                                    "CVE": "Cape Verdean Escudo",
                                    "CZK": "Czech Republic Koruna",
                                    "DJF": "Djiboutian Franc",
                                    "DKK": "Danish Krone",
                                    "DOP": "Dominican Peso",
                                    "DZD": "Algerian Dinar",
                                    "EGP": "Egyptian Pound",
                                    "ERN": "Eritrean Nakfa",
                                    "ETB": "Ethiopian Birr",
                                    "EUR": "Euro",
                                    "FJD": "Fijian Dollar",
                                    "FKP": "Falkland Islands Pound",
                                    "GBP": "British Pound Sterling",
                                    "GEL": "Georgian Lari",
                                    "GGP": "Guernsey Pound",
                                    "GHS": "Ghanaian Cedi",
                                    "GIP": "Gibraltar Pound",
                                    "GMD": "Gambian Dalasi",
                                    "GNF": "Guinean Franc",
                                    "GTQ": "Guatemalan Quetzal",
                                    "GYD": "Guyanaese Dollar",
                                    "HKD": "Hong Kong Dollar",
                                    "HNL": "Honduran Lempira",
                                    "HRK": "Croatian Kuna",
                                    "HTG": "Haitian Gourde",
                                    "HUF": "Hungarian Forint",
                                    "IDR": "Indonesian Rupiah",
                                    "ILS": "Israeli New Sheqel",
                                    "IMP": "Manx pound",
                                    "INR": "Indian Rupee",
                                    "IQD": "Iraqi Dinar",
                                    "IRR": "Iranian Rial",
                                    "ISK": "Icelandic Króna",
                                    "JEP": "Jersey Pound",
                                    "JMD": "Jamaican Dollar",
                                    "JOD": "Jordanian Dinar",
                                    "JPY": "Japanese Yen",
                                    "KES": "Kenyan Shilling",
                                    "KGS": "Kyrgystani Som",
                                    "KHR": "Cambodian Riel",
                                    "KMF": "Comorian Franc",
                                    "KPW": "North Korean Won",
                                    "KRW": "South Korean Won",
                                    "KWD": "Kuwaiti Dinar",
                                    "KYD": "Cayman Islands Dollar",
                                    "KZT": "Kazakhstani Tenge",
                                    "LAK": "Laotian Kip",
                                    "LBP": "Lebanese Pound",
                                    "LKR": "Sri Lankan Rupee",
                                    "LRD": "Liberian Dollar",
                                    "LSL": "Lesotho Loti",
                                    "LTL": "Lithuanian Litas",
                                    "LVL": "Latvian Lats",
                                    "LYD": "Libyan Dinar",
                                    "MAD": "Moroccan Dirham",
                                    "MDL": "Moldovan Leu",
                                    "MGA": "Malagasy Ariary",
                                    "MKD": "Macedonian Denar",
                                    "MMK": "Myanma Kyat",
                                    "MNT": "Mongolian Tugrik",
                                    "MOP": "Macanese Pataca",
                                    "MRO": "Mauritanian Ouguiya",
                                    "MUR": "Mauritian Rupee",
                                    "MVR": "Maldivian Rufiyaa",
                                    "MWK": "Malawian Kwacha",
                                    "MXN": "Mexican Peso",
                                    "MYR": "Malaysian Ringgit",
                                    "MZN": "Mozambican Metical",
                                    "NAD": "Namibian Dollar",
                                    "NGN": "Nigerian Naira",
                                    "NIO": "Nicaraguan Córdoba",
                                    "NOK": "Norwegian Krone",
                                    "NPR": "Nepalese Rupee",
                                    "NZD": "New Zealand Dollar",
                                    "OMR": "Omani Rial",
                                    "PAB": "Panamanian Balboa",
                                    "PEN": "Peruvian Nuevo Sol",
                                    "PGK": "Papua New Guinean Kina",
                                    "PHP": "Philippine Peso",
                                    "PKR": "Pakistani Rupee",
                                    "PLN": "Polish Zloty",
                                    "PYG": "Paraguayan Guarani",
                                    "QAR": "Qatari Rial",
                                    "RON": "Romanian Leu",
                                    "RSD": "Serbian Dinar",
                                    "RUB": "Russian Ruble",
                                    "RWF": "Rwandan Franc",
                                    "SAR": "Saudi Riyal",
                                    "SBD": "Solomon Islands Dollar",
                                    "SCR": "Seychellois Rupee",
                                    "SDG": "Sudanese Pound",
                                    "SEK": "Swedish Krona",
                                    "SGD": "Singapore Dollar",
                                    "SHP": "Saint Helena Pound",
                                    "SLL": "Sierra Leonean Leone",
                                    "SOS": "Somali Shilling",
                                    "SRD": "Surinamese Dollar",
                                    "STD": "São Tomé and Príncipe Dobra",
                                    "SVC": "Salvadoran Colón",
                                    "SYP": "Syrian Pound",
                                    "SZL": "Swazi Lilangeni",
                                    "THB": "Thai Baht",
                                    "TJS": "Tajikistani Somoni",
                                    "TMT": "Turkmenistani Manat",
                                    "TND": "Tunisian Dinar",
                                    "TOP": "Tongan Paʻanga",
                                    "TRY": "Turkish Lira",
                                    "TTD": "Trinidad and Tobago Dollar",
                                    "TWD": "New Taiwan Dollar",
                                    "TZS": "Tanzanian Shilling",
                                    "UAH": "Ukrainian Hryvnia",
                                    "UGX": "Ugandan Shilling",
                                    "USD": "United States Dollar",
                                    "UYU": "Uruguayan Peso",
                                    "UZS": "Uzbekistan Som",
                                    "VEF": "Venezuelan Bolívar Fuerte",
                                    "VND": "Vietnamese Dong",
                                    "VUV": "Vanuatu Vatu",
                                    "WST": "Samoan Tala",
                                    "XAF": "CFA Franc BEAC",
                                    "XAG": "Silver (troy ounce)",
                                    "XAU": "Gold (troy ounce)",
                                    "XCD": "East Caribbean Dollar",
                                    "XDR": "Special Drawing Rights",
                                    "XOF": "CFA Franc BCEAO",
                                    "XPF": "CFP Franc",
                                    "YER": "Yemeni Rial",
                                    "ZAR": "South African Rand",
                                    "ZMK": "Zambian Kwacha (pre-2013)",
                                    "ZMW": "Zambian Kwacha",
                                    "ZWL": "Zimbabwean Dollar"])

        let result = changeService.searchMoney(moneyName: "Euro", moneyData: moneys)
        
        XCTAssertEqual(result, "EUR")
    }
    func testSearchMoneyAbreviationForNilWhenSearchThenResultIsNil() {
        let changeService = ChangeService()
        let moneys = Money(symbols: ["AED": "United Arab Emirates Dirham",
                                     "AFN": "Afghan Afghani",
                                     "ALL": "Albanian Lek",
                                     "AMD": "Armenian Dram",
                                     "ANG": "Netherlands Antillean Guilder",
                                     "AOA": "Angolan Kwanza",
                                     "ARS": "Argentine Peso",
                                     "AUD": "Australian Dollar",
                                     "AWG": "Aruban Florin",
                                     "AZN": "Azerbaijani Manat",
                                     "BAM": "Bosnia-Herzegovina Convertible Mark",
                                     "BBD": "Barbadian Dollar",
                                     "BDT": "Bangladeshi Taka",
                                     "BGN": "Bulgarian Lev",
                                     "BHD": "Bahraini Dinar",
                                     "BIF": "Burundian Franc",
                                     "BMD": "Bermudan Dollar",
                                     "BND": "Brunei Dollar",
                                     "BOB": "Bolivian Boliviano",
                                     "BRL": "Brazilian Real",
                                     "BSD": "Bahamian Dollar",
                                     "BTC": "Bitcoin",
                                     "BTN": "Bhutanese Ngultrum",
                                     "BWP": "Botswanan Pula",
                                     "BYN": "New Belarusian Ruble",
                                     "BYR": "Belarusian Ruble",
                                     "BZD": "Belize Dollar",
                                     "CAD": "Canadian Dollar",
                                     "CDF": "Congolese Franc",
                                     "CHF": "Swiss Franc",
                                     "CLF": "Chilean Unit of Account (UF)",
                                     "CLP": "Chilean Peso",
                                     "CNY": "Chinese Yuan",
                                     "COP": "Colombian Peso",
                                     "CRC": "Costa Rican Colón",
                                     "CUC": "Cuban Convertible Peso",
                                     "CUP": "Cuban Peso",
                                     "CVE": "Cape Verdean Escudo",
                                     "CZK": "Czech Republic Koruna",
                                     "DJF": "Djiboutian Franc",
                                     "DKK": "Danish Krone",
                                     "DOP": "Dominican Peso",
                                     "DZD": "Algerian Dinar",
                                     "EGP": "Egyptian Pound",
                                     "ERN": "Eritrean Nakfa",
                                     "ETB": "Ethiopian Birr",
                                     "EUR": "Euro",
                                     "FJD": "Fijian Dollar",
                                     "FKP": "Falkland Islands Pound",
                                     "GBP": "British Pound Sterling",
                                     "GEL": "Georgian Lari",
                                     "GGP": "Guernsey Pound",
                                     "GHS": "Ghanaian Cedi",
                                     "GIP": "Gibraltar Pound",
                                     "GMD": "Gambian Dalasi",
                                     "GNF": "Guinean Franc",
                                     "GTQ": "Guatemalan Quetzal",
                                     "GYD": "Guyanaese Dollar",
                                     "HKD": "Hong Kong Dollar",
                                     "HNL": "Honduran Lempira",
                                     "HRK": "Croatian Kuna",
                                     "HTG": "Haitian Gourde",
                                     "HUF": "Hungarian Forint",
                                     "IDR": "Indonesian Rupiah",
                                     "ILS": "Israeli New Sheqel",
                                     "IMP": "Manx pound",
                                     "INR": "Indian Rupee",
                                     "IQD": "Iraqi Dinar",
                                     "IRR": "Iranian Rial",
                                     "ISK": "Icelandic Króna",
                                     "JEP": "Jersey Pound",
                                     "JMD": "Jamaican Dollar",
                                     "JOD": "Jordanian Dinar",
                                     "JPY": "Japanese Yen",
                                     "KES": "Kenyan Shilling",
                                     "KGS": "Kyrgystani Som",
                                     "KHR": "Cambodian Riel",
                                     "KMF": "Comorian Franc",
                                     "KPW": "North Korean Won",
                                     "KRW": "South Korean Won",
                                     "KWD": "Kuwaiti Dinar",
                                     "KYD": "Cayman Islands Dollar",
                                     "KZT": "Kazakhstani Tenge",
                                     "LAK": "Laotian Kip",
                                     "LBP": "Lebanese Pound",
                                     "LKR": "Sri Lankan Rupee",
                                     "LRD": "Liberian Dollar",
                                     "LSL": "Lesotho Loti",
                                     "LTL": "Lithuanian Litas",
                                     "LVL": "Latvian Lats",
                                     "LYD": "Libyan Dinar",
                                     "MAD": "Moroccan Dirham",
                                     "MDL": "Moldovan Leu",
                                     "MGA": "Malagasy Ariary",
                                     "MKD": "Macedonian Denar",
                                     "MMK": "Myanma Kyat",
                                     "MNT": "Mongolian Tugrik",
                                     "MOP": "Macanese Pataca",
                                     "MRO": "Mauritanian Ouguiya",
                                     "MUR": "Mauritian Rupee",
                                     "MVR": "Maldivian Rufiyaa",
                                     "MWK": "Malawian Kwacha",
                                     "MXN": "Mexican Peso",
                                     "MYR": "Malaysian Ringgit",
                                     "MZN": "Mozambican Metical",
                                     "NAD": "Namibian Dollar",
                                     "NGN": "Nigerian Naira",
                                     "NIO": "Nicaraguan Córdoba",
                                     "NOK": "Norwegian Krone",
                                     "NPR": "Nepalese Rupee",
                                     "NZD": "New Zealand Dollar",
                                     "OMR": "Omani Rial",
                                     "PAB": "Panamanian Balboa",
                                     "PEN": "Peruvian Nuevo Sol",
                                     "PGK": "Papua New Guinean Kina",
                                     "PHP": "Philippine Peso",
                                     "PKR": "Pakistani Rupee",
                                     "PLN": "Polish Zloty",
                                     "PYG": "Paraguayan Guarani",
                                     "QAR": "Qatari Rial",
                                     "RON": "Romanian Leu",
                                     "RSD": "Serbian Dinar",
                                     "RUB": "Russian Ruble",
                                     "RWF": "Rwandan Franc",
                                     "SAR": "Saudi Riyal",
                                     "SBD": "Solomon Islands Dollar",
                                     "SCR": "Seychellois Rupee",
                                     "SDG": "Sudanese Pound",
                                     "SEK": "Swedish Krona",
                                     "SGD": "Singapore Dollar",
                                     "SHP": "Saint Helena Pound",
                                     "SLL": "Sierra Leonean Leone",
                                     "SOS": "Somali Shilling",
                                     "SRD": "Surinamese Dollar",
                                     "STD": "São Tomé and Príncipe Dobra",
                                     "SVC": "Salvadoran Colón",
                                     "SYP": "Syrian Pound",
                                     "SZL": "Swazi Lilangeni",
                                     "THB": "Thai Baht",
                                     "TJS": "Tajikistani Somoni",
                                     "TMT": "Turkmenistani Manat",
                                     "TND": "Tunisian Dinar",
                                     "TOP": "Tongan Paʻanga",
                                     "TRY": "Turkish Lira",
                                     "TTD": "Trinidad and Tobago Dollar",
                                     "TWD": "New Taiwan Dollar",
                                     "TZS": "Tanzanian Shilling",
                                     "UAH": "Ukrainian Hryvnia",
                                     "UGX": "Ugandan Shilling",
                                     "USD": "United States Dollar",
                                     "UYU": "Uruguayan Peso",
                                     "UZS": "Uzbekistan Som",
                                     "VEF": "Venezuelan Bolívar Fuerte",
                                     "VND": "Vietnamese Dong",
                                     "VUV": "Vanuatu Vatu",
                                     "WST": "Samoan Tala",
                                     "XAF": "CFA Franc BEAC",
                                     "XAG": "Silver (troy ounce)",
                                     "XAU": "Gold (troy ounce)",
                                     "XCD": "East Caribbean Dollar",
                                     "XDR": "Special Drawing Rights",
                                     "XOF": "CFA Franc BCEAO",
                                     "XPF": "CFP Franc",
                                     "YER": "Yemeni Rial",
                                     "ZAR": "South African Rand",
                                     "ZMK": "Zambian Kwacha (pre-2013)",
                                     "ZMW": "Zambian Kwacha",
                                     "ZWL": "Zimbabwean Dollar"])
        
        let result = changeService.searchMoney(moneyName: "", moneyData: moneys)
        
        XCTAssertEqual(result, "")
    }
}
