//
//  PaywallView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: AppContainer
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Premium")
                            .font(.system(size: 32, weight: .bold))
                            .tracking(-1.0)
                        
                        Text("Get unlimited access to historical stats and insights")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "chart.bar.fill", text: "Unlimited historical stats")
                        FeatureRow(icon: "calendar", text: "Multi-year data views", iconColor: .white)
                        FeatureRow(icon: "sparkles", text: "Advanced analytics", iconColor: AppColors.sunflowerGold)
                        FeatureRow(icon: "lock.shield.fill", text: "Privacy-first, local data")
                    }
                    .padding()
                    
                    // Products
                    if products.isEmpty && !isLoading {
                        // Test purchase button for Simulator
                        Button {
                            // Simulate purchase in debug
                            #if DEBUG
                            Task {
                                await handleTestPurchase()
                            }
                            #endif
                        } label: {
                            Text("Test Purchase (Debug Only)")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.sunflowerGold)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    } else {
                        ForEach(products) { product in
                            ProductButton(product: product, isSelected: selectedProduct?.id == product.id) {
                                selectedProduct = product
                            }
                        }
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Purchase Button
                    if let selectedProduct = selectedProduct {
                        Button {
                            Task {
                                await purchase(selectedProduct)
                            }
                        } label: {
                            Text("Subscribe")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .disabled(isLoading)
                    }
                    
                    // Restore
                    Button {
                        Task {
                            await restorePurchases()
                        }
                    } label: {
                        Text("Restore Purchases")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadProducts()
            }
        }
        .background(AppColors.background.ignoresSafeArea())
    }
    
    private func loadProducts() async {
        isLoading = true
        do {
            products = try await container.subscriptionService.loadProducts()
            selectedProduct = products.first
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func purchase(_ product: Product) async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await container.subscriptionService.purchase(product)
            dismiss()
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func restorePurchases() async {
        isLoading = true
        do {
            try await container.subscriptionService.restorePurchases()
            dismiss()
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    #if DEBUG
    private func handleTestPurchase() async {
        // In debug, we can simulate a purchase
        // This would update the user profile in a real scenario
        dismiss()
    }
    #endif
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var iconColor: Color = .green
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}

struct ProductButton: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                    Text(product.displayPrice)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(isSelected ? Color.green.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    PaywallView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

