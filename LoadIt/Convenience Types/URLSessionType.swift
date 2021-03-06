//
//  URLSessionType.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol URLSessionType {
  func perform(request request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void)
}

extension NSURLSession: URLSessionType {
  public func perform(request request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    dataTaskWithRequest(request, completionHandler: completion).resume()
  }
}
