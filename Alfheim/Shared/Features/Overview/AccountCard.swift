//
//  AccountCard.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/19.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AccountCard: View {
  let store: Store<AppState.Overview, AppAction.Overview>

  @State private var flipped: Bool = false
  private let cornerRadius: CGFloat = 20

  var body: some View {
    WithViewStore(store) { viewStore in
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
  }

  struct Front: View {
    let store: Store<AppState.Overview, AppAction.Overview>
    let onFlip: () -> Void

    var body: some View {
      WithViewStore(store) { viewStore in
        Card(
          content: {
            ZStack {
              HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                  Button {
                  } label: {
                    Text("Alfheim")
                  }
                  Spacer()
                }
                Spacer()
              }

              Text(viewStore.amountText)
                .font(.largeTitle).fontWeight(.semibold)
                .gradient(LinearGradient(
                  gradient: Gradient(colors: [.pink, .purple]),
                  startPoint: .leading,
                  endPoint: .trailing
                ))
                .padding(.top, 2.0)
            }

          },
          image: {
            Button {
              self.onFlip()
            } label: {
              Image(systemName: "info.circle")
                .foregroundColor(.primary)
            }
          })
      }
    }
  }

  struct Back: View {
    let store: Store<AppState.Overview, AppAction.Overview>
    let onFlip: () -> Void

    var body: some View {
      WithViewStore(store) { viewStore in
        Card(
          content: {
            VStack {
              Spacer()
              Text(viewStore.account.introduction)
              Spacer()
              HStack {
                Spacer()
                Text("made with ❤️").font(.footnote)
              }
            }
          },
          image: {
            Image(systemName: "dollarsign.circle.fill")
              .foregroundColor(.primary)
          })
          .onTapGesture { onFlip() }
      }
    }
  }

  private func flip(_ flag: Bool) {
    withAnimation(.easeOut(duration: 0.35)) {
      flipped = flag
    }
  }

  private struct Card<Content: View, Image: View>: View {
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
}

//#if DEBUG
//struct AccountCard_Previews: PreviewProvider {
//  static var previews: some View {
//    AccountCard()
//      .environment(\.colorScheme, .dark)
//      .environmentObject(AppStore(moc: viewContext))
//  }
//}
//#endif
