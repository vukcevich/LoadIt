//
//  JSONResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol ResourceType {
  associatedtype Model
}

public protocol JSONResourceType: ResourceType {
  func modelFrom(jsonDictionary jsonDictionary: [String : AnyObject]) -> Model?
  func modelFrom(jsonArray jsonArray: [AnyObject]) -> Model?
}

// MARK: - Parsing defaults
extension JSONResourceType {
  public func modelFrom(jsonDictionary jsonDictionary: [String : AnyObject]) -> Model? { return nil }
  public func modelFrom(jsonArray jsonArray: [AnyObject]) -> Model? { return nil }
}

enum ParsingError: ErrorType {
  case InvalidJSONData
  case CannotParseJSONDictionary
  case CannotParseJSONArray
  case UnsupportedType
}

// MARK: - Convenince parsing functions
extension JSONResourceType {
  
  func resultFrom(data data: NSData) -> Result<Model> {
    guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) else {
      return .Failure(ParsingError.InvalidJSONData)
    }
    
    if let jsonDictionary = jsonObject as? [String: AnyObject] {
      return resultFrom(jsonDictionary: jsonDictionary)
    }
    
    if let jsonArray = jsonObject as? [AnyObject] {
      return resultFrom(jsonArray: jsonArray)
    }
    
    // This is likely an impossible case since `JSONObjectWithData` likely only returns [String: AnyObject] or [AnyObject] but still needed to appease the compiler
    return .Failure(ParsingError.UnsupportedType)
  }
  
  private func resultFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> Result<Model> {
    if let parsedResults = modelFrom(jsonDictionary: jsonDictionary) {
      return .Success(parsedResults)
    } else {
      return .Failure(ParsingError.CannotParseJSONDictionary)
    }
  }
  
  private func resultFrom(jsonArray jsonArray: [AnyObject]) -> Result<Model> {
    if let parsedResults = modelFrom(jsonArray: jsonArray) {
      return .Success(parsedResults)
    } else {
      return .Failure(ParsingError.CannotParseJSONArray)
    }
  }
  
}
