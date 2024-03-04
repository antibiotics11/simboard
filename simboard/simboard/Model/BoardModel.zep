namespace SimBoard\Model;
use SimBoard\Database\PdoConnector;

final class BoardModel extends Model {

  public function __construct(const <PdoConnector> pdoConnector) {
    parent::__construct(pdoConnector);
  }

  /**
   * 게시판을 개설한다.
   *
   * @param string title 게시판 이름.
   * @param string adminEmail 게시판 개설자 이메일.
   * @return int|false
   */
  public function open(const string! title, const string! adminEmail) -> int|bool {

    string query  = "INSERT INTO board VALUES (DEFAULT, :title, :admin, DEFAULT, 0)";
    array  params = [
      ":title" : title->trim(),
      ":admin" : adminEmail->trim()
    ];

    if (this->pdoConnector->query(query, params) !== false) {
      return (int)this->getBoardsByAdminEmail(adminEmail)[0]["board_id"];
    }

    return false;

  }

  /**
   * 게시판을 폐쇄한다.
   *
   * @param int boardId 게시판 ID.
   * @return bool
   */
  public function close(const int! boardId) -> bool {

    string query  = "UPDATE board SET is_deleted=1 WHERE board_id=:board";
    array  params = [ ":board" : boardId ];

    return this->pdoConnector->query(query, params) !== false;

  }

  /**
   * 폐쇄된 게시판 목록을 가져온다.
   *
   * @return mixed[]
   */
  public function getClosedBoards() -> array {
    return this->pdoConnector->query(
      "SELECT * FROM board WHERE is_deleted=1 ORDER BY board_id DESC",
      []
    );
  }

  /**
   * 활성 게시판 목록을 가져온다.
   *
   * @return mixed[]
   */
  public function getActiveBoards() -> array {
    return this->pdoConnector->query(
      "SELECT * FROM board WHERE is_deleted=0 ORDER BY board_id DESC",
      []
    );
  }

  /**
   * 게시판 정보를 가져온다.
   *
   * @param string boardId 게시판 ID.
   * @return mixed[]|false
   */
  public function getBoardById(const string! boardId) -> array|bool {

    string query  = "SELECT * FROM board WHERE board_id=:board";
    array  params = [ ":board" : boardId ];

    var queryResult = this->pdoConnector->query(query, params);

    if (queryResult !== false && isset(queryResult[0])) {
      return queryResult[0];
    }

    return false;

  }

  /**
   * 게시판 관리자 정보를 가져온다.
   *
   * @param string boardId 게시판 ID.
   * @return mixed[]|false
   */
  public function getBoardAdminById(const string! boardId) -> array|bool {

    string query  = "SELECT * FROM member WHERE email=(SELECT admin_email FROM board WHERE board_id=:board)";
    array  params = [ ":board" : boardId ];

    var queryResult = this->pdoConnector->query(query, params);

    if (queryResult !== false && isset(queryResult[0])) {
      return queryResult[0];
    }

    return false;

  }

  /**
   * 특정 관리자가 개설한 게시판 목록을 가져온다.
   *
   * @param string adminEmail 관리자 이메일.
   * @return mixed[]
   */
  public function getBoardsByAdminEmail(const string! adminEmail) -> array {

    string query  = "SELECT * FROM board WHERE admin_email=:email ORDER BY board_id DESC";
    array  params = [ ":email" : adminEmail ];

    return this->pdoConnector->query(query, params);

  }

  /**
   * 게시판이 폐쇄되었는지 확인한다.
   *
   * @param int boardId 게시판 ID.
   * @return bool
   */
  public function isBoardClosed(const int! boardId) -> bool {

    string query  = "SELECT is_deleted FROM board WHERE board_id=:board";
    array  params = [ ":board" : boardId ];

    var queryResult = this->pdoConnector->query(query, params);

    if (queryResult !== false && isset(queryResult[0])) {
      return (bool)queryResult[0]["is_deleted"];
    }

    // 쿼리 실패하거나 존재하지 않는 게시판이면 항상 True 반환한다.
    return true;

  }

  /**
   * 게시판 관리자인지 확인한다.
   *
   * @param string boardId 게시판 ID.
   * @param string adminEmail 관리자 이메일.
   * @return bool
   */
  public function isBoardAdmin(const string! boardId, const string! adminEmail) -> bool {

    string query  = "SELECT admin_email FROM board WHERE board_id=:board";
    array  params = [ ":board" : boardId ];

    var queryResult = this->pdoConnector->query(query, params);

    if (queryResult !== false && isset(queryResult[0])) {
      return (string)queryResult[0]["admin_email"] === adminEmail;
    }

    return false;

  }

  /**
   * 게시글을 작성한다.
   *
   * @param int boardId 게시판 ID.
   * @param string content 게시글 본문.
   * @param string authorEmail 작성자 이메일.
   * @return bool
   */
  public function write(const int! boardId, const string! content, const string! authorEmail) -> bool {

    string query  = "INSERT INTO article VALUES (:board, DEFAULT, '', :email, DEFAULT, 0, :content, 0)";
    array  params = [
      ":board"   : boardId,
      ":email"   : authorEmail->trim(),
      ":content" : content->trim()
    ];

    return this->pdoConnector->query(query, params) !== false;

  }

  /**
   * 게시글을 삭제한다.
   *
   * @param int articleId 게시글 ID.
   * @return bool
   */
  public function delete(const int! articleId) -> bool {

    string query  = "DELETE FROM article WHERE article_id=:article";
    array  params = [ ":article" : articleId ];

    return this->pdoConnector->query(query, params) !== false;
  }

  public function getArticlesByBoardId(const int! boardId) -> array {

    string query  = "
      SELECT article.*, name AS author_name FROM article
      LEFT JOIN member ON article.author_email=member.email
      WHERE board_id=:board
      ORDER BY article_id ASC
      ";
    array  params = [ ":board" : boardId ];

    return this->pdoConnector->query(query, params);

  }

  public function getArticlesByKeyword(const string! keyword) -> array {

    string query  = "SELECT * FROM article WHERE content LIKE :keyword ORDER BY article_id ASC";
    array  params = [ ":keyword" : "\%%s\%"->format(keyword) ];

    return this->pdoConnector->query(query, params);

  }

}