import { speechRecognizer } from '@kit.CoreSpeechKit';

export class SpeechRecognizerManager {
  private engineParams: speechRecognizer.CreateEngineParams = {
    language: 'zh-CN',  // 目前系统API只支持设置中文
    online: 1,          // 目前系统API只支持离线模式
    extraParams: { 'locate': 'CN', 'recognizerMode': 'long' }   // 设置recognizerMode为长时模式，设置短时模式时说完一句话会自动结束识别
  };
  private asrEngine?: speechRecognizer.SpeechRecognitionEngine;
  private sessionId: string = 'SpeechRecognizer_' + Date.now();

  public async intiEngine() {
    if(canIUse("SystemCapability.AI.SpeechRecognizer")) this.asrEngine = await speechRecognizer.createEngine(this.engineParams);
    else console.log("不支持语音功能")
  }

  // 开始语音识别，并提供回调函数，用于返回结果
  public start(callback: (srr: speechRecognizer.SpeechRecognitionResult) => void = () => {}) {
    this.setListener(callback);
    this.startListening();
  }

  // 停止语音识别
  public stop() {
    this.asrEngine?.finish(this.sessionId);
  }

  public shutdown() {
    this.asrEngine?.shutdown();
  }

  // 启动监听
  private startListening() {
    let recognizerParams: speechRecognizer.StartParams = {
      sessionId: this.sessionId,
      audioInfo: { audioType: 'pcm', sampleRate: 16000, soundChannel: 1, sampleBit: 16 },
      extraParams: { recognitionMode: 0, maxAudioDuration: 60000 }
    }
    this.asrEngine?.startListening(recognizerParams);
  }

  private setListener(callback: (srr: speechRecognizer.SpeechRecognitionResult) => void = () => {}) {
    let listener: speechRecognizer.RecognitionListener = {
      onStart(sessionId: string, eventMessage: string) {
      },
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
      },
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        // 语音识别到结果后，通过回调函数将识别的结果返回
        callback && callback(result);
      },
      onComplete(sessionId: string, eventMessage: string) {
        // recognizerMode设置为短时模式时，如果仍需继续识别，需要在此处再次调用startListening，启动监听。
      },
      onError(sessionId: string, errorCode: number, errorMessage: string) {
      },
    }
    this.asrEngine?.setListener(listener);
  }
}

