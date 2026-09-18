//
//  AuthServicing.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

protocol AuthServicing {
    func restoreSession() async throws -> AppUser?
    func signInAnonymously(user_name: String) async throws -> AppUser
    func logout() async throws
}

