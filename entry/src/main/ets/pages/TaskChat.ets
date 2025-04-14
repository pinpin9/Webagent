// import { Message, MessageList } from '../components/MessageList';
import webSocket from '@ohos.net.webSocket';
import { AppConfig } from '../common/config';
import { webview } from '@kit.ArkWeb';
import { SpeechRecognizerManager } from '../components/SpeechRecognizer'
import { PermissionManager } from '../components/PermissionManager';
import { Permissions } from '@kit.AbilityKit';


interface WebPage {
  url: string;
  domTree: string;
  elements: Array<object>;
}

interface WebSocketMessage {
  type: string;
  data: WebPage|string;
}

const permissions: Permissions[] = ["ohos.permission.MICROPHONE"]

@Component
export struct TaskChatPage {

  private webController: webview.WebviewController = new webview.WebviewController()
  private wsClient: webSocket.WebSocket = webSocket.createWebSocket()
  private speechRecognizerManager:SpeechRecognizerManager=new SpeechRecognizerManager();
  @State webUrl: string ='https://www.bing.com'
  @State showWebView: boolean = true
  @State inputText: string ='';
  @State isRecognizing: boolean = false;

  async aboutToAppear() {
    this.initWebSocket()
    try {
      await this.speechRecognizerManager.intiEngine(); // 修正可能的拼写错误
    } catch (error) {
      console.error('引擎初始化失败:', error);
    }
  }
  aboutToDisappear() {

  }
  build() {
    Column() {
      Web({
        src: this.webUrl,
        controller: this.webController
      })
      .javaScriptAccess(true)
      .height('85%')
      .width('100%')

      // MessageList({ messages: this.messages })

      Column() {
        TextInput({ placeholder: '输入任务', text: this.inputText })
          .onChange((value: string) => this.inputText = value)
          .padding(12)

          Row() {
            // 新增语音按钮
            Button(this.isRecognizing ? '识别中...' : '语音输入')
              .gesture(
                LongPressGesture({ repeat: false })
                  .onAction((event: GestureEvent) => {
                    this.isRecognizing=true;
                    this.startSpeechRecognizer();
                  })
                    // 长按动作一结束触发
                  .onActionEnd((event: GestureEvent) => {
                    this.isRecognizing=false;
                    this.stopSpeechRecognizer();
                  })
              )
              .backgroundColor(this.isRecognizing ? '#FF5722' : '#4CAF50')
              .width('40%')

            Button('发送任务')
              .onClick(() => this.sendTask())
              .backgroundColor('#2196F3')
              .width('40%')
          }
          .justifyContent(FlexAlign.SpaceAround)
          .width('100%')
      }.height('13%')
    }
  }

  private stopSpeechRecognizer() {
    this.speechRecognizerManager.stop();
  }

  private startSpeechRecognizer(){
      // 检查是否拥有权限
      const isPermission =  PermissionManager.checkPermission(permissions)
      if (!isPermission) { //   如果没权限，就主动申请
        PermissionManager.requestPermission(permissions)
      }else {
        try {
          this.speechRecognizerManager.start((result) => {
            console.debug(result.result)
            console.debug('2222')
            this.inputText=result.result;     // 处理语音识别到的结果
          })
        } catch (error) {
          console.error('语音识别失败:', error);
        }
      }

  }

  private initWebSocket() {
    this.wsClient.connect(AppConfig.API_ENDPOINTS.sendTask)
  }

  private async sendTask() {
    if (!this.inputText.trim()) return;

    const pageData=await this.collectPageData()

    try {
      this.sendMessage({
        type: 'task_update',
        data: pageData
      });
      this.inputText = '';
    } catch (error) {
      console.error('发送任务失败:', error);
    }
    // await this.handleAction(jsAction);
  }

  private async collectPageData ():Promise<WebPage> {
    const dom = await this.webController.runJavaScript(`
      document.documentElement.outerHTML
        .replace(/\\s+/g, ' ')
        .replace(/<!--.*?-->/g, '')
    `)

    const elements = await this.webController.runJavaScript(`
      JSON.stringify(
        Array.from(document.querySelectorAll('a,button,input'))
          .map(el => ({
            id: el.id,
            tag: el.tagName,
            bounds: el.getBoundingClientRect().toJSON()
          }))
      )
    `)

    return {
      url:  this.webController.getUrl(),
      domTree: dom,
      elements: JSON.parse(elements)
    }
  }

  // private setupAutoUpdate() {
  //   this.webController.runJavaScript(`
  //     new MutationObserver(() => {
  //       window.updatePageData()
  //     }).observe(document, {
  //       subtree: true,
  //       childList: true,
  //       attributes: true
  //     })
  //   `)
  // }

  private sendMessage(message: WebSocketMessage) {
    try {
      this.wsClient.send(JSON.stringify(message));
    } catch (error) {
      console.error('发送消息失败:', error,message);
    }
  }

  private async handleAction(script: string) {
    try {
      const result = await this.webController.runJavaScript(script);
      console.info('执行 JS 操作结果:', result);
    } catch (error) {
      console.error('执行JS失败:', error);
    }
  }

}