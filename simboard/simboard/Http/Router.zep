namespace SimBoard\Http;
use SimBoard\Http\Exception\HttpNotFound;

final class Router {

  /**
   * @var Route[] 라우팅 테이블.
   */
  private routes;

  public function __construct() {
    let this->routes = [];
  }

  /**
   * 패턴이 URI와 일치하는지 확인한다.
   *
   * @param string pattern
   * @param string uri
   * @return string[] | false
   */
  private function patternMatches(string! pattern, const string! uri) -> array | bool {

    var param = "";
    array matches = [];
    array params = [];

    // 패턴에서 {param} 형식을 (.*?)로 치환한다.
    let pattern = preg_replace("/\/{(.*?)}/", "/(.*?)", pattern);
    let pattern = "#^%s$#"->format(pattern);
    if (preg_match_all(pattern, uri, matches, PREG_OFFSET_CAPTURE)) {
      let matches = array_column(matches, 0);
      for param in matches {
        let params[] = (string)param[0];
      }
      return params;
    }
    return false;

  }

  /**
   * 메서드, 패턴 및 핸들러로 라우트를 추가한다.
   *
   * @param string[] methods
   * @param string pattern
   * @param callable handler
   * @return void
   */
  public function match(const array! methods, const string! pattern, const callable! handler) -> void {
    var method = null;
    for method in methods {
      let this->routes[] = new Route((string)method, pattern, handler);
    }
  }

  // GET 요청에 대한 라우트를 추가한다.
  public function get(const string! pattern, const callable! handler) -> void {
    this->match([ Method::GET ], pattern, handler);
  }

  // POST 요청에 대한 라우트를 추가한다.
  public function post(const string! pattern, const callable! handler) -> void {
    this->match([ Method::POST ], pattern, handler);
  }

  // 모든 메서드에 대한 라우트를 추가한다.
  public function all(const string! pattern, const callable! handler) -> void {
    this->match([
      Method::GET,
      Method::HEAD,
      Method::POST,
      Method::PUT,
      Method::DELETE,
      Method::CONNECT,
      Method::OPTIONS,
      Method::TRACE,
      Method::PATCH
    ], pattern, handler);
  }

  /**
   * 라우터를 실행한다.
   *
   * @param array phpGlobals
   * @return void
   * @throws HttpNotFound
   */
  public function run(const array! phpGlobals) -> void {

    string requestMethod = "GET";
    string requestUri = "/";
    var route = null;
    var matches = false;

    // 요청 메서드를 확인한다.
    if (isset phpGlobals["_SERVER"]["REQUEST_METHOD"]) {
      let requestMethod = (string)phpGlobals["_SERVER"]["REQUEST_METHOD"];
      let requestMethod = requestMethod->upper();
    }

    // 요청 URI를 확인한다.
    if (isset phpGlobals["_SERVER"]["REQUEST_URI"]) {
      let requestUri = (string)phpGlobals["_SERVER"]["REQUEST_URI"];
      let requestUri = requestUri->trim();
    }

    for route in this->routes {

      // 요청 경로와 일치하는 라우트 찾으면 핸들러를 실행한다.
      let matches = this->patternMatches(route->getPattern(), requestUri);
      if (matches != false) {
        if (route->getMethod() !== requestMethod) {
          continue;
        }
        route->setMatches(matches);
        call_user_func(route->getHandler(), <Route> route, phpGlobals);
        return;
      }

    }

    // 일치하는 라우트가 없는 경우
    throw new HttpNotFound("No handler found for '%s'."->format(requestUri));

  }

}