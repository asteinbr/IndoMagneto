//
//  FileUploader.swift
//  IndoMagneto
//
//  Created by Alexander Steinbrecher on 04/01/15.
//  Copyright (c) 2015 Alexander Steinbrecher. All rights reserved.
//

import Foundation

public class FileUploader {
    public typealias CompletionHandler = (obj:AnyObject?, success: Bool?) -> Void
    
    public func nativeUpload (fileName: String, data: String) -> Void {
        //let filePath = NSURL.init(fileURLWithPath: "/Users/asteinbr/swiftTest")!
        let url:NSURL? = NSURL(string: "http://146.185.179.179/upload.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        
        request.HTTPMethod = "POST"
        
        // Set Content-Type in HTTP header.
        let boundaryConstant = "*****" // This should be auto-generated.
        
        let contentType = "multipart/form-data;boundary=" + boundaryConstant
        //let fileName = filePath.path!.lastPathComponent
        let mimeType = "text/csv"
        let fieldName = "uploaded_file"
        
        let connectionType = "Keep-Alive"
        let enctype = "multipart/form-data"
        
        request.setValue(connectionType, forHTTPHeaderField: "Connection")
        request.setValue(enctype, forHTTPHeaderField: "ENCTYPE")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(fileName, forHTTPHeaderField: "uploaded_file")
        
        println(request.allHTTPHeaderFields)
        
        // Set data
        var error: NSError?
        var dataString = "--\(boundaryConstant)\r\n"
        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        dataString += "\n"
        //dataString += "Content-Type: \(mimeType)\r\n\r\n"
        //dataString += String(contentsOfFile: filePath.path!, encoding: NSUTF8StringEncoding, error: &error)!
        dataString += data
        dataString += "--\(boundaryConstant)--\r\n"
        println(dataString) // This would allow you to see what the dataString looks like.
        
        // Set the HTTPBody we'd like to submit
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        // Make an asynchronous call so as not to hold up other processes.
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, dataObject, error) in
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                if statusCode == 200 {
                    NSNotificationCenter.defaultCenter().postNotificationName("IndoMagnetoNotificationKeySuccess", object: self)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName("IndoMagnetoNotificationKeyFailure", object: self)
                }
            }
            
            if let apiError = error {
                //aHandler?(obj: error, success: false)
                NSNotificationCenter.defaultCenter().postNotificationName("IndoMagnetoNotificationKeyError", object: self)
            }
        })
    }
}
