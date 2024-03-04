namespace SimBoard\Controller;
use SimBoard\Model\Model;
use SimBoard\View\View;
use SimBoard\Http\Session;
use SimBoard\Http\Route;
use SimBoard\Http\Method;
use SimBoard\Http\Response;
use SimBoard\Http\Exception\HttpBadRequest;
use SimBoard\Http\Exception\HttpForbidden;
use SimBoard\Http\Exception\HttpNotFound;
use SimBoard\Http\Exception\HttpInternalServerError;

final class BoardController extends Controller {

  public function handle(const <Route> route, const array! globals) -> void {

    string requestUri    = (string)this->trimRequestUri(route->getMatches()[0]);
    string requestMethod = (string)route->getMethod();
    int    targetBoardId = 0;

    if (isset route->getMatches()[2]) {
      let requestUri    = (string)route->getMatches()[1];
      let targetBoardId = (int)route->getMatches()[2];
    }

    if (requestMethod === Method::GET) {
      this->handleGet(requestUri, globals["_GET"], targetBoardId); return;
    } elseif (requestMethod === Method::POST) {
      this->handlePost(requestUri, globals["_POST"], targetBoardId); return;
    }

    throw new HttpBadRequest("잘못된 요청입니다.");

  }

  // GET 요청을 처리한다.
  private function handleGet(const string! uri, const array! params, const int! boardId) -> void {

    if (uri === "board") {
      if (boardId) {
        this->showBoard(params, boardId); return;
      } else {
        this->showList(params); return;
      }
    }

    throw new HttpNotFound("요청하신 자료를 찾을 수 없습니다.");

  }

  // 전체 게시판 목록을 조회한다.
  private function showList(const array! params) -> void {

    array activeBoards = (array)this->model->getActiveBoards();
    array closedBoards = (array)this->model->getClosedBoards();
    bool  isLoggedIn   = (bool)Session::has("email");

    Response::html(this->view->view([
      "page" : "list",
      "data" : [
        "active_boards" : activeBoards,
        "closed_boards" : closedBoards,
        "is_logged_in"  : isLoggedIn
      ]
    ]));

  }

  // 게시판 글 목록을 조회한다.
  private function showBoard(const array! params, const int! boardId) -> void {

    var userEmail = Session::get("email"); // string|null
    if (userEmail === null) {
      let userEmail = "";
    }

    array  articles      = (array)this->model->getArticlesByBoardId(boardId);
    array  boardDetails  = (array)this->model->getBoardById(boardId);
    array  adminDetails  = (array)this->model->getBoardAdminById(boardId);
    bool   isLoggedIn    = (bool)Session::has("email");
    bool   isBoardAdmin  = (bool)this->model->isBoardAdmin(boardId, userEmail);
    bool   isClosedBoard = (bool)this->model->isBoardClosed(boardId);

    Response::html(this->view->view([
      "page" : "board",
      "data" : [
        "articles"        : articles,
        "board_details"   : boardDetails,
        "admin_details"   : adminDetails,
        "is_logged_in"    : isLoggedIn,
        "is_board_admin"  : isBoardAdmin,
        "is_closed_board" : isClosedBoard,
        "user_email"      : (string)userEmail
      ]
    ]));

  }

  // POST 요청을 처리한다.
  private function handlePost(const string! uri, const array! params, const int! boardId) -> void {

    if (Session::has("email")) {   // 모든 POST 요청은 로그인한 사용자만 허용.
      switch (uri) {
        case "open"   : this->processOpen(params); return;
        case "close"  : this->processClose(params, boardId); return;
        case "write"  : this->processWrite(params, boardId); return;
        case "delete" : this->processDelete(params, boardId); return;
        default       : throw new HttpBadRequest("잘못된 요청입니다.");
      }
    }

    throw new HttpForbidden("먼저 로그인해주세요.");

  }

  // 게시판 개설을 처리한다.
  private function processOpen(const array! params) -> void {

    string boardTitle = (string)params["title"];
    string userEmail  = (string)Session::get("email");

    int boardId = (int)this->model->open(boardTitle, userEmail);
    if (!boardId) {
      throw new HttpInternalServerError("처리 중 오류가 발생했습니다.");
    }

    // 개설된 게시판으로 이동한다.
    Response::redirectTo("/board/%d"->format(boardId), false);

  }

  // 게시판 폐쇄를 처리한다.
  private function processClose(const array! params, const int! boardId) -> void {

    string userEmail = (string)Session::get("email");

    if (!this->model->isBoardAdmin(boardId, userEmail)) {
      throw new HttpForbidden("권한이 없습니다.");
    }

    if (!this->model->close(boardId)) {
      throw new HttpInternalServerError("처리 중 오류가 발생했습니다.");
    }

    // 폐쇄된 게시판으로 이동한다.
    Response::redirectTo("/board/%d"->format(boardId), false);

  }

  // 글 작성을 처리한다.
  private function processWrite(const array! params, const int! boardId) -> void {

    string content   = (string)params["content"];
    string userEmail = (string)Session::get("email");

    if (this->model->isBoardClosed(boardId)) {
      throw new HttpForbidden("작성할 수 없습니다.");
    }

    if (!this->model->write(boardId, content, userEmail)) {
      throw new HttpInternalServerError("처리 중 오류가 발생했습니다.");
    }

    // 게시판을 새로고침한다.
    Response::redirectTo("/board/%d"->format(boardId), false);

  }

  private function processDelete(const array! params, const int! articleId) -> void {

    /**
     * 구현 예정
     */

    throw new HttpBadRequest("잘못된 요청입니다.");

  }

}