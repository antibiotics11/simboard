namespace SimBoard\Resource;

abstract class Content {

  protected type    { set, get };
  protected content { get };
  protected bytes   { get };
  protected length  { get };

  public function setContent(const string! content) -> void {
    let this->content = content;
    let this->bytes   = content->length();
    let this->length  = mb_strlen(content);
  }

}