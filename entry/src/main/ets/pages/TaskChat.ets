import { Message, MessageList } from '../components/MessageList';


@Component
export struct TaskChatPage {
  onPageShow(): void {

  }

  @State inputText: string = ''
  @State messages: Message[] = []

  build() {
    Column() {
      MessageList({messages:this.messages})

      // 输入区域
      Column() {
        TextInput({ placeholder: '输入想完成的任务',text:this.inputText })
          .onChange((value: string) => {
            this.inputText = value
          })
          .cancelButton({
            style:CancelButtonStyle.INPUT
          })
          .padding(12)
          .backgroundColor(Color.White)

        Row() {
          Button('语音输入')
            .onClick(this.startVoiceInput)
            .backgroundColor('#4CAF50')

          Button('发送')
            .onClick(this.handleSend)
            .backgroundColor('#2196F3')
        }
        .margin({top:5})
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
      }
      .padding(12)
      .backgroundColor('#F5F5F5')
    }
  }

  /** 目前是模拟，后续需要修改**/
  private handleSend = () => {
    if (this.inputText.trim()) {
      const currentInput = this.inputText
      this.inputText = ''
      //添加用户消息
      this.messages = [...this.messages,
        new Message(currentInput, 'user', new Date())]

      // 延迟1秒添加Agent回复
      setTimeout(() => {
        this.messages = [...this.messages,
          new Message(`正在处理：${currentInput}`, 'agent', new Date())]
      }, 1000)
    }
  }

  private startVoiceInput = () => {

    this.inputText = '模拟语音输入结果'
  }
}

