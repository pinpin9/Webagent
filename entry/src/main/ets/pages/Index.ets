import { BottomNavBar } from '../components/BottomNavBar';
import { TaskChatPage } from './TaskChat'
import { HomePage} from './Home'
import { HistoryPage } from './History';
import { SettingsPage } from './Settings';

@Entry
@Component
struct MainNavigation {
  @StorageLink('currentPage') currentPage:string ='home'

  @Provide pageStack: NavPathStack = new NavPathStack()

  build() {
      Navigation(this.pageStack) {
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
      .width('100%')
      .height('100%')
  }

  @Builder
  private CurrentPage() {
    if (this.currentPage === 'home') {
      HomePage().layoutWeight(1)
    } else if (this.currentPage === 'sense') {
      TaskChatPage().layoutWeight(1)
    } else if (this.currentPage === 'history') { // 历史记录
      HistoryPage().layoutWeight(1)
    } else if (this.currentPage === 'instruction') { // 常用指令
      SettingsPage().layoutWeight(1)
    } else { // 设置
      SettingsPage().layoutWeight(1)
    }
  }
}


