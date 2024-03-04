namespace SimBoard;
use SimBoard\Controller\MemberController;
use SimBoard\Controller\BoardController;
use SimBoard\Controller\ErrorController;
use SimBoard\Controller\StaticController;
use SimBoard\Controller\DefaultController;
use SimBoard\Database\PdoConnector;
use SimBoard\Model\MemberModel;
use SimBoard\Model\BoardModel;
use SimBoard\View\Renderer;
use SimBoard\View\MemberView;
use SimBoard\View\BoardView;
use SimBoard\View\ErrorView;
use SimBoard\Http\Router;
use SimBoard\Http\Exception\HttpErrorException;
use Throwable;

final class SimBoardService {

  /**
   * @var SimBoard\Http\Router
   */
  private router;

  /**
   * @var SimBoard\Database\PdoConnector
   */
  private pdoConnector;

  /**
   * @var SimBoard\View\Renderer
   */
  private renderer;

  /**
   * @var SimBoard\Controller\Controller[]
   */
  private controllers;

  /**
   * @var SimBoard\Model\Model[]
   */
  private models;

  /**
   * @var SimBoard\View\View[]
   */
  private views;

  /**
   * @param mixed[] appConfig 서비스 설정.
   */
  public function __construct(const array! appConfig) {

    string dbHostname    = (string)appConfig["MYSQL"]["HOST"];
    string dbName        = (string)appConfig["MYSQL"]["DBNAME"];
    string dbUsername    = (string)appConfig["MYSQL"]["USERNAME"];
    string dbPassword    = (string)appConfig["MYSQL"]["PASSWORD"];

    string templatesPath = (string)appConfig["PATH"]["VIEW_TEMPLATES"];
    string assetsPath    = (string)appConfig["PATH"]["STATIC_RESOURCES"];

    let this->renderer        = new Renderer();
    let this->views["member"] = new MemberView(this->renderer, templatesPath);
    let this->views["board"]  = new BoardView(this->renderer, templatesPath);
    let this->views["error"]  = new ErrorView(this->renderer, templatesPath);

    let this->pdoConnector     = new PdoConnector(dbHostname, dbName, dbUsername, dbPassword);
    let this->models["member"] = new MemberModel(this->pdoConnector);
    let this->models["board"]  = new BoardModel(this->pdoConnector);

    let this->controllers["member"]  = new MemberController(this->models["member"], this->views["member"]);
    let this->controllers["board"]   = new BoardController(this->models["board"], this->views["board"]);
    let this->controllers["error"]   = new ErrorController(null, this->views["error"]);
    let this->controllers["static"]  = new StaticController(assetsPath);
    let this->controllers["default"] = new DefaultController(null, null);

    let this->router = new Router();

  }

  /**
   * 라우팅 테이블을 정의한다.
   *
   * @return void
   */
  private function defineRoutes() -> void {
    this->router->get("/signin",          this->controllers["member"]);   // 로그인 페이지
    this->router->post("/signin",         this->controllers["member"]);   // 로그인 처리
    this->router->get("/signup",          this->controllers["member"]);   // 회원가입 페이지
    this->router->post("/signup",         this->controllers["member"]);   // 회원가입 처리
    this->router->get("/profile",         this->controllers["member"]);   // 프로필 조회
    this->router->get("/signout",         this->controllers["member"]);   // 로그아웃 처리
    this->router->get("/withdraw",        this->controllers["member"]);   // 회원탈퇴 처리
    this->router->get("/(board)",         this->controllers["board"]);    // 게시판 목록 페이지
    this->router->post("/(open)",         this->controllers["board"]);    // 게시판 개설 처리
    this->router->post("/(close)/(\d+)",  this->controllers["board"]);    // 게시판 폐쇄 처리
    this->router->get("/(board)/(\d+)",   this->controllers["board"]);    // 포스트 목록 페이지
    this->router->post("/(write)/(\d+)",  this->controllers["board"]);    // 포스트 작성 처리
    this->router->post("/(delete)/(\d+)", this->controllers["board"]);    // 포스트 삭제 처리
    this->router->get("/static/(.*)",     this->controllers["static"]);   // 정적 리소스 처리
    this->router->all("(.*)",             this->controllers["default"]);  // 기타 요청 처리
  }

  /**
   * HttpErrorException을 ErrorController에 할당한다.
   *
   * @param Throwable ex
   * @return void
   * @throws Throwable
   */
  public function handleException(const <Throwable> ex) -> void {
    if (ex instanceof HttpErrorException) {
      this->controllers["error"]->handleHttpError(ex);
    } else {
      throw ex;
    }
  }

  /**
   * 서비스를 실행한다.
   *
   * @param array _SERVER  $_SERVER
   * @param array _GET     $_GET
   * @param array _POST    $_POST
   * @param array _FILES   $_FILES
   * @param array _REQUEST $_REQUEST
   * @param array _SESSION $_SESSION
   * @param array _ENV     $_ENV
   * @param array _COOKIE  $_COOKIE
   * @return void
   */
  public function run(
    const array! _SERVER,
    const array! _GET     = [],
    const array! _POST    = [],
    const array! _FILES   = [],
    const array! _REQUEST = [],
    const array! _SESSION = [],
    const array! _ENV     = [],
    const array! _COOKIE  = []
  ) -> void {
    this->defineRoutes();
    this->router->run([
      "_SERVER"  : _SERVER,
      "_GET"     : _GET,
      "_POST"    : _POST,
      "_FILES"   : _FILES,
      "_REQUEST" : _REQUEST,
      "_SESSION" : _SESSION,
      "_ENV"     : _ENV,
      "_COOKIE"  : _COOKIE
    ]);
  }

}
