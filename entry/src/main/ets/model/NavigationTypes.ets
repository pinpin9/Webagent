export type Page = 'home' | 'sense' | 'settings' | 'instruction' | 'history';

export interface NavItemConfig {
  icon: Resource;
  text: string;
  pageName: Page;
}

export const NavItems: NavItemConfig[] = [
  { icon: $r("app.media.sense_icon"), text: "感知", pageName: 'sense' },
  { icon: $r("app.media.home_icon"), text: "主页", pageName: 'home' },
  { icon: $r("app.media.settings_icon"), text: "设置", pageName: 'settings' }
];