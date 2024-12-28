//
//  ApiConvertible.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation
/*
 enum RequestType: CaseIterable, Codable {
     case test, agreements, authorization, chat, consultation, dashboard, forms, forum, knowledgebase, goals, lessons, medicalLog, myMeals, notifications, onboarding, patient, progress, recipes, therapist, tutorials, units, utilities, tips, video, consents, doctor, weeklyGoal, feedback, consent

     var title: String {
         switch self {
         case .doctor:
             return "Doctor"
         case .video:
             return "Video"
         case .test:
             return "Test"
         case .agreements:
             return "Agreements"
         case .authorization:
             return "Authorization"
         case .chat:
             return "Chat"
         case .consultation:
             return "Consultation"
         case .dashboard:
             return "Dashboard"
         case .forms:
             return "Forms"
         case .forum:
             return "Forum"
         case .knowledgebase:
             return "Knowledgebase"
         case .goals:
             return "Goals"
         case .lessons:
             return "Lessons"
         case .medicalLog:
             return "Medical log"
         case .myMeals:
             return "MyMeals"
         case .notifications:
             return "Notification"
         case .onboarding:
             return "Onboarding"
         case .patient:
             return "Patient"
         case .progress:
             return "Progress"
         case .recipes:
             return "Recipes"
         case .therapist:
             return "Therapist"
         case .tutorials:
             return "Tutorial"
         case .units:
             return "Units"
         case .utilities:
             return "Utilities"
         case .tips:
             return "Tips"
         case .consents:
             return "Consents"
         case .weeklyGoal:
             return "WeeklyGoals"
         case .feedback:
             return "Feedback"
         case .consent:
             return "Consent"
         }
     }
 }*/

protocol APIConvertible {
    var path: String { get }
    var baseURLComponents: URLComponents { get }
    var parameters: [URLQueryItem]? { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: Data? { get }
    var apiVersion: ApiVersion { get }
    var urlRequest: URLRequest? { get }
    // var requestType: RequestType? { get }
    func createUrlRequest() throws -> URLRequest
}

extension APIConvertible {
    var parameters: [URLQueryItem]? {
        nil
    }

    var httpBody: Data? {
        nil
    }

    var apiVersion: ApiVersion {
        ApiVersion.defaultVersion
    }
}

// typealias RequestImageData = [String: Data]

extension APIConvertible {
    var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = PokedexAPI().urlScheme
        components.host = PokedexAPI().urlHost
        components.path = PokedexAPI().urlPath

        components.queryItems = parameters

        return components
    }

    var urlRequest: URLRequest? {
        guard let url = baseURLComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiVersion.rawValue, forHTTPHeaderField: "api-version")
        request.url?.appendPathComponent(path)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

struct PokedexAPI: PokedexAPIRepresentable {
    let urlScheme = "https"
    var urlHost: String {
        "pokeapi.co"
    }

    let urlPath = "/api"
}

protocol PokedexAPIRepresentable {
    var urlScheme: String { get }
    var urlHost: String { get }
    var urlPath: String { get }
}

enum ApiVersion: String, Codable {
    case v1 = "1"
    case v2 = "2"

    static var defaultVersion: ApiVersion {
        return .v2
    }
}
