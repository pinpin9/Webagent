import { HistoryInfo, HistoryList } from "../components/HistoryList"
import { Message } from "../components/MessageList"

@Component
export struct HistoryPage{
  @State historyList: HistoryInfo[] = [
    new HistoryInfo(
      '1',
      '14:30',
      '2023-07-20',
      [
        new Message('请帮我搜索如何做一份大餐', 'user', new Date())
      ]
    ),
    new HistoryInfo(
      '2',
      '14:30',
      '2023-07-20',
      [
        new Message('请帮我搜索如何做一份大餐', 'user', new Date())
      ]
    ),
    new HistoryInfo(
      '3',
      '14:30',
      '2023-07-20',
      [
        new Message('请帮我搜索如何做一份大餐', 'user', new Date())
      ]
    )
  ]
  build() {
    Column(){
      Column(){
        SymbolGlyph($r('sys.symbol.trash')).onClick(
          ()=>{ this.historyList=[] }
        ).fontSize(25)
      }.width('100%')
      .alignItems(HorizontalAlign.End)
      .margin({bottom:8})

      HistoryList({historyList:this.historyList})
    }
  }

}