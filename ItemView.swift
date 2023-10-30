//
//  ItemView.swift
//  Split It
//
//  Created by Ying Zhang on 9/11/23.
//

import SwiftUI

struct Person: Identifiable {
    
    var payer: String
    var total_originalCurrency: Double
    var id = UUID()

}


struct ItemView: View {
    
        
    @Binding var items: [Bill_Item]
    @Binding var txtfields: [String]
    @Binding var selectedCurrency: String 


    @Binding var tip: Float
    @Binding var tax: Float
//    @Binding var sharedItems: Decimal
    @State var people : [Person] = []
    @State var people1 : [String] = [""]
    

    var body: some View {
        
            
            VStack{
                
                VStack{
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300.0, height: 100.0, alignment: .center)
                        .clipped()
                }

                
                VStack{
                    
                    let itemize_results = itemize1(a: items, b: txtfields, c: tip, d: tax)

                    
                    HStack{
                        
                        Spacer()
                        
                        VStack{
                                Text("Person")
                                    .font(.title)
                                    .bold()
                            VStack{
                                ForEach(itemize_results.indices, id: \.self) { index in
                                    Text(itemize_results[index].payer)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("Owes")
                                .font(.title)
                                .bold()
                            VStack{
                                ForEach(itemize_results.indices, id: \.self) { index in
                                    let formattedFloat = String(format: "%.2f", itemize_results[index].total_originalCurrency)
                                    Text("\(formattedFloat) " + selectedCurrency)
                                        .multilineTextAlignment(.center)
                                        
                                }
                            }
                        }
                        
                        Spacer()
                    }

                }
                Spacer()

            }.onAppear { _ = self.itemize1(a: items, b: txtfields, c: tip, d: tax) }
        

    }
    
    func itemize1(a: Array<Bill_Item>, b: [String], c: Float, d: Float)->[Person] {
        
        let tip1 = Double(tip)
        let tax1 = Double(tax)
        
        var sharedSum: Double = 0
        let filtered_results = items.filter { $0.payer == "All" }
        
        for price in filtered_results{
        let itemPriceDouble = Double(price.priceString) ?? 0

            sharedSum += (itemPriceDouble + tip1 + tax1)
        }
        
        sharedSum = sharedSum/Double(txtfields.count)
        
        for person in txtfields{
            print("person:", person)
            people.append(Person(payer: person, total_originalCurrency: 0))
            print(people)


            var personSum: Double = 0
            let filtered_results = items.filter { $0.payer == (person) }
            
            for person_item in filtered_results{
                let itemPriceDouble = Double(person_item.priceString) ?? 0
                personSum += itemPriceDouble
            }
            personSum += sharedSum

            personSum = round(personSum * 100.00) / 100.00
            
            if let idx = people.firstIndex(where: { $0.payer == person }) {
                people[idx].total_originalCurrency = (personSum)
            }
            
            print(people)

            }

        return people
    }
    
}

struct ItemView_Previews: PreviewProvider {
    
    @State static var items: [Bill_Item] = []
    @State static var txtfields: [String] = [""]
    @State static var tip: Float = 0
    @State static var tax: Float = 0
    @State static var currencies: [String] = [""]
    @State static var selectedCurrency: String = ""
    
    static var previews: some View {
        ItemView(items: $items, txtfields: $txtfields, selectedCurrency: $selectedCurrency, tip: $tip, tax: $tax)
    }
}
