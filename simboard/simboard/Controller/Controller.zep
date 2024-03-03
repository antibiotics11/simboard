namespace SimBoard\Controller;
use SimBoard\Http\Route;
use SimBoard\Model\Model;
use SimBoard\View\View;

abstract class Controller {

  /**
   * @var Model|null 컨트롤러에 연결된 모델.
   */
  protected model;

  /**
   * @var View|null 컨트롤러에 연결된 뷰.
   */
  protected view;

  /**
   * 요청 경로의 루트 디렉토리 구분자를 삭제하고, 소문자로 변환하여 반환한다.
   *
   * @param string requestUri 요청 경로.
   * @return string 변환된 경로.
   */
  protected function trimRequestUri(string! requestUri) -> string {

    let requestUri = requestUri->trimleft();
    let requestUri = requestUri->lower();
    let requestUri = substr(requestUri, 1);

    return requestUri;

  }

  /**
   * @param Model|null model 컨트롤러에 연결할 모델.
   * @param View|null view 컨트롤러에 연결할 뷰.
   */
  public function __construct(const <Model> model = null, const <View> view = null) {
    let this->model = model;
    let this->view = view;
  }

  abstract public function handle(const <Route> route, const array! globals) -> void;

  /**
   * 컨트롤러를 함수로 실행한다.
   *
   * @param mixed[] globals PHP 전역 변수 ($GLOBALS).
   * @param string[] uriMatches 패턴과 일치한 URI 정보.
   * @return void
   */
  public function __invoke(const <Route> route, const array! globals) -> void {
    this->handle(route, globals);
  }

}