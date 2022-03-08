//
//  CoinManager.swift
//  ByteCoin
//

import Foundation

//По соглашению протоколы Swift обычно пишутся в файле, который имеет класс/структуру, которая будет вызывать методы делегирования, то есть CoinManager.


//Создаем заглушки методов без реализации в протоколе.
    //Обычно рекомендуется также передавать ссылку на текущий класс.
    //например. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    //Создадим необязательный делегат, который должен будет реализовать методы делегата.
    //Что мы можем уведомить, когда мы обновили цену.
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D0923C65-522F-40F3-A22D-55DD538EDACF"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        //Использую конкатенацию строк, чтобы добавить выбранную валюту в конец базового URL-адреса вместе с ключом API
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Использую "необязательную привязку", чтобы развернуть URL-адрес, созданный из urlString
        if let url = URL(string: urlString) {
            
            //Создал новый объект URLSession с конфигурацией по умолчанию
            let session = URLSession(configuration: .default)
            
            //Создаю новую задачу данных для URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                /* Шаг 1: Отформатировал полученные данные в виде строки, чтобы иметь возможность их "распечатать"
                let dataAsString = String(data: data!, encoding: .utf8)
                print(dataAsString)
                */
                
                // Шаг 2:
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        //Шаг 3:
                        //Округлим цену до 2 знаков после запятой.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        //Вызываем метод делегата в делегате (ViewController) и
                        //передаем необходимые данные.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //Запустить задачу для получения данных с сервера.
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        //Создание декодера JSON
        let decoder = JSONDecoder()
        do {
            //декодирую данные с помощью структуры CoinData
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            // получение последнего свойства из декодированных данных.
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            // в случае ошибки распечатать любые ошибки.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
