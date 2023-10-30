//
//  contentview.swift
//  Split It
//
//  Created by Ying Zhang on 9/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var txtfields: [String] = [] // <-- the textfields text values
    @State private var number = 0  // <-- user input number
    @State private var isHidden = true
    @State var showView = false

    var body: some View {
        
        NavigationView{
            
            VStack {
                
                VStack{
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300.0, height: 100.0, alignment: .center)
                        .clipped()
                }

                Text("Enter number of payers")
                // enter a number here
                TextField("number", value: $number, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(radius: 3)
                    .padding()
                    .submitLabel(.continue)
                    .onSubmit {

                        if (number <= 10) {   // max 5
                            txtfields = Array(repeating: "", count: number)
                        }
                        else if (number > 10) {   // max 5
                        }
                        
                    }
                

                // the list of TextFields
                ScrollView{
                    LazyVStack {
                        ForEach(txtfields.indices, id: \.self) { index in
                            TextField("name", text: $txtfields[index])
                                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                                .listRowSeparator(.hidden)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .shadow(radius: 3)
                        }
                        let _ = print(txtfields)
                    }
                }

                .scrollContentBackground(.visible)

                                                
                if txtfields.contains("") == true {
                    Text("Enter the name for each person")
                        .foregroundColor(Color.red)
                }
                else if (txtfields.contains("") == false) && (number != 0) && (txtfields.count != 0){
                                        
                    NavigationLink(destination: BillView(txtfields: $txtfields))
                    {
                        Text("Next")
                            .font(.title2)
                            .buttonBorderShape(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=shape: ButtonBorderShape@*/.automatic/*@END_MENU_TOKEN@*/)
                            .frame(width:100, height: 50)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                            .cornerRadius(100)
                            .foregroundColor(.white)
                    }

                }

                Spacer()
                
        }

        }
        
        
}
    

}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
