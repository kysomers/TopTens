//
//  Protocols.swift
//  TopTens
//
//  Created by Kyle Somers on 8/8/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation

protocol UpdateTableViewDelegate{
    func updateTableView()
}

protocol SingleCellDeleterDelegate{
    func deleteCellAtIndexPath(indexPath : IndexPath)
}
