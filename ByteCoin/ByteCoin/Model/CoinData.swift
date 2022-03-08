//
//  CoinData.swift
//  ByteCoin
//
//  Created by Александр on 08.03.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

//Создание структуры соответствующей протоколу Decodable, чтобы использовать ее для декодирования нашего JSON. Также можете использовать псевдоним типа Codable для соответствия протоколам Decodable и Encodable на случай, если захотим превратить объект Swift обратно в JSON.

struct CoinData: Codable {
    
    // Есть только одно свойство, которое нас интересует в данных JSON, это последняя цена биткойнаю. Поскольку это десятичное число, присвоим ему тип данных Double.
    let rate: Double
}
