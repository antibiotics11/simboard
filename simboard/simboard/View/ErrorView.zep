namespace SimBoard\View;

final class ErrorView extends View {

  public function view(const array! data) -> string {

    string statusIcon = "/static/image/%s.png"->format(data["statusPhrase"]);
    let statusIcon = statusIcon->lower();
    let statusIcon = str_replace(" ", "_", statusIcon);

    return this->renderer->render(
      this->renderer->loadTemplate(
        "%s/template.html"->format(this->templatePath)
      ), [
        "main_content" : [
          "template"   : this->renderer->loadTemplate(
            "%s/error/error.html"->format(this->templatePath)
          ),
          "data"       : [
            "status_code"   : (string)data["statusCode"],
            "status_phrase" : data["statusPhrase"],
            "status_icon"   : statusIcon,
            "details"       : data["details"]
          ],
          "escapeHTML" : false
        ]
      ], false
    );

  }

}