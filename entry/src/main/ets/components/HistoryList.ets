import { Message } from "./MessageList"

@Component
export struct HistoryList {
  @Prop historyList: HistoryInfo[]

  build() {
    List() {
      ForEach(this.historyList, (item: HistoryInfo) => {
        ListItem() {
          HistoryItem({
            info: item,
          })
        }
      }, (item: HistoryInfo) => item.id)
    }
    .width('100%')
    .divider({ strokeWidth: 0.5, color: '#EEE' })

  }
}

@Component
struct HistoryItem {
  @Prop info: HistoryInfo

  build() {
    Column() {
      // 时间与日期行
      Row() {
        Text(this.info.time)
          .fontSize(14)
          .fontColor('#666')

        Text(this.info.date)
          .fontSize(14)
          .fontColor('#666')

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('25%')
      Row() {
        Text(this.info.messages[0]?.content || '无记录内容')
            .fontSize(20)
            .fontColor('#333')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('70%')

        Image($r('app.media.more')).bindMenu([
          {
            value: '删除',
            action: () => {

            }
          }
        ]).width(20).height(20)
      }
      .width('100%').height('75%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .padding(4)
    .border({
      width: {
        bottom: 1
      },
      color: '#E8E8E8',
      style: BorderStyle.Solid
    })
    .height('13%')
    .width('100%')
  }

}

export class HistoryInfo {
  id: string;
  messages:Message[];
  time: string;       // 时间（HH:mm）
  date: string;       // 日期（YYYY-MM-DD）

  constructor(id:string,time:string,date:string,messages:Message[]) {
    this.id=id;
    this.time=time;
    this.date=date;
    this.messages=messages;
  }
}

