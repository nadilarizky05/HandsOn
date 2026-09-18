//
//  SupabaseClientProvider.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Supabase

//NAMPUNG NILAI DARI CONNECT-AN SUPABASENYA
enum SupabaseClientProvider {
    static let client = SupabaseClient(
        supabaseURL: SupabaseConfig.projectURL,
        supabaseKey: SupabaseConfig.publishableKey
    )
}
