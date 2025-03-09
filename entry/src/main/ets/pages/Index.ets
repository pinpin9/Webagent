import { BottomNavBar } from '../components/BottomNavBar';
import { MainPage } from '../model/NavigationTypes';
import { TaskChatPage } from './TaskChat'

@Entry
@Component
export struct MainNavigation {
  @State currentPage: MainPage = 'sense';

  build() {
    Column() {
      Navigation() {
          this.CurrentPage()
          BottomNavBar({ currentPage: $currentPage })
            .width('100%')
            .height(60)
      }
      .title('智能助手')
      .titleMode(NavigationTitleMode.Mini)
      .navBarPosition(NavBarPosition.Start) // 标题栏置顶
      .mode(NavigationMode.Stack) // 堆栈导航模式
      .hideBackButton(true)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private CurrentPage() {
    if (this.currentPage === 'home') {

    } else if (this.currentPage === 'sense') {
      TaskChatPage().layoutWeight(1)
    } else {

    }
  }
}


