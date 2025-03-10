import { Category } from '../model/Category'

@Component
export struct CategoryItem {
  @Prop category: Category
  @State isHover: boolean = false

  build() {
    Column() {
      Image(this.category.icon)
        .width('50%')
        .height('50%')
        .margin({bottom:5})

      Text(this.category.name)
        .fontSize(14)
        .fontColor('#333333')
    }
    .width('86%')
    .height('86%')
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .justifyContent(FlexAlign.Center)
    .shadow(this.isHover ? {
      radius: 8,
      color: '#90CAF9',
      offsetX: 2,
      offsetY: 2
    } : undefined)
    .onHover(v => this.isHover = v)
  }
}

@Component
export struct CategoryGrid {
  @Prop categories: Category[]

  build() {
    Grid() {
      // 添加id参数作为唯一标识
      ForEach(this.categories,
        (item: Category) => {
          GridItem() {
            CategoryItem({ category: item })
          }
        },
        (item: Category) => item.id,
      )
    }
    .columnsTemplate('1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .columnsGap(5)
    .rowsGap(5)
    .padding(5)
    .width('100%')
    .height('40%')
    .backgroundColor('#E3F2FD')
  }
}