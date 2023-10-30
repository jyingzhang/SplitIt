//
//  BillView.swift
//  Split It
//
//  Created by Ying Zhang on 9/6/23.
//

import SwiftUI

struct Bill_Item {
//    var id = UUID()
    var name: String
    var priceString: String = ""
    var payer: String
}

struct BillView: View {
    
    
    @Binding var txtfields: [String]
    @State private var items: [Bill_Item] = []
    @State private var tip: Float = 0.0
    @State private var tax: Float = 0.0
    @State private var sum: Float = 0.0
    @State var sharedItems: Decimal = 0.00
    
    @State private var currencies = ["EUR", "USD", "GBP", "CNY", "JPY"]
    @State private var selectedCurrency = "EUR"
    @State private var isNumberValid : Bool   = true
    
    
    var body: some View {
        
        ZStack{
            VStack {
                
                VStack(){
                    VStack{
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300.0, height: 100.0, alignment: .center)
                            .clipped()
                    }
                    
                    VStack{
                        
                        HStack{
                            Text("Bill Currency: ")
                            
                            Picker(selection: $selectedCurrency, label: Text("Bill Currency: ")) {
                                ForEach(currencies, id: \.self) {
                                    currency in Text(currency)
                                }
                            }
                        }
                        //                            .pickerStyle(MenuPickerStyle())
                        let _ = print(selectedCurrency)
                        
                        Button(action: {
                            items.append(Bill_Item(name: "", priceString: "", payer: ""))
                        }) {
                            Text("Add Item")
                                .font(.title2)
                                .buttonBorderShape(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=shape: ButtonBorderShape@*/.automatic/*@END_MENU_TOKEN@*/)
                                .frame(width:150, height: 50)
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                                .cornerRadius(100)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                }
                
                //big yellow bill
                VStack{
                    
                    //item list
                    VStack{
                        let sum = itemTotal(a: &items, tip: tip, tax:tax)
                        if sum == "99999999999" {
                            Text("Prices should only contain digits")
                                .foregroundColor(.red)
                        }
                        List{

                            ForEach(items.indices, id: \.self) { index in
                                
                                HStack(alignment: .top){
                                    TextField("Item name", text: $items[index].name)
                                        .listRowSeparator(.hidden)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .shadow(radius: 2)
                                        .frame(width: 150.0)
                                    
                                    TextField("Price", text: $items[index].priceString)
                                        .listRowSeparator(.hidden)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .shadow(radius: 2)
                                        .frame(width: 70.0)
                                    
                                    Picker("Person", selection: $items[index].payer)
                                    {
                                        Text("No Option").tag(Optional<String>(nil))
                                        
                                        ForEach(txtfields, id: \.self) { person in
                                            Text(person)
                                        }
                                        Text("All").tag("All")
                                            .pickerStyle(MenuPickerStyle())
                                    }
                                    .frame(width: 95.0)
                                    .labelsHidden()
                                    .foregroundColor(.black)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .alignmentGuide(.listRowSeparatorLeading){ viewDimensions in return 0
                                }
                                
                            }
                            .onDelete(perform: {indexSet in items.remove(atOffsets: indexSet)})
                            .listRowBackground(Color(white: 1, opacity: 0))
                            .padding()
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .frame(height: 55.0)
                        }
                        .padding(.top, -20.0)
                        .frame(maxWidth: .infinity)
                        .scrollContentBackground(.hidden)
                        
                        let _ = print(items)
                        
                        Divider()
                        
                        //bottom of bill: three Ts and Split button
                        HStack{
                            Spacer()
                            
                            VStack(alignment: .leading){
                                
                                HStack{
                                    Text("Tip")
                                    // enter a number here
                                    TextField("number", value: $tip, format: .number)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.bottom, -1.0)
                                        .shadow(radius: 3)
                                        .frame(width: 100.0)
                                }
                                
                                HStack{
                                    Text("Tax")
                                    // enter a number here
                                    TextField("number", value: $tax, format: .number)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.bottom, -1.0)
                                        .shadow(radius: 3)
                                        .frame(width: 100.0)
                                }
                                
                                HStack{
                                    
                                    if sum == "99999999999" {
                                        Text("Total: ERROR")
                                            .font(.title2)
                                    }
                                    else{
                                        Text("Total: " + sum + " " + selectedCurrency)
                                            .font(.title2)
                                    }

                                }
                                
                            }
                            .frame(height: 150)
                            
                            Spacer()
                            
                            VStack{
                                
                                NavigationLink(destination:
                                                
                                                ItemView(items: $items, txtfields: $txtfields, selectedCurrency: $selectedCurrency, tip: $tip, tax: $tax)
                                               
                                )
                                {
                                    Text("Itemize")
                                        .font(.title2)
                                        .buttonBorderShape(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=shape: ButtonBorderShape@*/.automatic/*@END_MENU_TOKEN@*/)
                                        .frame(width:125, height: 50)
                                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                    
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    .border(.black)
                    .background(Color("BillYellow"))
                    
                }
                Spacer()
                
            }
            
        }
    }
        
    }
    
    func itemTotal(a: inout Array<Bill_Item>, tip: Float, tax: Float) -> String {
        
        var sum1: Decimal = 0.00
        let tip1: Decimal = NSNumber(floatLiteral: Double(tip )).decimalValue
        let tax1: Decimal = NSNumber(floatLiteral: Double(tax )).decimalValue
        
        for x in a {
            if let _ = Double(x.priceString){
                let price0 = Double(x.priceString) ?? 0
                let price1: Decimal = NSNumber(floatLiteral: price0 ).decimalValue
                sum1 += price1
            }else if x.priceString == ""{
                print("")
            }else{
                return "99999999999"
            }

        }
        
        sum1 = sum1+tip1+tax1
        let someDouble = Double(truncating: sum1 as NSNumber)
        let sum2 = round(someDouble * 100) / 100.0
        
        return ("\(sum2)")
    }
    
    
    struct BillView_Previews: PreviewProvider {
        
        @State static var txtfields: [String] = [""]
        
        static var previews: some View {
            BillView(txtfields: $txtfields)
        }
    }
    
