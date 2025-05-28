import SwiftUI
import PhotosUI

struct MainView: View {
    @StateObject var cameraVM = CameraViewModel()
    @StateObject var foodVM = FoodAnalysisViewModel()
    @StateObject var historyVM = HistoryViewModel()
    @Namespace var animation
    
    @State private var showPhotoPicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated gradient background using SwiftUI animation
                AnimatedBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if let image = cameraVM.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                            .transition(.scale)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                        .opacity(0.8)
                                    Text("No image captured")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                            )
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation { cameraVM.isPresentingCamera = true }
                        }) {
                            Label("Capture", systemImage: "camera.fill")
                                .font(.title3.bold())
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            Label("Select", systemImage: "photo.fill.on.rectangle.fill")
                                .font(.title3.bold())
                                .padding()
                                .background(Color.indigo.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                        }
                    }
                    .sheet(isPresented: $cameraVM.isPresentingCamera) {
                        CameraSelector(image: $cameraVM.capturedImage)
                    }
                    .sheet(isPresented: $showPhotoPicker) {
                        PhotoSelector(image: $cameraVM.capturedImage)
                    }
                    
                    if cameraVM.capturedImage != nil {
                        Button(action: {
                            Task {
                                await foodVM.analyzeImage(cameraVM.capturedImage!)
                            }
                        }) {
                            Label("Analyze Food", systemImage: "sparkles")
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                        }
                    }
                    
                    if !foodVM.ingredients.isEmpty {
                        ScrollView {
                            ForEach(foodVM.ingredients) { ing in
                                HStack {
                                    Text(ing.name)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    TextField("Calories", value: Binding(
                                        get: { ing.calories },
                                        set: { newValue in
                                            foodVM.updateIngredient(ing, calories: newValue ?? 0)
                                        }), formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                }
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .padding(.horizontal)
                                .transition(.move(edge: .bottom))
                            }
                        }
                        
                        Text("Total Calories: \(foodVM.totalCalories)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .transition(.opacity)
                    }
                    HStack {
                        if !foodVM.ingredients.isEmpty {
                            Button("Save to History") {
                                withAnimation {
                                    let log = FoodLog(id: UUID(), date: Date(), ingredients: foodVM.ingredients, totalCalories: foodVM.totalCalories)
                                    historyVM.addLog(log)
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            Spacer()
                        }
                        NavigationLink(destination: HistoryView(viewModel: historyVM)) {
                            Text("View History")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Calorie Counter")
        }
    }
}



#Preview {
    MainView()
}
