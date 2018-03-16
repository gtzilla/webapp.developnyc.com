;(function() {
'use strict';

let tmpl_opts = {variable:'data'}
let index = {
  form_templated: _.template(templates.form_extension_tester, tmpl_opts),
  form_success_templated: _.template(templates.form_success, tmpl_opts),
  form_fail_templated: _.template(templates.form_fail, tmpl_opts)
}

function bind_alpha_tester_form($scope) {
  console.log("submit binding", $scope);
  $scope.find("form").submit(on_form_submit($scope));
  return $scope.find("form");
}

function bind_alpha_form_close($scope, $parent) {
  console.log("binding", $scope);
  $(".close_form_btn", $parent).click(function(e) {
    e.preventDefault();
    $scope.off("submit");
    $(".close_form_btn", $parent).off("click");
    $parent.html('');
  });
}

/**
  After form submit
*/
function bind_modal_close($scope) {
  $(".close_btn", $scope).click(function(e) {
    e.preventDefault();
    $(".close_btn", $scope).off("click");
    $scope.html('');
  });
}

function on_form_submit($scope) {
  return function(e) {
    e.preventDefault();
    let $project = $("input[name=project]", $scope);
    let $msg = $("textarea[name=message]", $scope);
    let $email = $("input[name=email]", $scope);
    let $form = $scope.find("form");
    // handle empty strings.
    let payload = {
      email:$email.val(), 
      message:$msg.val(), 
      project:$project.val(),
      "form-name":$form.attr("name")
    }

    if(!$email.get(0).validity.valid || !payload.email || !payload.message) {
      // console.log("bad input values");
      let html = index.form_fail_templated({
        message:"Please complete all fields."
      });
      $(".ui_feedback", $scope).html(html);
      return;
    }
    let prom = $.ajax({
      url:"/",
      method:"POST",
      data:payload
    });
    prom.then(function(data) {
      modal_success($scope, data);
    }, function() {
      console.log("ERROR!", arguments);
      let html = index.form_fail_templated({
        message:"Unknown error. Please report.",
        report:true
      });      
      $(".ui_feedback", $scope).html(html);
    });    
  }
}

function modal_success($scope, data) {
  $scope.html(index.form_success_templated(data));
  bind_modal_close($scope);  
}

function update_tester_form($scope) {
  let html = index.form_templated({});
  $scope.html(html);
}

function init() {
  console.log("init main.index.js");
  $(".extension_tester_prompt").click(function(e) {
    e.preventDefault();
    let $curr = $(".placeholder_tester_form");
    update_tester_form($curr);
    let $form = bind_alpha_tester_form($curr);
    $form.find("input[name=email]").focus();    
    bind_alpha_form_close($form, $curr);
  });
}

init();

})(this);