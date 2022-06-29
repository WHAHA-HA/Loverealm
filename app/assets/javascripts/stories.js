$(document).ready(function() {
  $('.story-cancel').click(function () {
    // $(".input #story_title").attr('value') = "";
    // $(".input #story_body").attr('value') = "";
    console.log($(".input").val());
  });

  // $("#new_post_status").submit(function () {
  //   var descInput = $('#post_status_description').val();
  //   if (descInput === "") {
  //     $('#statusError').show();
  //     $('#statusError').prev('.form-group').css('border', '2px solid red');
  //     return false;
  //   }else{
  //     return true;
  //   }
  // });

  $("#new_story").submit(function () {
    var imageVal = $("#story_post_image").val();
    var titleVal = $("#story_title").val();
    var descVal = $("#story_body").val();
    if (titleVal === "") {
      $('#titleError').show();
      $('#titleError').prev('.form-group').css('border', '2px solid red');
      return false;
    }else{
     $('#titleError').hide();
     $('#titleError').prev('.form-group').css('border', '0');
    }
    if (descVal === ""){
      $('#descError').show();
      $('#descError').prev('.form-group').css('border', '2px solid red');
      return false;
    }else{
      $('#titleError').hide();
      $('#titleError').prev('.form-group').css('border', '0');
    }

   return true;
  });

  // $("#picture_form").submit(function () {
  //   var imageVal = $("#postPicture").val();
  //   if (!imageVal.match(/(?:jpg|jpeg|gif|png)$/)) {
  //     $('#imageError').show();
  //     $('#imageError').prev('.form-group').css('border', '2px solid red');
  //     return false;
  //   }else{
  //     return true;
  //   }
  // });
});
