//
//  Supabase.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/20/24.
//

import SwiftUI
import Supabase

struct Supabase: View {
    let supabase = SupabaseClient(
      supabaseURL: URL(string: "https://nqvwiqqkwxxerurixirh.supabase.co")!,
      supabaseKey: "YOUR_SUPABASE_ANON_KEY"
    )
}

#Preview {
    Supabase()
}
