namespace SimBoard\Model;
use SimBoard\Database\PdoConnector;

abstract class Model {

  /**
   * @var PdoConnector
   */
  protected pdoConnector;

  public function __construct(const <PdoConnector> pdoConnector) {
    let this->pdoConnector = pdoConnector;
  }

}