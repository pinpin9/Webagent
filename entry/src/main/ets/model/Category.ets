export interface CategoryModel {
  id: string;
  name: string;
  icon: Resource;
}

export const DefaultCategories: CategoryModel[] = [
  {
    id: 'shopping',
    name: '购物',
    icon: $r('app.media.ic_shopping')
  },
  {
    id: 'travel',
    name: '出行',
    icon: $r('app.media.ic_trans')
  },
  {
    id: 'ticket',
    name: '订票',
    icon: $r('app.media.ic_ticket')
  },
  {
    id: 'search',
    name: '搜索',
    icon: $r('app.media.ic_search')
  },
  {
    id: 'office',
    name: '办公',
    icon: $r('app.media.ic_office')
  },
  {
    id: 'study',
    name: '学习',
    icon: $r('app.media.ic_study')
  }
];