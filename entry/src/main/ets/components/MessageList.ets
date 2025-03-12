@Component
export struct MessageList {
  @Prop messages: Message[]

  build() {
    List({ space: 12 }) {
      ForEach(this.messages, (msg: Message) => {
        ListItem() {
          MessageBubble({ message: msg })
        }
      }, (msg:Message) => msg.timestamp.getTime().toString())
    }
    .layoutWeight(1)
    .width('100%')
    .alignListItem(ListItemAlign.Center)
  }
}

@Component
struct MessageBubble {
  @Prop message: Message

  build() {
    Column() {
      Text(this.message.content)
        .padding(10)
        .backgroundColor('#E3F2FD')
        .borderRadius(8)
        .fontSize(18)

      Text(this.message.timestamp.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12:false
      }))
      .fontSize(12)
      .fontColor('#666666')
    }
    .width('95%')
    .alignItems(this.messageAlignment())
  }

  private messageAlignment(): HorizontalAlign {
    return this.message.sender === "user"
      ? HorizontalAlign.End
      : HorizontalAlign.Start
  }
}

export class Message {
  content: string
  sender: 'user' | 'agent'
  timestamp: Date

  constructor(content: string, sender: 'user' | 'agent', timestamp: Date) {
    this.content = content
    this.sender = sender
    this.timestamp = timestamp
  }
}
