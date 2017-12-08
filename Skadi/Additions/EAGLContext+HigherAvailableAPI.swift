import GLKit

extension EAGLContext {

  // if returns nil then OpenGLES is not available on device
  static func makeContextWithHigherAvailableAPI() -> EAGLContext? {
    let apis: [EAGLRenderingAPI] = [.openGLES3, .openGLES2]
    for api in apis {
      if let glContext = EAGLContext(api: api) {
        return glContext
      }
    }
    return nil
  }
}
