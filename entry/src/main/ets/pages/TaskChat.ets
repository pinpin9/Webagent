// import { Message, MessageList } from '../components/MessageList';
import {AppConfig} from '../common/config'
import { webview } from '@kit.ArkWeb';
import { SpeechRecognizerManager } from '../components/SpeechRecognizer';
import { PermissionManager } from '../components/PermissionManager';
import { Permissions } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { ActionType } from '@kit.InputKit';

interface SubtaskItem {
  keywords: string[];
  action: string;
}

interface actionMap {
  click: string;
  type: string;
  select: string;
  search: string;
}

interface DOMElement {
  selector:string; // 可定位元素的CSS选择器
  display:string;// 展示给用户的文本
}
const permissions: Permissions[] = ["ohos.permission.MICROPHONE"]



@Component
export struct TaskChatPage {
  @State webUrl: string = 'https://www.bing.com'
  @State inputText: string = '';
  @State isRecognizing: boolean = false;
  @State subtasks: string[] = [];
  @State placeholder:string='请输入任务内容'
  private webController: webview.WebviewController = new webview.WebviewController()
  private speechRecognizerManager: SpeechRecognizerManager = new SpeechRecognizerManager();
  @State isProcessing: boolean = false;
  async aboutToAppear() {
    const params = router.getParams() as Record<string,string>;
    if (params?.categoryName) this.placeholder = `请输入你要完成的${params.categoryName}的任务`

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
        TextInput({ placeholder: this.placeholder, text: this.inputText })
          .onChange((value: string) => this.inputText = value)
          .margin({top:3})
          .borderRadius(4)
          .width('96%')
        Row() {
          Button(this.isRecognizing ? '识别中...' : '语音输入')
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent) => {
                  this.isRecognizing = true;
                  this.startSpeechRecognizer();
                })
                .onActionEnd((event: GestureEvent) => {
                  this.isRecognizing = false;
                  this.stopSpeechRecognizer();
                })
            )
            .backgroundColor(this.isRecognizing ? '#FF5722' : '#4CAF50')
            .width('40%')
            .enabled(!this.isProcessing);
          Button('发送任务')
            .onClick(() => {
              if (!this.isProcessing) { // 确保禁止重复点击
                this.runMainTask();
              }
            })
            .backgroundColor('#2196F3')
            .width('40%')
            .enabled(!this.isProcessing);
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .margin({top:4})
      }.height('15%')
      .justifyContent(FlexAlign.Center)
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
          this.inputText = result.result; // 处理语音识别到的结果
        })
      } catch (error) {
        console.error('语音识别失败:', error);
      }
    }

  }

  private async getSubTasksAPI(task: string): Promise<string[]> {
    try {
      const data = await http.createHttp().request(
        AppConfig.API_ENDPOINTS.sendTask,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json; charset=utf-8' },
          extraData: { "task": task }
        }
      );
      const subTasks= JSON.parse(data.result.toString())['actions'] as string[];
      console.log('子任务: '+subTasks);
      return subTasks;
    } catch (error) {
      console.error('获取子任务:', error);
      throw new Error('GET_SUBTASKS_ERROR');
    }
  }

  private async processSubtaskAPI(subtask: string): Promise<SubtaskItem[]> {
    try {

     const response= await http.createHttp().request(
        AppConfig.API_ENDPOINTS.sendSubTask,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json; charset=utf-8' },
          extraData: { "assign": subtask }
        }
      )
      console.log('传的子任务: '+response.result.toString());
      const steps = JSON.parse(response.result.toString())['data'] as SubtaskItem[];
      return steps;

    } catch (error) {
      console.error('处理子任务失败:', error);
      throw new Error('PROCESS_SUBTASK_ERROR');
    }
  }

  private async selectElementAPI(
    candidates: string,
  ): Promise<number> {
    try {
      console.log('待候选元素：'+candidates);
      const response = await http.createHttp().request(
        AppConfig.API_ENDPOINTS.getAction,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: { "elements": candidates}
        }
      );
      console.log(response.result.toString());
      const numberStr=JSON.parse(response.result.toString())['actions'] as string;

      const numberMatch = numberStr.match(/\[(\d+)\]/);;

      if (!numberMatch || numberMatch.length < 2) {
        throw new Error("未找到数字");
      }

      const number = parseInt(numberMatch[1]);
      return number;
    } catch (error) {
      console.error('元素选择失败:', error);
      throw new Error('FAILED_TO_SELECT_ELEMENT');
    }
  }

  private async runMainTask() {
    if (!this.inputText.trim()) return;
    try {
      this.isProcessing = true;
      // 1. 获取子任务列表
      this.subtasks = await this.getSubTasksAPI(this.inputText);
      console.log('子任务列表:', this.subtasks); // 调试日志

      if (!this.subtasks?.length) {
        console.error('未获取到有效子任务');
        return;
      }

      // 2. 处理第一个跳转任务
      const firstSubtask = this.subtasks[0];
      console.log('首个子任务:', firstSubtask);

      const urlMatch = firstSubtask.match(/.*Go to "(.*?)"/);
      if (urlMatch?.[1]) {
        const targetUrl = urlMatch[1];
        console.log('加载URL:', targetUrl);
        this.webController.loadUrl(targetUrl);
      } else {
        console.warn('首个子任务未包含URL:', firstSubtask);
      }

      // 3. 处理剩余子任务
      for (const subtask of this.subtasks.slice(1)) {
        await this.processSubtask(subtask);
      }
    } catch (error) {
      console.error('任务执行失败:', error);
    } finally {
      this.inputText = '';
      this.isProcessing = false;
    }
  }

  private async processSubtask(subtask: string) {
    // 获取子任务中的多个步骤
    const steps = await this.processSubtaskAPI(subtask);
    // 具体到每个步骤
    for (const step of steps) {
      const candidates = await this.searchElements(step.action, step.keywords); // 获取候选dom元素列表

      const candidateElementsString = candidates
        .map((candidate, index) => `[${index + 1}]<${candidate.display}>`) // 根据需求格式化每个候选元素
        .join('\n');
      const selectedId = await this.selectElementAPI(`candidate_elements:\n${candidateElementsString}`); // 从列表中获取要操作dom的元素
      await this.handleAction(step.action, selectedId,candidates); // 执行js操作
    }
  }

  /*
  * 查找匹配元素（核心逻辑）
  * @param action - 动作类型
  * @param keywords - 关键词数组
  * @returns 候选元素列表
  */
  private async searchElements(
    action: string,
    keywords: string[]
  ): Promise<DOMElement[]> {
    console.log(`[INFO] 搜索元素: ${action}, 关键词: ${JSON.stringify(keywords)}`);

    // 定义 selectorMap
    // 定义 selectorMap
    const selectorMap: Record<string, string> = {
      'click': 'button, a, [role="button"], input[type="button"], input[type="submit"]',
      'type': 'input[type="text"], input[type="search"], input[type="password"], textarea, [contenteditable="true"], input[placeholder*="搜索"], input[placeholder*="search"], .search-input, .searchInput, [role="search"] input',
      'search': 'input[type="text"], input[type="search"], input[type="password"], textarea, [contenteditable="true"], input[placeholder*="搜索"], input[placeholder*="search"], .search-input, .searchInput, [role="search"] input',
    };

    // 确保 action 存在于 selectorMap 中
    if (!selectorMap[action]) {
      console.warn(`[WARN] 未找到动作类型 "${action}" 的选择器映射`);
      return [];
    }

    // 构建调试用JS代码 - 简化日志输出
    const JsCode = `
    (function() {
      console.log('[JS] 扫描元素: ${selectorMap[action]}');

      // 获取初始元素
      const rawElements = Array.from(document.querySelectorAll('${selectorMap[action]}'));

      // 关键词处理
      const keywords = ${JSON.stringify(keywords)}.map(k => k.toLowerCase());

      // 过滤逻辑
      const filteredElements = rawElements.filter(element => {
        try {
          // 收集元素特征
          const features = [
            element.textContent?.toLowerCase() || '',
            element.placeholder?.toLowerCase() || '',
            element.getAttribute('aria-label')?.toLowerCase() || '',
            element.id.toLowerCase(),
            element.title?.toLowerCase() || '',
            element.name?.toLowerCase() || ''
          ].join('|');

          return keywords.some(kw => features.includes(kw));
        } catch (e) {
          return false;
        }
      });

      console.log('[JS] 找到匹配元素: ' + filteredElements.length);

      // 生成选择器
      const elementsWithSelector = filteredElements.map(element => {
        const selector = getCssSelector(element);
        return {
          selector: selector,
          display: element.tagName.toLowerCase() + ':' + (element.textContent?.trim().substring(0,30) || '无文本')
        };
      });

      // 增强版选择器生成
      function getCssSelector(el) {
        if (el.id) return '#' + el.id;

        const path = [];
        let currentEl = el;
        while (currentEl && currentEl !== document.body) {
          let selector = currentEl.tagName.toLowerCase();
          if (currentEl.id) {
            selector = '#' + currentEl.id;
            path.unshift(selector);
            break;
          } else {
            const siblings = Array.from(currentEl.parentNode.children);
            const index = siblings.indexOf(currentEl) + 1;
            selector += ':nth-child(' + index + ')';
          }
          path.unshift(selector);
          currentEl = currentEl.parentElement;
        }
        return path.join(' > ');
      }

      return JSON.stringify(elementsWithSelector);
    })()
    `;

    try {
      const rawElements = await this.webController.runJavaScript(JsCode);
      console.log('原始数据：'+rawElements);
      const parsedResult = JSON.parse(JSON.parse(rawElements)) as Array<DOMElement>;

      const finalResult = parsedResult
        .filter(item => !!item.selector)
        .map(item => ({
          selector: item.selector,
          display: item.display.replace(/[\n\r]/g, ' ')
        } as DOMElement));

      console.log(`[INFO] 搜索结果: 找到 ${finalResult.length} 个元素`);
      return finalResult;

    } catch (error) {
      console.error('[ERROR] 元素检索失败:', error instanceof Error ? error.message : error);
      return [];
    }
  }

  /*
  * 执行具体操作
  * @param actionType - 动作类型
  * @param selectedIndex - 选择的元素索引
  */
  private async handleAction(action: string, selectedIndex: number, currentCandidates:DOMElement[]) {
    // 查找对应元素
    const target = currentCandidates[selectedIndex-1];
    if (!target) {
      console.warn('未找到匹配元素:', selectedIndex);
      return;
    }

    // 构建操作脚本
    let script: string;
    switch (action) {
      case 'click':
        script = `document.querySelector('${target.selector}').click();`;
        break;
      case 'type':
        script = `
          const el = document.querySelector('${target.selector}');
          el.value = '自动输入内容';
          el.dispatchEvent(new Event('input', { bubbles: true }));
        `;
        break;
      default:
        console.warn('不支持的操作类型:', action);
        return;
    }
    // 执行操作
    try {
      await this.webController.runJavaScript(script);
      console.log('操作执行成功:', script);
    } catch (error) {
      console.error('操作执行失败:', error);
    }
  }
  
}