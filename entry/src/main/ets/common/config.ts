export class AppConfig {

  private static readonly BASE_URL = "http://10.212.253.234:30020/api/v1"

  // 所有接口端点
  static readonly API_ENDPOINTS = {
    sendTask: `${this.BASE_URL}/setTask`,
    sendSubTask :`${this.BASE_URL}/setAssign`,
    getAction :`${this.BASE_URL}/setActions`
  }

  static readonly TIMEOUT = 30000
}