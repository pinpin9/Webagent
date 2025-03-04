@Entry
@Component
struct SettingsPage {
  @State voiceAssistantEnabled: boolean = false;

  build() {
    Column() {
      // 顶部菜单
      Column() {
        // 语音助手
        Row() {
          Image($r("app.media.voice_assistant_icon")) // 确保图片资源路径正确
            .width(30)
            .height(30)
          Text("语音助手")
            .fontSize(20)
          Toggle({ type: ToggleType.Switch, isOn: this.voiceAssistantEnabled })
            .onChange((value: boolean) => {
              this.voiceAssistantEnabled = value;
            })
        }
        // .space(10) // 设置子组件间距
        .justifyContent(FlexAlign.Start) // 图标靠左
        // .alignItems(VerticalAlign.Center) // 设置垂直对齐方式
        .padding(15) // 设置内边距

        // 历史记录
        Row() {
          // Image($r("app.media.history_icon")) // 确保图片资源路径正确
          //   .width(30)
          //   .height(30)
          Text("历史记录")
            .fontSize(20)
        }
        // .space(10) // 设置子组件间距
        .alignItems(VerticalAlign.Center) // 设置垂直对齐方式
        .padding(15) // 设置内边距

        // 设置
        Row() {
          // Image($r("app.media.settings_icon")) // 确保图片资源路径正确
          //   .width(30)
          //   .height(30)
          Text("设置")
            .fontSize(20)
        }
        // .space(10) // 设置子组件间距
        .alignItems(VerticalAlign.Center) // 设置垂直对齐方式
        .padding(15) // 设置内边距
      }
      .width('100%')
      .height('85%')

      // 底部导航栏
      Row() {
        Column() {
          // Image($r("app.media.sense_icon")) // 确保图片资源路径正确
          //   .width(25)
          //   .height(25)
          Text("感知")
            .fontSize(14)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式

        Column() {
          // Image($r("app.media.home_icon")) // 确保图片资源路径正确
          //   .width(25)
          //   .height(25)
          Text("主页")
            .fontSize(14)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式

        Column() {
          // Image($r("app.media.settings_icon")) // 确保图片资源路径正确
          //   .width(25)
          //   .height(25)
          Text("设置")
            .fontSize(14)
            .fontColor(Color.Orange)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式
      }
      // .space(30) // 设置子组件间距
      .alignItems(VerticalAlign.Center) // 设置垂直对齐方式
      .justifyContent(FlexAlign.SpaceAround) // 设置主轴对齐方式
      .backgroundColor(Color.White) // 设置背景颜色
      .height(60) // 设置高度
      .width('100%') // 设置宽度
    }
    .backgroundColor(Color.White) // 设置背景颜色
    .width('100%') // 设置宽度
    .height('100%') // 设置高度
  }
}