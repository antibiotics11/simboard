namespace SimBoard\View;

final class BoardView extends View {

  /**
   * 게시판 목록을 렌더링하여 반환한다.
   */
  public function list(const array! data) -> string {

    array  activeBoards    = [];
    array  closedBoards    = [];
    string displayOpenForm = "none";

    if (isset data["active_boards"] && is_array(data["active_boards"])) {
      let activeBoards = (array)data["active_boards"];
    }
    if (isset data["closed_boards"] && is_array(data["closed_boards"])) {
      let closedBoards = (array)data["closed_boards"];
    }
    if (isset data["is_logged_in"] && is_bool(data["is_logged_in"])) {
      let displayOpenForm = data["is_logged_in"] ? "inline" : "none";
    }

    return this->renderer->render(
      this->renderer->loadTemplate(
        "%s/board/list.html"->format(this->templatePath)
      ), [
        "display_open_form"   : displayOpenForm,
        "active_boards"       : this->listBoards(activeBoards),
        "active_boards_count" : "%d"->format(count(activeBoards)),
        "closed_boards"       : this->listBoards(closedBoards),
        "closed_boards_count" : "%d"->format(count(closedBoards))
      ]
    );

  }

  private function listBoards(const array! boards) -> string {

    if (count(boards) === 0) {
      return "";
    }

    string template = (string)this->renderer->loadTemplate(
      "%s/board/list_element.html"->format(this->templatePath)
    );
    string rendered = "";
    var    board    = [];

    for board in boards {
      let rendered = "%s%s"->format(rendered,
        this->renderer->render(template, [
          "board_title" : htmlspecialchars("%s"->format(board["board_title"])),
          "board_id"    : "%d"->format(board["board_id"]),
          "created_at"  : "%s"->format(explode(" ", board["created_at"])[0])
        ])
      );
    }

    return rendered;

  }

  /**
   * 게시판의 글 목록을 렌더링하여 반환한다.
   */
  public function board(const array! data) -> string {
    printf("%s", json_encode(data, JSON_PRETTY_PRINT));
    return "";
  }

  public function view(const array! data) -> string {

    string rendered = "";
    array matchingViewer = [ this, (string)data["page"] ];

    if (is_callable(matchingViewer)) {
      let rendered = (string)call_user_func(matchingViewer, data["data"]);
    }

    return this->renderer->render(
      this->renderer->loadTemplate("%s/template.html"->format(this->templatePath)),
      [ "main_content" : rendered ]
    );

  }

}