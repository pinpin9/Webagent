import { Tabulate } from "../model/Tabulate"

@Component
export struct TabulateChoice{
  @StorageLink('currentPage') currentPage:string =''
  @Prop tabulates:Tabulate[]
  build() {
    List(){
      ForEach(this.tabulates, (item: Tabulate)=>{
          ListItem(){
            this.TabulateItem(item)
          }
        }
      )
    }
  }

  @Builder
  private TabulateItem(tabulate:Tabulate){
    Row()
    {
      Image(tabulate.icon)
        .width(40)
        .height(40)
        .margin(10)
      Text(tabulate.text)
        .fontSize(20)
    }
    .onClick(()=>this.currentPage = tabulate.name)
  }

}

