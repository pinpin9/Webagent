import { HistoryList } from "../components/HistoryList"

@Component
export struct HistoryPage{
  build() {
    Column(){
      HistoryList()
    }
  }

}