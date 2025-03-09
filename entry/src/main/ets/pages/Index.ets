@Entry
@Component
struct SettingsPage {
  @State voiceAssistantEnabled: boolean = false;

  build() {
    Column() {
      // 顶部菜单
      Column() {
        Row()
        {
          Row()
          {
            Image($r("app.media.voice_assistant_icon"))
              .width(30)
              .height(30)
              .margin({ right: 30 , left: 20})

            Text("语音助手")
              .fontSize(24)

          }
          .alignItems(VerticalAlign.Center)

          Toggle({ type: ToggleType.Switch, isOn: this.voiceAssistantEnabled })
            .onChange((value: boolean) => {
              this.voiceAssistantEnabled = value;
            })
            .margin({right: 20})
        }
        .width("100%")
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        // 历史记录
        Row()
        {
          Row()
          {
            Image($r("app.media.history_icon"))
              .width(30)
              .height(30)
              .margin({ right: 30 , left: 20})

            Text("历史记录")
              .fontSize(24)

          }
          .alignItems(VerticalAlign.Center)
        }
        .width("100%")
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        // 历史记录
        Row()
        {
          Row()
          {
            Image($r("app.media.settings_icon"))
              .width(30)
              .height(30)
              .margin({ right: 30 , left: 20})

            Text("设置")
              .fontSize(24)

          }
          .alignItems(VerticalAlign.Center)
        }
        .width("100%")
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height('90%')

      // 底部导航栏
      Row() {
        Column() {
          Image($r("app.media.sense_icon")) // 确保图片资源路径正确
            .width(25)
            .height(25)
          Text("感知")
            .fontSize(18)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式

        Column() {
          Image($r("app.media.home_icon")) // 确保图片资源路径正确
            .width(25)
            .height(25)
          Text("主页")
            .fontSize(18)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式

        Column() {
          Image($r("app.media.settings_icon")) // 确保图片资源路径正确
            .width(25)
            .height(25)
          Text("设置")
            .fontSize(18)
            .fontColor(Color.Orange)
        }
        .alignItems(HorizontalAlign.Center) // 设置水平对齐方式
      }
      // .space(30) // 设置子组件间距
      .alignItems(VerticalAlign.Center) // 设置垂直对齐方式
      .justifyContent(FlexAlign.SpaceAround) // 设置主轴对齐方式
      .backgroundColor(Color.White) // 设置背景颜色
      .height('10%') // 设置高度
      .width('100%') // 设置宽度
    }
    .backgroundColor(Color.White) // 设置背景颜色
    .width('100%') // 设置宽度
    .height('100%') // 设置高度
  }
}