import { DefaultCategories,Category } from '../model/Category';
import {CategoryGrid}from '../components/CategoryGrid'
import { TabulateChoice } from '../components/TabulateChoice';
import { DefaultTabulate } from '../model/Tabulate';
import { MainPage } from '../model/NavigationTypes';

@Component
export struct HomePage{
  @Link currentPage: MainPage

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
    }
  }
}