//
//  LocaleFileManager.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 24/06/2026.
//

import Foundation
import SwiftUI

class LocaleFileManager {
    
   static let instance = LocaleFileManager()
    
    private init(){}
    
    func saveImage (image:UIImage , imageName:String , folderName:String){
      
        createFolderIfNeeded(folderNamde: folderName)
       
        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        
        do {
            try data.write(to: url )
        } catch let error {
            print("Error Saving Image \(imageName) . \(error)")
        }
    }
    
    func getImage(imageName:String, folderName:String) -> UIImage? {
        guard let imageURL = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: imageURL.path())
        else {
            return nil
        }
        return UIImage(contentsOfFile: imageURL.path()
        )
    }
    
    private func createFolderIfNeeded(folderNamde:String){
        guard let url = getURLForFolder(folderName: folderNamde) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path()){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,attributes: nil)
            } catch let error {
                 print("Error Creating Folder \(folderNamde) . \(error)")
            }
            
        }
    }
    
  private func getURLForFolder(folderName:String) -> URL?{
       guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
           return nil
       }
        return url.appending(path: folderName)
    }
    
    
   private func getURLForImage(imageName:String,folderName:String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName)  else {
            return nil
        }
       return folderURL.appending(path: imageName + ".png")
          
    }
}
