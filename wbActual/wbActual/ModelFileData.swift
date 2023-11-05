//
//  ModelFileData.swift
//  wbActual
//
//  Created by Иван on 02.10.2023.
//

import Foundation


struct City {
    var cityPhotos = [Data]()
    var cityNames = [String]()
    var manyPhotosOfCity = [Int: [String]]()
    var nameOfCity = ""
    var clickedCell = 0
    var likedCity = [Bool]()
    var viewsCity = [Int]()
}

var oneCity = City()

