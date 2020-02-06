//
//  ContentView.swift
//  SwiftUI_Coredata_tutorial
//
//  Created by YOUNGSIC KIM on 2020-02-04.
//  Copyright © 2020 YOUNGSIC KIM. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var textValue = ""
    @State private var updateRowID: NSManagedObjectID?
    @State private var updateRowValue = ""
    @State private var isUpdate = false
    @ObservedObject private var datas = coreDataController
    
    var body: some View {
        VStack {
            List {
                ForEach(datas.data){ data in
                    HStack {
                        Button(action: {
                            self.isUpdate = true
                            print(data.id)
                            self.updateRowID = data.id
                            self.updateRowValue = data.text
                        }) {
                            Text(data.text)
                        }
                    }
                }.onDelete { (index) in
                    coreDataController.deleteData(id: self.datas.data[index.first!].id,index: index)
                }
            }
            self.isUpdate ? Text("The value ( \(updateRowValue) ) will chage") : nil
            HStack {
                Spacer()
                TextField("Add text please", text: $textValue).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.doItButton()
                }) {
                    Text("Do It")
                }
                Spacer()
            }
        }
    }
    
    func doItButton() {
        self.isUpdate ? coreDataController.updateData(id: updateRowID!,txt: self.textValue) : coreDataController.createData(msg1: self.textValue)
        self.isUpdate = false
        self.textValue = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
