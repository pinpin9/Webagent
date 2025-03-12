import { RecommendItem } from "../model/Recommend"


@Component
export struct RecommendTopics{
  @Prop recommends: RecommendItem[]
  @StorageLink('currentPage') currentPage:string=''
  build() {
    Row(){
      Column(){
        Text('推荐')
          .fontColor('#FAFAFA')
      }
      .backgroundColor('#F2BA02')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .opacity(0.7)
      .height('80%')
      .width(60)
      .borderRadius(15)
      .margin({left: 10})

      List(){
        ForEach(this.recommends, (item: RecommendItem) => {
          ListItem(){
            Row(){
              Button(item.content)
                .height(40)
                .margin(8)
                .backgroundColor('#4874CB')
                .opacity(0.8)
                .onClick(() => this.currentPage = 'sense');
            }
          }
        });
      }.listDirection(Axis.Horizontal)
    }
    .width('100%')
    .height(50)
    .alignItems(VerticalAlign.Center)
  }

  private navigateToSensePage(content: string){

  }
}