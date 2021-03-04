//
//  GameThemeView.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 16.02.2021.
//

import SwiftUI

struct GameThemeView: View {
   
    @ObservedObject var gameTheme : GameTheme
   
    @State private var addNewTheme = false
    @State private var editName = ""
    @State private var editEmodjis = ""
    @State private var isEditing = false
    
    var body: some View {
        return NavigationView {
            List {
                ForEach(gameTheme.themesNames, id : \.self) { themeName in
                    if gameTheme.getTheme(key: themeName) != nil {
                        if !isEditing {
                        NavigationLink(
                            destination: ContentView(viewModel: gameTheme.getTheme(key: themeName) ?? EmodjiMemoryGame(values: "👻🎃🕷"))
                            ) {
                            
                            Text(themeName)
                            
                        }
                        }
                        else {
                            
                            NavigationLink(
                                destination: AddNewTheme(addNewTheme: $addNewTheme,
                                                         editName : themeName,
                                                         editEmodjis : gameTheme.getTheme(key: themeName)?.emodjis ?? "👻🎃🕷",
                                                         editableColorIndex : 0,
                                                         isEditing : $isEditing,
                                                         oldKey : themeName)
                                                 .environmentObject(gameTheme)
                                ) {
                                
                                
                                Text(themeName)
                                
                            }
//                            Text(themeName).onTapGesture {
//                                    DispatchQueue.main.async {
//                                            editName = themeName
//                                            editEmodjis = gameTheme.getTheme(key: themeName)?.emodjis ?? "👻🎃🕷"
//                                            print("\(editName) and \(editEmodjis)")
//                                            addNewTheme = true
//                                    }
//
//                            }
                        }

                        
                    }
                }
            }.navigationBarItems(
                leading: Button(action: {
                    editName = ""
                    editEmodjis = ""
                    addNewTheme = true
                },label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: Button(action: {
                    isEditing.toggle()
                }, label: {
                    Text(!isEditing ? "Edit" : "Done")
                })
            )
            //.environment(\.editMode, $editMode)
        }.sheet(isPresented: $addNewTheme, content: {
             AddNewTheme(addNewTheme: $addNewTheme,
                        editName : editName,
                        editEmodjis : editEmodjis,
                        editableColorIndex : 0,
                        isEditing : $isEditing,
                        oldKey : editName)
                .environmentObject(gameTheme)
        })
    }
    
}

struct AddNewTheme : View {
    
   @EnvironmentObject var gameTheme : GameTheme
   @Binding var addNewTheme : Bool
    
    @State var editName : String
    @State var editEmodjis : String
    @State var editableColorIndex : Int
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var isEditing : Bool
    
    var oldKey : String
    
    
    var body: some View {
        let colors = ColorsEnum.allCases
        
        
        VStack {
            
            Form {
                
            
                Text("Theme name: ")
            
                TextField("", text : $editName)
            
                Text("Theme emodjis: ")
            
                TextField("", text : $editEmodjis)
                
                
            
                Button(action: {
                
                if isEditing {
                    gameTheme.changeTheme(oldKey: oldKey, newKey: editName, newElements: editEmodjis,
                                          color: colors[editableColorIndex])
                } else {
                    gameTheme.addTheme(key: editName, elements: editEmodjis, color: colors[editableColorIndex])
                }
                    
                
                addNewTheme = false
                isEditing = false
                presentationMode.wrappedValue.dismiss()
            
                }, label: {
                
                    Text(!isEditing ? "Add Theme" : "Change Theme")
            
                })
                
                if isEditing {
                    Button(action: {
                        
                        if gameTheme.countThemes > 1 {
                           gameTheme.removeTheme(key: oldKey)
                        }
                        
                        addNewTheme = false
                        isEditing = false
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Remove")
                    })
                }
                
                
            }
            
            Text("Pick color:")
            
            Picker("",selection: $editableColorIndex) {
                ForEach(0..<colors.count) { index in
                    Text(colors[index].rawValue.split(separator: " ")[0])
                }
            }
            
           
            
        }
        
    }
    
}


