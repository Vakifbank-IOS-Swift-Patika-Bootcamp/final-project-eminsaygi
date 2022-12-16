//
//  SwiftUIView.swift
//  TMDB-App
//
//  Created by Emin Saygı on 5.11.2022.
//

import SwiftUI

@available(iOS 16.0, *)
struct SettingsVC: View {
    @State var isOn = false
    @State var selection = "en"
    @State var valueS = ""

   let lang = ["en","tr","ru"]
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                Form {
                    Toggle(langChange(str: "Dark Mode", lang: valueS),isOn: $isOn)
                        .onChange(of: isOn) { value in
                          
                            if #available(iOS 15.0, *){
                                       let appDelaggate = UIApplication.shared.windows.first
                                       
                                       if value {
                                           appDelaggate?.overrideUserInterfaceStyle = .dark
                                           return
                                       }
                                       appDelaggate?.overrideUserInterfaceStyle = .light
                                   }
                        }
                    Picker(langChange(str: "Language", lang: valueS), selection: $selection) {
                        ForEach(lang, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selection) { value in
                        valueS = value
                        Utils.shared.lang = value
                    }
                }
               
                
            }.navigationTitle(langChange(str: "Settings", lang: valueS))
                .navigationBarTitleDisplayMode(.inline)
                
        }
     
       
    }

  
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListVC"  {
            let detailVC = segue.destination as? GameListVC
            detailVC!.langString = valueS
            
            
        }
    }
}

@available(iOS 16.0, *)
struct SettingsVC_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVC()
        
    }
}


 @available(iOS 16.0, *)
 class SettingsVCBridge : UIHostingController<SettingsVC> {
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder, rootView: SettingsVC())
     }
 }


 



