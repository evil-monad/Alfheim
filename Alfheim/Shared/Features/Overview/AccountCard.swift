//
//  AccountCard.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/19.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import Kit
import ComposableArchitecture

struct AccountCard: View {
  let store: Store<Overview.State, Overview.Action>

  @State private var flipped: Bool = false
  private let cornerRadius: CGFloat = 20

  var body: some View {
    FlipView(visibleSide: flipped ? .back : .front) {
      Front(store: store, onFlip: { flip(true) })
        .background(
          RoundedRectangle(cornerRadius: cornerRadius)
          .fill(LinearGradient(
            gradient: Gradient(colors: [Color("AH03"), Color("Blue60")]),
            startPoint: .top,
            endPoint: .bottom
          ))
        )
    } back: {
      Back(store: store, onFlip: { flip(false) })
        .background(
          RoundedRectangle(cornerRadius: cornerRadius)
          .fill(LinearGradient(
            gradient: Gradient(colors: [Color("AH03"), Color("Blue60")]),
            startPoint: .top,
            endPoint: .bottom
          ))
        )
    }
    .animation(Animation.spring(response: 0.35, dampingFraction: 0.7), value: flipped)
  }

  struct Front: View {
    let store: Store<Overview.State, Overview.Action>
    let onFlip: () -> Void

    var body: some View {
      WithViewStore(store) { viewStore in
        Card {
          ZStack {
            if viewStore.timeInterval != nil {
              HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                  menu(period: viewStore.periodText)
                    .padding(.leading, 5)
                  Spacer()
                }
                .padding(.top, 5)
                Spacer()
              }
            }

            BalanceText(viewStore.balanceText)
              .padding(.top, 2.0)
          }
        } image: {
          Image(systemName: "info.circle")
            .foregroundColor(.primary)
            .onTapGesture { onFlip() }
        }
      }
    }

    private func menu(period: String) -> some View {
      Menu {
        Picker(
          selection: .constant(0),
          label: Text("Period")) {
            Text("Week").tag(0)
            Text("Month").tag(1)
            Text("Year").tag(2)
          }
      } label: {
        Text(period)
          .font(.footnote)
          .foregroundColor(Color("AH00"))
          .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
          .overlay(
            RoundedRectangle(cornerRadius: 20)
              .stroke(Color("AH00"), lineWidth: 1)
          )
      }
    }
  }

  struct Back: View {
    let store: Store<Overview.State, Overview.Action>
    let onFlip: () -> Void

    var body: some View {
      WithViewStore(store) { viewStore in
        Card {
          VStack {
            Spacer()
            Text(viewStore.account.introduction)
            Spacer()
            HStack {
              Spacer()
              Text("made with ❤️").font(.footnote)
            }
          }
        } image: {
          Image(systemName: "dollarsign.circle.fill")
            .foregroundColor(.primary)
        }
        .onTapGesture { onFlip() }
      }
    }
  }

  private func flip(_ flag: Bool) {
    withAnimation(.easeOut(duration: 0.35)) {
      flipped = flag
    }
  }
}

struct BalanceText: View {
  let balance: String
  init(_ balance: String) {
    self.balance = balance
  }
  var body: some View {
    Text(balance)
      .font(.largeTitle).fontWeight(.semibold)
      .gradient(LinearGradient(
        gradient: Gradient(colors: [.pink, .purple]),
        startPoint: .leading,
        endPoint: .trailing
      ))
  }
}

struct Card<Content: View, Image: View>: View {
  private let cornerRadius: CGFloat = 20

  private let content: Content
  private let image: Image

  init(@ViewBuilder content: () -> Content, @ViewBuilder image: () -> Image) {
    self.content = content()
    self.image = image()
  }

  var body: some View {
    ZStack(alignment: .topTrailing) {
      ZStack {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(LinearGradient(
            gradient: Gradient(colors: [Color("AH03"), Color("Blue60")]),
            startPoint: .top,
            endPoint: .bottom
          ))
          .cornerRadius(cornerRadius)

        content
          .padding()
      }

      image
        .padding(.top, 5)
        .padding()
    }
  }
}

#if DEBUG
struct Card_Previews: PreviewProvider {
  static var previews: some View {
    Card {
      Text("Card")
        .background(Color.red)
    } image: {
      Button {
        print("click")
      } label: {
        Image(systemName: "info.circle")
          .foregroundColor(.primary)
      }
      //.background(Color.green)
    }
    .frame(width: 300, height: 200, alignment: .center)
  }
}
#endif
