import { Category } from '../model/Category'

@Component
export struct CategoryGrid {
  @Prop categories: Category[]
  @State hoveredId: string | null = null

  build() {
    Grid() {
      ForEach(this.categories,
        (item: Category) => {
          GridItem() {
            CategoryItem({item:item})
          }
        },
        (item: Category) => item.id
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

@Component
struct CategoryItem {
  @Prop item: Category
  @State private isHovered: boolean = false

  build() {
    Column() {
      Image(this.item.icon)
        .width('50%')
        .height('50%')
        .margin({ bottom: 5 })
        .interpolation(ImageInterpolation.High) // 开启高质量缩放

      Text(this.item.name)
        .fontSize(14)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
    }
    .width('86%')
    .height('86%')
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .justifyContent(FlexAlign.Center)
    .onHover((isHover: boolean) => {
      this.isHovered = isHover
    })
    .shadow(this.isHovered ? {
      radius: 8,
      color: '#90CAF9',
      offsetX: 2,
      offsetY: 2
    } : undefined)
  }
}