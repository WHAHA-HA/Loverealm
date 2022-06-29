// $(document).ready(function() {
//   $("body").on('click', '.tab-content .editable', function(e){
//     e.preventDefault();
//     var $this = $(this);
//     var a = $this.parent('.tab-content').siblings('.modal').find('#contentVal').data('content');
//     var $form = $('#content_image_form_'+a);
//     $this.parent().siblings('.img-big.modal').modal('show');
//     $form.fileupload({
//       dataType: 'json',
//       url: $form.attr('action'),
//       method: 'PUT',
//       maxFileSize: 2000000,
//       add: function (event, data) {
//         data.context = $("<table id='overlay'><tbody id='overlay-body'><tr id='overlay-first-row'><td id='overlay-text'></td></tr></tbody></table>").css({
//           "position": "fixed",
//           "top": 0,
//           "left": 0,
//           "width": "100%",
//           "height": "100%",
//           "background-color": "rgba(0,0,0,.5)",
//           "z-index": 10000,
//           "vertical-align": "middle",
//           "text-align": "center",
//           "color": "#fff",
//           "font-size": "30px",
//           "font-weight": "bold",
//           "cursor": "wait"}).appendTo(document.body);

//         data.submit();
//       },
//       fail: function(event, data) {
//         var responseText = $.parseJSON(data.jqXHR.responseText);
//         var errors = responseText.errors;

//         $('#overlay').css({ "cursor": "auto" });
//         $('#overlay-first-row').remove();

//         for(i = 0; i < errors.length; i++) {
//           $('#overlay-body').append($("<tr><td id='try-again-button'>" + errors[i] + '<br />Try again' +'</td></tr>'));
//         }

//         $('#try-again-button').on('click', function() {
//           $("#overlay").remove();
//         });
//       },
//       done: function (event, data) {
//         $('#pictureInput').attr("src", data.result.avatar_original);
//         $("#overlay").remove();
//         location.reload();
//       }
//     });
//   });
// })
