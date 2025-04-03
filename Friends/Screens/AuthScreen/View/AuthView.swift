//
//  AuthentificationScreen.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        VStack {
            HStack {
                Image("icon")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text("Friends")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .opacity(0.8)
            }
            .padding(.top, 200)

            List {
                if viewModel.mode == .registration {
                    TextField("Name", text: $viewModel.name)
                }

                TextField("Username", text: $viewModel.username)
                TextField("Password", text: $viewModel.password)
            }

            VStack {
                HStack(alignment: .bottom) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.orange)
                        .font(.system(size: 16))

                    Text(viewModel.errorMessage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.orange)
                }
                .padding(.bottom, 5)
                .opacity(viewModel.showErrorAlert ? 1 : 0)
                .offset(y: viewModel.showErrorAlert ? 0 : 10)
                .animation(.easeInOut, value: viewModel.showErrorAlert)

                Button(viewModel.mode == .login ? "Login" : "Create Account") {
                    viewModel.showErrorAlert = false
                    viewModel.authenticate()
                }
                .frame(width: 170, height: 50)
                .background(Color.blue)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 9))
                .padding(.bottom, 10)

                Button(viewModel.mode == .login ? "CreateAccount" : "Login") {
                    viewModel.showErrorAlert = false
                    if viewModel.mode == .login {
                        viewModel.mode = .registration
                    } else {
                        viewModel.mode = .login
                    }
                }
            }
            .padding(.bottom, 50)
        }
        .background(Color.background)
    }
}
