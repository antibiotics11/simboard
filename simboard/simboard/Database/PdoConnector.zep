namespace SimBoard\Database;
use \PDO; // 빌드시 신택스 에러 발생하므로 전체 네임스페이스 기입해야 함. PDO (x) -> \PDO (o)
use PDOStatement;
use PDOException;

final class PdoConnector {

  /**
   * @var PDO PDO 인스턴스.
   */
  private pdo;

  /**
   * @var string 마지막으로 발생한 오류.
   */
  private lastError { get };

  /**
   * @param string host DB 주소.
   * @param string dbName DB 이름.
   * @param string userName DB 사용자 이름.
   * @param string password DB 사용자 패스워드.
   */
  public function __construct(
    const string! host,
    const string! dbName,
    const string! userName,
    const string! password
  ) {

    array pdoOptions = [];
    var e = null;

    // 초기화 명령어를 설정한다.
    let pdoOptions[\PDO::MYSQL_ATTR_INIT_COMMAND]       = "SET NAMES utf8mb4";
    // Buffered Query를 사용한다.
    let pdoOptions[\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY] = true;
    // Prepare Statements 에뮬레이션을 사용한다.
    let pdoOptions[\PDO::ATTR_EMULATE_PREPARES]         = true;
    // 자동으로 Commit 한다.
    let pdoOptions[\PDO::ATTR_AUTOCOMMIT]               = true;
    // 오류 발생 시 Exception을 발생시킨다.
    let pdoOptions[\PDO::ATTR_ERRMODE]                  = \PDO::ERRMODE_EXCEPTION;
    // Fetch 결과를 연관 배열로 반환한다.
    let pdoOptions[\PDO::ATTR_DEFAULT_FETCH_MODE]       = \PDO::FETCH_ASSOC;

    try {
      // PDO 인스턴스를 생성한다.
      let this->pdo = new \PDO(
        "mysql:host=%s;dbname=%s;charset=utf8"->format(host, dbName),
        userName, password,
        pdoOptions
      );
    } catch PDOException, e {
      let this->lastError = e->getMessage();
    }

  }

  /**
   * 쿼리를 실행하고 결과를 반환한다.
   *
   * @param string query 실행할 SQL문.
   * @param string[] params 바인딩할 파라미터.
   */
  public function query(const string! query, const array! params = []) -> mixed {

    var statement = null;
    var result = false;
    var paramKey = 0;
    var paramValue = "";
    var e = null;

    try {

      let statement = <PDOStatement> this->pdo->prepare(query);

      // 파라미터를 바인딩한다.
      for paramKey, paramValue in params {
        statement->bindValue(paramKey, paramValue);
      }

      // 쿼리를 실행하고 결과를 가져온다.
      statement->execute();
      let result = statement->fetchAll();

      // 커서를 닫는다.
      statement->closeCursor();

    // PDOException 발생 시, 오류 메시지를 lastError에 저장한다.
    } catch PDOException, e {
      let this->lastError = e->getMessage();
    }

    return result;

  }

}
