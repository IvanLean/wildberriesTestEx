//
//  getDataFile.swift
//  wbActual
//
//  Created by Иван on 02.10.2023.
//

import Foundation




// Создайте DispatchSemaphore с начальным значением 0
let semaphore = DispatchSemaphore(value: 0)

// URL API
let apiUrl = URL(string: "https://vmeste.wildberries.ru/api/guide-service/v1/getBrands")!

// Создайте URLSession
let session = URLSession.shared

// Создайте структуру для хранения данных
struct BrandData: Codable {
    let brands: [Brand]
}

struct Brand: Codable {
    let title: String
    let thumbUrls: [String]
}

// Создайте функцию для загрузки данных из API
func fetchData() {

    let task = session.dataTask(with: apiUrl) { (data, _, error) in
        defer {
            // Уменьшите значение семафора после завершения запроса
            semaphore.signal()
        }
        
        if let error = error {
            print("Ошибка при загрузке данных: \(error)")
            return
        }
        
        guard let data = data else {
            print("Пустые данные")
            return
        }

        do {
            // Разбор данных из JSON
            let brandData = try JSONDecoder().decode(BrandData.self, from: data)
            oneCity.nameOfCity = "NEW ONE"
            print("DO",oneCity.nameOfCity)
            // Получите количество элементов в массиве "brands"
            let numberOfBrands = brandData.brands.count
            print("Количество брендов: \(numberOfBrands)")
            print(brandData.brands[3].title)// данные которые можнно циклом вызывать из массива
            //print(brandData.brands[3].thumbUrls)
            
            for i in 0...brandData.brands.count-1
            {
                
                oneCity.viewsCity.append(0)
                oneCity.likedCity.append(false)
                
                let urlPh = URL(string: brandData.brands[i].thumbUrls.first!)
                let dataPh = try Data(contentsOf: urlPh!)
                
                
                oneCity.cityNames.append(brandData.brands[i].title)
                
                //print(brandData.brands[i].thumbUrls)
                oneCity.manyPhotosOfCity[i] = brandData.brands[i].thumbUrls
                
                //oneCity.cityPhotos.append(brandData.brands[i].thumbUrls.first!)
                oneCity.cityPhotos.append(dataPh)
            }
            //print(oneCity.cityNames)
            print(oneCity.manyPhotosOfCity)
            // Получите название города и одну картинку для первого окна
            if let firstBrand = brandData.brands.first {
                let cityName = firstBrand.title
                let firstImageURL = firstBrand.thumbUrls.first


                //print("Название города: \(cityName)")
                //print("Первая картинка: \(firstImageURL ?? "Нет данных")")
            }

            
            // Получите все картинки для второго окна
            if let secondBrand = brandData.brands.first {
                let imageUrls = secondBrand.thumbUrls
                //print("Все картинки для второго окна:")
                for imageUrl in imageUrls {
                    print(imageUrl)
                }
            }

        } catch {
            print("Ошибка при разборе JSON: \(error)")
        }

        
    }
    task.resume()
    semaphore.wait()

}
/*
// Запустите функцию для загрузки данных
fetchData()
*/
// Дождитесь завершения загрузки данных с помощью семафора



