// import { Message, MessageList } from '../components/MessageList';

import { webview } from '@kit.ArkWeb';
import { SpeechRecognizerManager } from '../components/SpeechRecognizer';
import { PermissionManager } from '../components/PermissionManager';
import { Permissions } from '@kit.AbilityKit';


interface SubtaskResponse {
  action: 'click' | 'type' | 'select' | 'search';
  keywords: string[];
}

const permissions: Permissions[] = ["ohos.permission.MICROPHONE"]

@Component
export struct TaskChatPage {
  @State webUrl: string = 'https://www.bing.com'
  @State showWebView: boolean = true
  @State inputText: string = '';
  @State isRecognizing: boolean = false;
  @State subtasks: string[] = [];
  private webController: webview.WebviewController = new webview.WebviewController()
  private speechRecognizerManager: SpeechRecognizerManager = new SpeechRecognizerManager();

  async aboutToAppear() {
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
                  this.isRecognizing = true;
                  this.startSpeechRecognizer();
                })// 长按动作一结束触发
                .onActionEnd((event: GestureEvent) => {
                  this.isRecognizing = false;
                  this.stopSpeechRecognizer();
                })
            )
            .backgroundColor(this.isRecognizing ? '#FF5722' : '#4CAF50')
            .width('40%')

          Button('发送任务')
            .onClick(() => this.sendMainTask())
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

  private startSpeechRecognizer() {
    // 检查是否拥有权限
    const isPermission = PermissionManager.checkPermission(permissions)
    if (!isPermission) { //   如果没权限，就主动申请
      PermissionManager.requestPermission(permissions)
    } else {
      try {
        this.speechRecognizerManager.start((result) => {
          console.debug(result.result)
          console.debug('2222')
          this.inputText = result.result; // 处理语音识别到的结果
        })
      } catch (error) {
        console.error('语音识别失败:', error);
      }
    }

  }

  private async createMainTaskAPI(Task: string): Promise<string[]> {
    return [];
  }

  private async processSubtaskAPI(arg0: string): Promise<SubtaskResponse> {
    const response: SubtaskResponse = {
      action: 'click',
      keywords: ['2']
    };

    return response;
  }

  private async selectElementAPI(
    candidates: string,
    action: string,
    keywords: string[]
  ): Promise<string> {
    try {
      return '';
    } catch (error) {
      console.error('元素选择失败:', error);
      throw new Error('FAILED_TO_SELECT_ELEMENT');
    }

  }

  private async sendMainTask() {
    if (!this.inputText.trim()) {
      return;
    }
    try {
      this.subtasks = await this.createMainTaskAPI(this.inputText);
    } catch (error) {
      console.error('主任务处理失败:', error);
    }
    this.inputText = '';
    //开始执行第一个子任务
    await this.processSubtask(0);
  }

  private async processSubtask(index: number) {
      if (index >= this.subtasks.length) {
        return;
      }
      //获取动作类型和关键词
      const response = await this.processSubtaskAPI(this.subtasks[index]);
      // 元素搜索
      const candidates = await this.searchElements(response.action, response.keywords);
      //获取选中的元素
      const selectedId = await this.selectElementAPI(candidates, response.action, response.keywords);
      // 执行操作
      await this.handleAction(selectedId);
      //执行下一个子任务
      await this.processSubtask(index + 1);

  }

  private async searchElements(action: "click" | "type" | "select" | "search", keywords: string[]): Promise<string> {
    const jsCode = `
      (function() {
        // 保持原有选择器逻辑不变
        const selectorMap = {
          click: 'button, a, [role="button"], [type="submit"], [type="button"], [onclick], [class*="btn"]',
          type: 'input:not([type="submit"]):not([type="button"]):not([type="checkbox"]):not([type="radio"]), textarea, [contenteditable="true"]',
          select: 'select, [role="listbox"], [role="combobox"], input[type="checkbox"], input[type="radio"]',
          search: 'input[type="search"], input[name*="search"], input[placeholder*="search"], input[id*="search"], input[class*="search"]'
        };

        // 保持原有筛选逻辑
        const keywords = ${JSON.stringify(keywords)}.map(k => k.toLowerCase());
        const elements = Array.from(document.querySelectorAll(selectorMap["${action}"]))
          .filter(element => {
            const content = [
              element.textContent?.toLowerCase(),
              (element.value || '').toLowerCase(),
              element.placeholder?.toLowerCase(),
              element.getAttribute('aria-label')?.toLowerCase(),
              element.title?.toLowerCase(),
              element.id.toLowerCase(),
              element.getAttribute('name')?.toLowerCase()
            ].join('|');

            return keywords.some(kw => content.includes(kw));
          });

        if (elements.length === 0) {
          return '未找到匹配元素';
        }

        // 生成规范化的输出格式
        const results = elements.map((element, index) => {

          const rawText = element.textContent?.trim() || '';
          const displayText = rawText.substring(0, 30) + (rawText.length > 30 ? '...' : '');

          // 构建规范格式
          return \`[\${index + 1}]<\${element.tagName.toLowerCase()} \${displayText.replace(/\\//g, '')}/>\`;
        });

        return \`candidate_elements:\\n\${results.join('\\n')}\`;

      })();
     `;
    return await this.webController.runJavaScript(jsCode)
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