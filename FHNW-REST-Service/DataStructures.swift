// Created 22.11.2023

import Foundation

// MARK: - User

struct User: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo

struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company

struct Company: Codable {
    let name, catchPhrase, bs: String
}

typealias Users = [User]

// MARK: - TODO Structure

// MARK: - Todo
struct Todo: Codable {
    let userId, id: Int
    let title: String
    let completed: Bool

}

typealias Todos = [Todo]
