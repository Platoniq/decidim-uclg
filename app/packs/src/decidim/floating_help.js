$(function() {
  if (!window.localStorage) {
    return;
  }

  let getDismissedHelpers = () => {
    let serialized = localStorage.getItem("dismissedHelpers");
    if (!serialized) {
      return [];
    }

    return serialized.split(",");
  };

  let addDismissedHelper = (id) => {
    let dismissedHelpers = getDismissedHelpers();

    if (!dismissedHelpers.includes(id)) {
      localStorage.setItem(
        "dismissedHelpers",
        [...dismissedHelpers, id].join(",")
      );
    }
  };

  let dismissedHelpers = getDismissedHelpers();

  $(".floating-helper-container").each((_index, elem) => {
    let id = $(elem).data("help-id");

    // dismiss by default
    $(".floating-helper", elem).foundation("hide");
    $(".floating-helper__wrapper", elem).foundation("hide");

    if (!dismissedHelpers.includes(id)) {
      $(".floating-helper", elem).foundation("toggle");
      $(".floating-helper__wrapper", elem).foundation("toggle");

      $(".floating-helper", elem).on("off.zf.toggler", () => {
        addDismissedHelper(id);
      });

      // Automatically addDismissedHelper after first visit
      addDismissedHelper(id);
    }
  });
});
