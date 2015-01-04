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
    
    public func nativeUpload (filePath: NSURL) -> Void {
        let url:NSURL? = NSURL(string: "http://146.185.179.179/upload.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        
        // Header Parameters
        let boundaryConstant = "*****"
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
        let fileName = filePath.path!.lastPathComponent
        let mimeType = "text/csv"
        let fieldName = "uploadFile"
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Set Data
        var error: NSError?
        var dataString = "--\(boundaryConstant)\r\n"
        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        dataString += "Content-Type: \(mimeType)\r\n\r\n"
		//dataString += String(contentsOfFile: filePath.path!, encoding: NSUTF8StringEncoding, error: &error)!
		dataString += "\r\n"
		dataString += "--\(boundaryConstant)--\r\n"

        println(dataString)
        
        // HTTP Body
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        // Async call
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, dataObject, error) in
            if let apiError = error {
            } else {
            }
        })
    }
}
