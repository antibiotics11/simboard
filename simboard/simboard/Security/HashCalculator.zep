namespace SimBoard\Security;
use Throwable;

final class HashCalculator {

  /**
   * @param string algorithm
   * @param string content
   * @return string
   */
  public static function calculate(const string! algorithm, const string content) -> string {
    return mb_convert_encoding(hash(algorithm, content, false), "UTF-8");
  }

  /**
   * PHP가 지원하는 모든 알고리즘을 사용해 문자열의 해시를 계산한다.
   *
   * @param string content
   * @return string[]
   */
  public static function calculateAll(const string! content) -> array {

    var algorithm;
    var algorithms = hash_algos();
    array hashes = [];

    for algorithm in algorithms {
      let hashes[] = self::calculate(content, (string)algorithm);
    }

    return hashes;

  }

  public static function md5(const string! content) -> string {
    return self::calculate("md5", content);
  }

  public static function crc32(const string! content) -> string {
    return self::calculate("crc32", content);
  }

  public static function sha1(const string! content) -> string {
    return self::calculate("sha1", content);
  }

  public static function sha256(const string! content) -> string {
    return self::calculate("sha256", content);
  }

  private function __construct() {}

}
