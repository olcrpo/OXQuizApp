//
//  ContentView.swift
//  OXQuizApp
//
//  Created by 이수겸 on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    @State var number1 = Int.random(in: 1...10)
    @State var number2 = Int.random(in: 1...10)
    let operations: [String] = ["+", "-", "x"]
    @State var operation: String = "+"
    
    @State var isOperationCorrect: Bool = true
    @State var isAnswerCorrect: Bool? = nil
    @State var resultNumber: Int = 0

    @State var countCorrect: Int = 0
    @State var countWrong: Int = 0
    
    var body: some View {
        VStack {
            Text("다음 수식은 맞을까요?")
                .font(.largeTitle)
            Spacer()
            Text("\(number1) \(operation) \(number2) = \(resultNumber)")
                .font(.largeTitle)
                .bold()
                .padding()
                .background(isAnswerCorrect == true ? Color.green : isAnswerCorrect == false ? Color.red : Color.white)
                .cornerRadius(15)
                .shadow(radius: 15)
                .animation(.easeInOut, value: isAnswerCorrect)
            Spacer()
            HStack {
                Spacer()
                Text("\(countCorrect)")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                Spacer()
                Text("\(countWrong)")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                Spacer()
                
            }
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    selectCorrect()
                    
                } label: {
                    Image(systemName: "checkmark.square.fill")
                }
                .font(.system(size: 100))
                .foregroundColor(.green)
             
                Spacer()
                Button {
                    selectWrong()
                    
                } label: {
                    Image(systemName: "xmark.app.fill")
                }
                .font(.system(size: 100))
                .foregroundColor(.red)
                
                Spacer()
                
            }
            Spacer()
            
            Button {
                reloadGame()
            } label: {
                Image(systemName: "repeat.circle.fill")
            }
            .font(.largeTitle)
            
        }
        .padding()
    }
    
    func reloadGame() {
        countCorrect = 0
        countWrong = 0
        generateNewQuiz()
    }
    
    func selectCorrect() {
        if isOperationCorrect {
            isAnswerCorrect = true
            countCorrect += 1
        } else {
            isAnswerCorrect = false
            countWrong += 1
        }
        
        // 애니메이션 초기화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 0.5초 후 초기화
            isAnswerCorrect = nil
            generateNewQuiz()
        }
    }

    func selectWrong() {
        if !isOperationCorrect {
            isAnswerCorrect = true
            countCorrect += 1
        } else {
            isAnswerCorrect = false
            countWrong += 1
        }
        
        // 애니메이션 초기화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 0.5초 후 초기화
            isAnswerCorrect = nil
            generateNewQuiz()
        }
    }

    
    func generateNewQuiz() {
        number1 = Int.random(in: 1...10)
        number2 = Int.random(in: 1...10)
        if let randomOperation = operations.randomElement() {
            operation = randomOperation
        } else { return }
        
        
        if Bool.random() {
            // 정답 생성
            isOperationCorrect = true
            generateCorrectAnswer()
        } else {
            // 오답 생성
            isOperationCorrect = false
            generateWrongAnswer()
        }
    }
    
    func generateCorrectAnswer() {
        let result: [String: (Int, Int) -> Int] = [
            "+": { $0 + $1 },
            "-": { $0 - $1 },
            "x": { $0 * $1 }
        ]
        guard let correctResult = result[operation] else {
            print("값이 없습니다.")
            return
        }
        resultNumber = correctResult(number1, number2)
    }
    
    func generateWrongAnswer() {
        let result: [String: (Int, Int) -> Int] = [
            "+": { $0 + $1 },
            "-": { $0 - $1 },
            "x": { $0 * $1 }
        ]
        guard let correctResult = result[operation] else {
            print("값이 없습니다.")
            return
        }
        
        repeat{
            resultNumber = Int.random(in: 2...(correctResult(number1, number2) + 5))
        } while resultNumber == correctResult(number1, number2)
    }
}

#Preview {
    ContentView()
}
