import { NavItemConfig, MainPage, NavItems } from '../model/NavigationTypes';

@Component
export struct BottomNavBar {
  @Link currentPage: MainPage;

  build() {
    Row() {
      ForEach(NavItems, (item: NavItemConfig) => {
        this.NavButton(item)
      })
    }
    .height(60)
    .width('100%')
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceAround)
  }

  @Builder
  private NavButton(item: NavItemConfig) {
    Column() {
      Image(item.icon)
        .width(25)
        .height(25)
        .opacity(this.currentPage === item.pageName ? 1 : 0.5)
      Text(item.text)
        .fontSize(18)
        .fontColor(this.currentPage === item.pageName ? Color.Orange : Color.Gray)
    }
    .onClick(() => this.currentPage = item.pageName)
  }
}