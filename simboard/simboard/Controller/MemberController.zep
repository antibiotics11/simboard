namespace SimBoard\Controller;
use SimBoard\Model\Model;
use SimBoard\View\View;
use SimBoard\Http\Session;
use SimBoard\Http\Route;
use SimBoard\Http\Method;
use SimBoard\Http\Response;
use SimBoard\Http\Exception\HttpBadRequest;
use SimBoard\Http\Exception\HttpInternalServerError;

final class MemberController extends Controller {

  public function handle(const <Route> route, const array! globals) -> void {

    string requestUri      = (string)this->trimRequestUri(route->getMatches()[0]);
    string requestMethod   = (string)route->getMethod();
    var    matchingHandler = ""; // string|callable

    if (requestMethod == Method::GET) {
      let matchingHandler = "show%s"->format(requestUri->upperfirst());
    } elseif (requestMethod == Method::POST) {
      let matchingHandler = "process%s"->format(requestUri->upperfirst());
    }

    // 요청과 일치하는 핸들러 함수가 있다면 호출한다.
    let matchingHandler = [ this, matchingHandler ];
    if (!is_callable(matchingHandler)) {
      throw new HttpBadRequest("잘못된 요청입니다.");
    }

    call_user_func(matchingHandler, globals);

  }

  // 로그인 페이지를 출력한다.
  public function showSignin(const array! globals) -> void {

    if (Session::has("email")) {
      Response::redirectTo("/profile", false);
      return;
    }

    Response::html(this->view->view([ "page" : "signin", "data" : [] ]));

  }

  // 로그인을 처리한다.
  public function processSignin(const array! globals) -> void {

    if (Session::has("email")) {
      throw new HttpBadRequest("잘못된 요청입니다.");
    }

    string inputEmail    = (string)globals["_POST"]["email"];
    string inputPassword = (string)globals["_POST"]["password"];
    string signinResult  = "false";

    if (this->model->authenticate(inputEmail, inputPassword)) {
      Session::set("email", inputEmail);
      let signinResult = "true";
    }

    Response::html(this->view->view([
      "page" : "signin_result",
      "data" : [ "signin_result" : signinResult ]
    ]));

  }

  // 회원가입 페이지를 출력한다.
  public function showSignup(const array! globals) -> void {

    if (Session::has("email")) {
      Response::redirectTo("/profile", false);
      return;
    }

    Response::html(this->view->view([ "page" : "signup", "data" : [] ]));

  }

  // 회원가입을 처리한다.
  public function processSignup(const array! globals) -> void {

    if (Session::has("email")) {
      throw new HttpBadRequest("잘못된 요청입니다.");
    }

    string inputEmail    = (string)globals["_POST"]["email"];
    string inputName     = (string)globals["_POST"]["name"];
    string inputPassword = (string)globals["_POST"]["password"];
    string signupResult  = "false";

    if (this->model->create(inputEmail, inputName, inputPassword)) {
      let signupResult = "true";
    }

    Response::html(this->view->view([
      "page" : "signup_result",
      "data" : [ "signup_result" : signupResult ]
    ]));

  }

  // 계정 정보를 조회한다.
  public function showProfile(const array! globals) -> void {

    if (!Session::has("email")) {
      Response::redirectTo("/signin", false);
      return;
    }

    string userEmail = (string)Session::get("email");
    string userName  = (string)this->model->getByEmail(userEmail)["name"];

    Response::html(this->view->view([
      "page" : "profile",
      "data" : [ "user_email" : userEmail, "user_name" : userName ]
    ]));

  }

  // 로그아웃을 처리한다.
  public function showSignout(const array! globals) -> void {

    if (!Session::has("email")) {
      Response::redirectTo("/signin", false);
      return;
    }

    Session::remove("email");
    Response::redirectTo("/signin", false);

  }

  // 회원탈퇴를 처리한다.
  public function showWithdraw(const array! globals) -> void {

    if (!Session::has("email")) {
      Response::redirectTo("/signin", false);
      return;
    }

    string userEmail = (string)Session::get("email");

    if (!this->model->delete(userEmail)) {
      throw new HttpInternalServerError("처리 중 오류가 발생했습니다.");
    }

    Session::remove("email");
    Response::redirectTo("/signin", false);

  }

}