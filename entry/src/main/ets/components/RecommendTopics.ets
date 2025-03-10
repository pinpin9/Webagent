import { RecommendItem } from "../model/Recommend"

@Component
export struct RecommendTopics{
  @Prop recommends: RecommendItem[]
  build() {
    Column(){
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
  }

  private navigateToSensePage(content: string){

  }
}