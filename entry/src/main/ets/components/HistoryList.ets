import { Message } from "./MessageList"

@Component
export struct HistoryList {
  @Prop historyList: HistoryInfo[] = [
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
  @State private isPressed: boolean = false


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

      // 消息预览
      Text(this.info.messages[0]?.content || '无记录内容')
        .fontSize(16)
        .fontColor('#333')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 12 })
        .width('100%')
    }
    .padding(4)
    .border({
      width: {
        top: 1,
        right: 1,
        bottom: 1,
        left: 1
      },
      color: '#E8E8E8',
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: 'rgba(0,0,0,0.2)',
      offsetX: 2,
      offsetY: 2
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

