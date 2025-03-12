import { Page } from "./NavigationTypes";

export interface Tabulate{
  name: Page;
  text: string;
  icon: Resource;
}

export const DefaultTabulate: Tabulate[] = [
  {
    name: "history",
    text: "历史记录",
    icon: $r('app.media.ic_history')
  },
  {
    name: "instruction",
    text: "常用指令",
    icon: $r('app.media.ic_instruction')
  },
  {
    name: "settings",
    text: "设置",
    icon: $r('app.media.settings_icon')
  }
]