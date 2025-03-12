import { DefaultCategories,Category } from '../model/Category';
import {CategoryGrid}from '../components/CategoryGrid'
import { TabulateChoice } from '../components/TabulateChoice';
import { DefaultTabulate } from '../model/Tabulate';
import { Page } from '../model/NavigationTypes';
import { RecommendTopics } from '../components/RecommendTopics';
import { DefaultRecommends } from '../model/Recommend';

@Component
export struct HomePage{
  @Link currentPage: Page

  build() {
    Column(){
      //分类网格
      CategoryGrid({
        categories: DefaultCategories,
      }).margin({ bottom: 12 })

      // 选项列表
      TabulateChoice({
        tabulates: DefaultTabulate,
        currentPage: this.currentPage
      }).margin({ bottom: 12 })

      Row(){
          RecommendTopics({
            recommends: DefaultRecommends
          })
      }
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)

      // .position({bottom:0}) // 确保固定在底部
      // .margin({ bottom: 12 })
    }
  }
}