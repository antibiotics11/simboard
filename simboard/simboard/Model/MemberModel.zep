namespace SimBoard\Model;
use SimBoard\Database\PdoConnector;
use SimBoard\Security\HashCalculator;

final class MemberModel extends Model {

  public function __construct(const <PdoConnector> pdoConnector) {
    parent::__construct(pdoConnector);
  }

  /**
   * 새 계정을 추가한다.
   *
   * @param string email 이메일.
   * @param string name 사용자 이름.
   * @param string password 패스워드.
   * @return bool
   */
  public function create(const string! email, const string! name, const string! password) -> bool {

    string query  = "INSERT INTO member VALUES (:email, :name, :password, 1, DEFAULT)";
    array  params = [
      ":email"    : email->trim(),
      ":name"     : name->trim(),
      ":password" : HashCalculator::sha256(password->trim())
    ];

    return this->pdoConnector->query(query, params) !== false;

  }

  /**
   * 계정을 삭제한다.
   *
   * @param string email 삭제할 계정의 이메일.
   * @return bool
   */
  public function delete(const string! email) -> bool {

    string query  = "DELETE FROM member WHERE email=:email";
    array  params = [ ":email" : email->trim() ];

    return this->pdoConnector->query(query, params) !== false;

  }

  /**
   * 이메일로 계정 정보를 가져온다.
   *
   * @param string email 이메일.
   * @return string[]|null 계정 정보 또는 null.
   */
  public function getByEmail(const string! email) -> array|null {

    string query       = "SELECT * FROM member WHERE email = :email";
    array  params      = [ ":email" : email->trim() ];
    var    queryResult = this->pdoConnector->query(query, params);

    if (array_key_exists(0, queryResult)) {
      return queryResult[0];
    }
    return null;

  }

  /**
   * 패스워드가 계정 정보와 일치하는지 확인한다.
   *
   * @param string email 이메일.
   * @param string password 확인할 패스워드.
   */
  public function authenticate(const string! email, const string! password) -> bool {

    var userInfo = this->getByEmail(email);

    if (userInfo === null) {
      return false;
    }

    return HashCalculator::sha256(password->trim()) === userInfo["password"];

  }

}