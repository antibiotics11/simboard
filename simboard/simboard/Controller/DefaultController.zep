namespace SimBoard\Controller;
use SimBoard\Http\Route;
use SimBoard\Http\Method;
use SimBoard\Http\Response;
use SimBoard\Http\Exception\HttpBadRequest;
use SimBoard\Http\Exception\HttpNotFound;

final class DefaultController extends Controller {

  // DefaultController로 수신된 요청을 처리한다.
  public function handle(const <Route> route, const array! globals) -> void {

    string requestUri    = (string)this->trimRequestUri(route->getMatches()[0]);
    string requestMethod = (string)route->getMethod();

    // 요청 메소드가 GET인 경우
    if (requestMethod == Method::GET) {
      switch (requestUri) {
        case ""            :
        case "index.html"  :
        case "index.php"   : this->index();   return;
        case "robots.txt"  : this->robots();  return;
        case "favicon.ico" : this->favicon(); return;
        case "login"       : this->login();   return;
        case "logout"      : this->logout();  return;
        default            : this->getAll();  return;
      }
    }

    // 기타 모든 요청
    this->all();

  }

  // 인덱스 페이지로 리디렉션한다.
  private function index() -> void {
    Response::redirectTo("/board", true);
  }

  // robots.txt 파일 위치로 리디렉션한다.
  private function robots() -> void {
    Response::redirectTo("/static/robots.txt", true);
  }

  // favicon.ico 파일 위치로 리디렉션한다.
  private function favicon() -> void {
    Response::redirectTo("/static/favicon.ico", true);
  }

  // /login은 /signin으로 리디렉션한다.
  private function login() -> void {
    Response::redirectTo("/signin", true);
  }

  // /logout은 /signout으로 리디렉션한다.
  private function logout() -> void {
    Response::redirectTo("/signout", true);
  }

  // 정의되지 않은 GET 요청은 404 Not Found
  private function getAll() -> void {
    throw new HttpNotFound("요청하신 자료를 찾을 수 없습니다.");
  }

  // 정의되지 않은 요청에 대해 400 Bad Request 응답을 전송한다.
  private function all() -> void {
    throw new HttpBadRequest("잘못된 요청입니다.");
  }

}