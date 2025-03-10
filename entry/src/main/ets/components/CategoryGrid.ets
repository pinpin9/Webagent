import {CategoryModel} from '../model/Category'

@Component
export struct CategoryItem {
  @Prop category: CategoryModel      // 接收模型数据

  build() {
    Column() {
      Image(this.category.icon)      // 使用模型中的图标
        .width(48)
        .height(48)
        .margin({ bottom: 8 })

      Text(this.category.name)       // 使用模型中的名称
        .fontSize(14)
        .fontColor('#333333')
    }
    .width('100%')
    .height(120)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}

@Component
export struct CategoryGrid {
  @Prop categories: CategoryModel[]  // 正确定义Prop类型

  build() {
    Grid() {
      ForEach(this.categories, (item: CategoryModel) => {
        GridItem() {
          CategoryItem({
            category: item,          // 传递模型数据
          })
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .columnsGap(16)
    .rowsGap(16)
    .padding(24)
    .width('100%')
  }
}