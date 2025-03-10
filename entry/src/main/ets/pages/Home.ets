import { DefaultCategories,Category } from '../model/Category';
import {CategoryGrid}from '../components/CategoryGrid'

@Component
export struct HomePage{
  build() {
    Column(){
      //分类网格
      CategoryGrid({
        categories: DefaultCategories,
      }).margin({ bottom: 12 })
    }
  }
}