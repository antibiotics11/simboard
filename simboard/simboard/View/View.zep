namespace SimBoard\View;

abstract class View {

  /**
   * @var Renderer 렌더링에 사용할 렌더러.
   */
  protected renderer;

  /**
   * @var string 렌더링할 템플릿 파일 경로.
   */
  protected templatePath { get };

  /**
   * @param Renderer renderer 렌더링에 사용할 렌더러.
   * @param string templatePath 렌더링할 템플릿 파일 경로.
   */
  public function __construct(const <Renderer> renderer, const string! templatePath) {
    let this->renderer = renderer;
    let this->templatePath = templatePath;
  }

  abstract public function view(const array! data) -> string;

}