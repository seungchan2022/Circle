import Markdown
import SwiftUI

// MARK: - CodeBlockView

struct CodeBlockView {
  let parserResult: ParserResult
  @State var isCopied = false
}

extension CodeBlockView {
  private var backgroundThemeColor: Color {
    "262626".hexColor()
  }
}

// MARK: View

extension CodeBlockView: View {

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        // header
        if let codeBlockLanguage = parserResult.codeBlockLanguage {
          Text(codeBlockLanguage.capitalized)
            .font(.headline.monospaced())
            .foregroundStyle(.white)
        }

        Spacer()
        // button
        if isCopied {
          HStack {
            Text("Copied")
              .foregroundColor(.white)
              .font(.subheadline.monospaced().bold())
            Image(systemName: "checkmark.circle.fill")
              .imageScale(.large)
              .symbolRenderingMode(.multicolor)
          }
          .frame(alignment: .trailing)
        } else {
          Button {
            let string = NSAttributedString(parserResult.attributedString).string
            UIPasteboard.general.string = string
            withAnimation {
              isCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
              withAnimation {
                isCopied = false
              }
            }
          } label: {
            Image(systemName: "doc.on.doc")
          }
          .foregroundColor(.white)
        }
      }

      // 코드
      ScrollView(.horizontal, showsIndicators: true) {
        Text(parserResult.attributedString)
          .textSelection(.enabled)
      }
      .padding(8)
    }
    .background(backgroundThemeColor)
    .cornerRadius(8)
  }
}
