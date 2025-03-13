@Entry
@Component
export struct SettingsPage {
  @State language: string = '中文'; // 当前选择的语言
  @State browser: string = '系统默认'; // 当前选择的浏览器

  // 语言选项
  private languageOptions: string[] = ['中文', '英文'];

  // 浏览器选项
  private browserOptions: string[] = ['系统默认', 'Chrome', 'Firefox'];

  build() {
    Column() {
      // 标题
      Text('设置')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.Start)
        .margin({ top: 10, bottom: 20 });

      // 语言偏好设置
      Row(){
        Text('语言偏好')
          .fontSize(18)
          .margin({ top: 10, bottom: 10, left:10 });

        TextPicker({ range: this.languageOptions, value: this.language })
          .onChange((value: string | string[], index: number | number[]) => {
            if (typeof value === 'string') {
              this.language = value; // 更新选择的语言
            }
          })
          .width('80%')
          .height(40)
          .margin(5);
      }
      .borderRadius(5)
      .width('100%')
      .backgroundColor(Color.White)

      // 默认浏览器设置
      Row(){
        Text('默认浏览器')
          .fontSize(18)
          .margin({ top: 10, bottom: 10, left:10 });

        TextPicker({ range: this.browserOptions, value: this.browser })
          .onChange((value: string | string[], index: number | number[]) => {
            if (typeof value === 'string') {
              this.browser = value; // 更新选择的浏览器
            }
          })
          .width('80%')
          .height(40)
          .margin(5);
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(5)

      // 保存按钮
      Button('保存设置')
        .onClick(() => {
          this.saveSettings();
        })
        .width('80%')
        .height(40)
        .backgroundColor('#2196F3')
        .fontColor(Color.White)
        .margin({ top: 20 });
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f2f4f5');
  }

  // 保存设置
  saveSettings() {
    console.log('保存设置：');
    console.log('语言偏好：', this.language);
    console.log('默认浏览器：', this.browser);
    // 这里可以添加保存设置的逻辑，例如将设置保存到本地存储或发送到服务器
  }
}