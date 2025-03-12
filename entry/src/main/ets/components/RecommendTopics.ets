import { RecommendItem } from "../model/Recommend"

@Component
export struct RecommendTopics{
  @Prop recommends: RecommendItem[]
  build() {
    Row(){
      Text('推荐')
      List(){
        ForEach(this.recommends, (item: RecommendItem) => {
          ListItem(){
            Row(){
              Button(item.content)
                .height(40)
                .margin(8)
                .onClick(() => this.navigateToSensePage(item.content));
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